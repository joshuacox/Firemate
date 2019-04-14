.PHONY: all help build run builddocker rundocker kill rm-image rm clean enter logs

all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make run       - build and run docker container
	@echo ""   2. make build     - build docker container
	@echo ""   3. make clean     - kill and remove docker container
	@echo ""   4. make enter     - execute an interactive bash in docker container
	@echo ""   3. make logs      - follow the logs of docker container

build: NAME TAG builddocker

# run a plain container
run: build rm rundocker

temp: build temprm tempdocker

rundocker: TAG NAME HOMEDIR NICENESS LINK
	$(eval TMP := $(shell mktemp -d --suffix=chromeTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval HOME := $(shell cat HOMEDIR))
	$(eval TAG := $(shell cat TAG))
	$(eval NICENESS := $(shell cat NICENESS))
	$(eval PROXY := $(shell cat PROXY))
	xhost +
	mkdir -p "${HOME}/.firefox/cache"
	mkdir -p "${HOME}/.firefox/mozilla"
	mkdir -p "${HOME}/Downloads"
	mkdir -p "${HOME}/Pictures"
	mkdir -p "${HOME}/Torrents"
	mkdir -p $(HOME)/tmp
	sudo chown -R 999:999 $(HOME)
	sudo chown -R 999:999 $(TMP)
	sudo chmod -R 770 $(HOME)
	sudo chmod -R 770 $(TMP)
	@docker run -d --name=$(NAME) \
	--cidfile="firefoxCID" \
	--memory 2gb \
	--net host \
	--cpuset-cpus 0 \
	-v /etc/localtime:/etc/localtime:ro \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v "${HOME}/.firefox/cache:/root/.cache/mozilla" \
	-v "${HOME}/.firefox/mozilla:/root/.mozilla" \
	-v "${HOME}/Downloads:/root/Downloads" \
	-v "${HOME}/Pictures:/root/Pictures" \
	-v "${HOME}/Torrents:/root/Torrents" \
	-e "DISPLAY=unix${DISPLAY}" \
	-e GDK_SCALE \
	-e GDK_DPI_SCALE \
	--device /dev/snd \
	--device /dev/dri \
	--name firefox \
	jess/firefox "$@"

tempdocker: TAG NAME
	$(eval TMP := $(shell mktemp -d --suffix=tempchromeTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval TAG := $(shell cat TAG))
	$(eval PROXY := $(shell cat PROXY))
	$(eval NICENESS := $(shell cat NICENESS))
	mkdir -p $(TMP)/chrome-sandbox/Downloads
	mkdir -p $(TMP)/chrome-sandbox/Pictures
	mkdir -p $(TMP)/chrome-sandbox/Torrents
	mkdir -p $(TMP)/chrome-sandbox/.chrome
	mkdir -p $(TMP)/tmp
	xhost +
	sudo chmod -R 770 $(TMP)
	sudo chown -R 999:999 $(TMP)
	@docker run -d --name=$(NAME)-temp \
	--cidfile="tempCID" \
	-v $(TMP)/tmp:/tmp \
	--memory 3gb \
	--cpus 1 \
	--net host \
	-v /etc/localtime:/etc/localtime:ro \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=unix$(DISPLAY) \
	-e NICENESS=$(NICENESS) \
	-v /dev/shm:/dev/shm \
	-v /etc/hosts:/etc/hosts \
	-v $(TMP)/chrome-sandbox/Downloads:/root/Downloads \
	-v $(TMP)/chrome-sandbox/Pictures:/root/Pictures \
	-v $(TMP)/chrome-sandbox/Torrents:/root/Torrents \
	-v $(TMP)/chrome-sandbox/.chrome:/data \
	--security-opt seccomp:/etc/docker/seccomp/chrome.json \
	--device /dev/snd \
	--device /dev/dri \
	--device /dev/bus/usb \
	--group-add audio \
	--group-add video \
	-t $(TAG)

	#-e DISPLAY=unix$(DISPLAY)

builddocker:
	/usr/bin/time -v docker build -t `cat TAG` .

kill:
	-@docker kill `cat paraviewCID`

rm-image:
	-@docker rm `cat paraviewCID`
	-@rm paraviewCID

rm: kill rm-image

clean: rm

enter:
	docker exec -i -t `cat paraviewCID` /bin/bash

logs:
	docker logs -f `cat paraviewCID`

# temp stuff
tempkill:
	-@docker kill `cat tempCID`

temp-rm-image:
	-@docker rm `cat tempCID`
	-@rm tempCID

temprm: tempkill temp-rm-image

tempclean: temprm

tempenter:
	docker exec -i -t `cat tempCID` /bin/bash

templogs:
	docker logs -f `cat tempCID`

proxy: PROXY

PROXY:
	@while [ -z "$$PROXY" ]; do \
		read -r -p "Enter the proxy you wish to associate with this container [PROXY]: " PROXY; echo "$$PROXY">>PROXY; cat PROXY; \
	done ;

HOMEDIR:
	@while [ -z "$$HOMEDIR" ]; do \
		read -r -p "Enter the destination of the home directory you wish to associate with this container [HOMEDIR]: " HOMEDIR; echo "$$HOMEDIR">>HOMEDIR; cat HOMEDIR; \
	done ;

LINK:
	@while [ -z "$$LINK" ]; do \
		read -r -p "Enter the links you wish to associate with this container [LINK]: " LINK; echo "$$LINK">>LINK; cat LINK; \
	done ;

NICENESS:
	@while [ -z "$$NICENESS" ]; do \
		read -r -p "Enter the niceness you wish to associate with this container [NICENESS]: " NICENESS; echo "$$NICENESS">>NICENESS; cat NICENESS; \
	done ;

TZ:
	@while [ -z "$$TZ" ]; do \
		read -r -p "Enter the timezone you wish to associate with this container [America/Denver]: " TZ; echo "$$TZ">>TZ; cat TZ; \
	done ;

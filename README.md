# Chromate
A hardened veneer on a daily tool (chrome) to keep it from getting tarnished

### Usage

`make`  <-- by default it will ask you for a home directory and run
 chrome inside a container

`make logs` <-- gives you logs

`make enter` <-- will enter the running container and execute
`/bin/bash`

`make clean` <-- will kill and remove the running container

### Temporary ephemeral non-persistent sandbox chrome

It is useful to run a second completely sandboxed chrome, for example
when testing compromised sites with security issues etc.

`make temp`  <-- gives you a completely temporary, ephemeral,
non-persistent, sandboxed chrome in a container, when you close the
container it will completely go away (you can find the temporary files
in `/tmp/*tempchromeTMP`

`make templogs` <-- gives you logs from the temp container

`make tempenter`, `make tempclean` work just like the other commands but
on the temp container

### Proxy

`make proxy`  <-- will add a proxy 

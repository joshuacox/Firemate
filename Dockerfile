FROM jess/firefox
LABEL maintainer "Josh Cox <josh@webhosting.coop>"

ENV NICENESS 19
ENV LINKS http://foundation.webhosting.coop

COPY start.sh /start.sh
ENTRYPOINT [ "/start.sh" ]

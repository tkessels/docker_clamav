FROM alpine
ARG PUID=1001
ARG PGID=1001

MAINTAINER tabledevil

RUN apk add -u clamav
RUN apk add -u clamav-dev
RUN apk add -u freshclam
RUN freshclam
ADD start.sh /start.sh
RUN chmod +x /start.sh
RUN sed -ie 's/#DetectPUA yes/DetectPUA yes/p' /etc/clamav/clamd.conf
RUN sed -ie 's/#AlertOLE2Macros yes/AlertOLE2Macros yes/p' /etc/clamav/clamd.conf
RUN addgroup -g ${PGID} user && \
    adduser -D -u ${PUID} -G user user
ENTRYPOINT ["/start.sh"]
CMD ["shell"]
USER user

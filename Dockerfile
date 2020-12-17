FROM alpine
ARG PUID=1001
ARG PGID=1001

MAINTAINER tabledevil
#install clamav
RUN apk add -u clamav
RUN apk add -u clamav-dev
RUN apk add -u freshclam
RUN apk add -u bash
#update clamav signatures
RUN freshclam
#add abuse.ch signatures
ADD https://urlhaus.abuse.ch/downloads/urlhaus.ndb /var/lib/clamav/urlhaus.ndb
RUN chown clamav:clamav /var/lib/clamav/urlhaus.ndb
RUN chmod 644 /var/lib/clamav/urlhaus.ndb
#add startscript
ADD start.sh /start.sh
RUN chmod +x /start.sh
#customize clamav config
RUN sed -ie 's/#DetectPUA yes/DetectPUA yes/p' /etc/clamav/clamd.conf
RUN sed -ie 's/#AlertOLE2Macros yes/AlertOLE2Macros yes/p' /etc/clamav/clamd.conf
#add user
RUN addgroup -g ${PGID} user && \
    adduser -D -u ${PUID} -G user user
ENTRYPOINT ["/start.sh"]
CMD ["shell"]
USER user

FROM alpine
ARG PUID=1001
ARG PGID=1001

MAINTAINER tabledevil
#install clamav
RUN apk add -u clamav
RUN apk add -u clamav-dev
RUN apk add -u freshclam
RUN apk add -u bash
#ADD unofficial signatures to freshclam
RUN echo 'DatabaseCustomURL https://urlhaus.abuse.ch/downloads/urlhaus.ndb' >> /etc/clamav/freshclam.conf
RUN echo 'DatabaseCustomURL https://mirror.rollernet.us/sanesecurity/badmacro.ndb' >> /etc/clamav/freshclam.conf
RUN echo 'DatabaseCustomURL https://mirror.rollernet.us/sanesecurity/blurl.ndb' >> /etc/clamav/freshclam.conf
RUN echo 'DatabaseCustomURL https://mirror.rollernet.us/sanesecurity/junk.ndb' >> /etc/clamav/freshclam.conf
RUN echo 'DatabaseCustomURL https://mirror.rollernet.us/sanesecurity/jurlbl.ndb' >> /etc/clamav/freshclam.conf
RUN echo 'DatabaseCustomURL https://mirror.rollernet.us/sanesecurity/lott.ndb' >> /etc/clamav/freshclam.conf
RUN echo 'DatabaseCustomURL https://raw.githubusercontent.com/twinwave-security/twinclams/master/twinclams.ldb' >> /etc/clamav/freshclam.conf
RUN echo 'DatabaseCustomURL https://raw.githubusercontent.com/twinwave-security/twinclams/master/twinwave.ign2' >> /etc/clamav/freshclam.conf
#RUN freshclam
RUN freshclam
#add startscript
ADD start.sh /start.sh
RUN chmod +x /start.sh
#customize clamav config
RUN sed -ie 's/#DetectPUA yes/DetectPUA yes/p' /etc/clamav/clamd.conf
RUN sed -ie 's/#AlertOLE2Macros yes/AlertOLE2Macros yes/p' /etc/clamav/clamd.conf
#make freshclam suid so user can run it
RUN chown root /usr/bin/freshclam
RUN chmod u+s /usr/bin/freshclam
#add user
RUN addgroup -g ${PGID} user && \
    adduser -D -u ${PUID} -G user user
ENTRYPOINT ["/start.sh"]
CMD ["shell"]
USER user

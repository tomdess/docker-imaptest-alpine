FROM alpine:latest

ENV IMAPTEST_DOWNLOAD_URL http://dovecot.org/nightly/imaptest/imaptest-latest.tar.gz

# dovecot packages and build-base - imaptest - cleanup
RUN apk --no-cache update && apk --no-cache add curl build-base libtool dovecot dovecot-dev && \
    cd /root && \
    curl -s -L ${IMAPTEST_DOWNLOAD_URL} | tar zxf - && \
    cd imaptest-* && \
    ./configure --with-dovecot=/usr/lib/dovecot && make install && \
    apk --no-cache del --purge build-base libtool dovecot-dev && rm -rf /var/cache/apk/* && \
    cd /root && rm -rf imaptest-* && rm -f imaptest-latest.tar.gz

# python
RUN apk --no-cache add python2 && rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /usr/local/bin 
COPY create-testmbox.py /usr/local/bin
COPY imaptest_wrapper.sh /usr/local/bin

# add dovecot lib path
RUN echo "/lib:/usr/local/lib:/usr/lib:/usr/lib/dovecot" > /etc/ld-musl-$(uname -m).path

VOLUME /srv

WORKDIR /srv

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["/usr/local/bin/imaptest_wrapper.sh"]

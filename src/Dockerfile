FROM        alpine:3.11
LABEL       maintainer "etriphany.com"
ENV         OS_PACKAGES "bash grep jq libcoap"

# Setup
RUN         apk add ${OS_PACKAGES} --update --no-cache && \
            rm -rf /var/cache/apk && \
            mkdir /home/randori

# Install
WORKDIR     /home/randori
COPY        /script ./

# Run
ENTRYPOINT  ["/home/randori/spec/tests.sh"]
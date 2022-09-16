#FROM node:16.15.1
FROM node:16.15.1-alpine3.15

EXPOSE 4321 35729

ENV NPM_CONFIG_PREFIX=/usr/app/.npm-global \
  PATH=$PATH:/usr/app/.npm-global/bin

VOLUME /usr/app/spfx
WORKDIR /usr/app/spfx
# RUN useradd --create-home --shell /bin/bash spfx && \
#     usermod -aG sudo spfx && \
#     chown -R spfx:spfx /usr/app

RUN apk add sudo && \
    apk upgrade --update-cache --available && \
    apk add openssl && \
    rm -rf /var/cache/apk/* && \
    apk --no-cache add shadow && \
    echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel && \
    adduser --home "$(pwd)" --disabled-password --ingroup wheel --shell /bin/ash spfx && \
    usermod -aG wheel spfx && \
    chown -R spfx:wheel /usr/app

USER spfx

RUN npm i -g gulp@4 yo @microsoft/generator-sharepoint@1.15.2 spfx-fast-serve

CMD /bin/ash
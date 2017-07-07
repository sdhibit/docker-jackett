FROM sdhibit/alpine-runit:3.6
MAINTAINER Steve Hibit <sdhibit@gmail.com>

# Add Testing Repository
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Install apk packages
RUN apk --update upgrade \
 && apk --no-cache add \
  bzip2 \
  ca-certificates \
  libcurl \
  mono@testing \
  openssl \
  sqlite \
  tar \
  unrar

# Set Jackett Package Information
ENV PKG_NAME Jackett
ENV PKG_VER 0.7
ENV PKG_BUILD 1508
ENV APP_BASEURL https://github.com/Jackett/Jackett/releases/download
ENV APP_PKGNAME v${PKG_VER}.${PKG_BUILD}/${PKG_NAME}.Binaries.Mono.tar.gz
ENV APP_URL ${APP_BASEURL}/${APP_PKGNAME}
ENV APP_PATH /opt/jackett

# Download & Install Sonarr
RUN mkdir -p ${APP_PATH} \
 && curl -kL ${APP_URL} | tar -xz -C ${APP_PATH} --strip-components=1 

# Create user and change ownership
RUN mkdir /config \
 && addgroup -g 666 -S jackett \
 && adduser -u 666 -SHG jackett jackett \
 && chown -R jackett:jackett \
    ${APP_PATH} \
    "/config"

VOLUME ["/config"]

# Default Jackett server ports
EXPOSE 9117

WORKDIR ${APP_PATH}

# Add services to runit
ADD jackett.sh /etc/service/jackett/run
RUN chmod +x /etc/service/*/run

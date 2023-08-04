FROM nginx:1.20

ARG CONTAINER_PACKAGE_URL

ENV DEBIAN_FRONTEND noninteractive

# CST zone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# RUN sed -i "s@http://deb.debian.org@http://mirrors.ustc.edu.cn@g" /etc/apt/sources.list

RUN apt-get clean \
    && apt-get update \
    && apt-get install -y vim apache2-utils

WORKDIR /var/www/html

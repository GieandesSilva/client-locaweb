FROM nginx:alpine

MAINTAINER Gieandes Silva contato@gieandessilva.com

WORKDIR /var/www/html

RUN rm /etc/nginx/conf.d/default.conf

COPY ./vhost.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
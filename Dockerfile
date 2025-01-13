FROM nginx:alpine
MAINTAINER Adrien M amaurel90@gmail.com

ENV DEBUG=false RAP_DEBUG="info" 
ARG VERSION_RANCHER_GEN="artifacts/master"

RUN apk add --no-cache nano ca-certificates unzip wget certbot bash openssl

# Install Forego & Rancher-Gen-RAP
ADD https://github.com/jwilder/forego/releases/download/v0.16.1/forego /usr/local/bin/forego
ADD libs/rancher-gen /usr/local/bin/rancher-gen

# RUN wget "https://gitlab.com/TheBoroer/rancher-gen-rap/builds/$VERSION_RANCHER_GEN/download?job=compile-go" -O /tmp/rancher-gen-rap.zip \
# 	&& unzip /tmp/rancher-gen-rap.zip -d /usr/local/bin \
# 	&& chmod +x /usr/local/bin/rancher-gen \
# 	&& chmod u+x /usr/local/bin/forego \
# 	&& rm -f /tmp/rancher-gen-rap.zip

RUN chmod +x /usr/local/bin/rancher-gen \
    && chmod u+x /usr/local/bin/forego

# copy config files etc
COPY ./etc/nginx/nginx.conf /etc/nginx/nginx.conf

#Copying all templates and script	
COPY ./app/ /app/
WORKDIR /app/

# Seting up repertories & Configure Nginx and apply fix for very long server names
RUN chmod +x /app/letsencrypt.sh \
    && mkdir -p /etc/nginx/certs /etc/nginx/vhost.d /etc/nginx/conf.d /usr/share/nginx/html /etc/letsencrypt \
    && chmod u+x /app/remove 

ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh" ]
CMD ["forego", "start", "-r"]

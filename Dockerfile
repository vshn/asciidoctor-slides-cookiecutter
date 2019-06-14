# ---------- STEP 1 ----------
# Downloading all dependencies
FROM node:10.14.2-alpine AS builder

RUN apk add make curl
WORKDIR /presentation
COPY ["package.json", "yarn.lock", "Makefile", "/presentation/"]
RUN yarn install && \
    make lib/asciinema && \
    make lib/reveal.js

# ---------- STEP 2 ----------
# Build the documentation in web format
COPY . /presentation
RUN FILENAME=demo.adoc yarn build

# ---------- STEP 3 ----------
# Docker image only containing nginx and the freshly built documentation

# The following lines make this image compatible with OpenShift.
# Source: https://torstenwalter.de/openshift/nginx/2017/08/04/nginx-on-openshift.html
FROM nginx:stable

EXPOSE 8080
RUN \
    # support running as arbitrary user which belogs to the root group
    chmod g+rwx /var/cache/nginx /var/run /var/log/nginx && \
    # users are not allowed to listen on priviliged ports
    sed -i.bak 's/listen\(.*\)80;/listen 8080;/' /etc/nginx/conf.d/default.conf && \
    # comment user directive as master process is run as different user anyhow
    sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

# Finally, copy the contents of the documentation to be served
COPY --from=builder /presentation/demo.html /usr/share/nginx/html/index.html
COPY --from=builder /presentation/assets /usr/share/nginx/html/assets
COPY --from=builder /presentation/lib /usr/share/nginx/html/lib
COPY --from=builder /presentation/theme /usr/share/nginx/html/theme

# Don't run as root even in plain docker
USER 1001:0

# ---------- STEP 1 ----------
# Downloading all dependencies
FROM node:10.14.2-alpine AS htmlmaker

RUN apk add make curl
WORKDIR /presentation
COPY ["package.json", "package-lock.json", "Makefile", "/presentation/"]
RUN make node_modules

# ---------- STEP 2 ----------
# Build the presentation in web format
COPY . /presentation
RUN make slides.html

# ---------- STEP 3 ----------
# Build the presentation in PDF format
FROM astefanutti/decktape:2.9.2 as pdfmaker

COPY --from=htmlmaker /presentation/slides.html /slides/slides.html
COPY --from=htmlmaker /presentation/assets /slides/assets
COPY --from=htmlmaker /presentation/theme /slides/theme
COPY --from=htmlmaker /presentation/node_modules/asciinema-player /slides/node_modules/asciinema-player
COPY --from=htmlmaker /presentation/node_modules/reveal.js /slides/node_modules/reveal.js
RUN node /decktape/decktape.js --chrome-path chromium-browser --chrome-arg=--no-sandbox --size '2560x1440' --chrome-arg=--allow-file-access-from-files /slides/slides.html /slides/slides.pdf

# ---------- STEP 4 ----------
# Docker image only containing nginx and the freshly built presentation files
FROM nginx:stable-alpine

EXPOSE 8080

# The following lines make this image compatible with OpenShift.
# Source: https://torstenwalter.de/openshift/nginx/2017/08/04/nginx-on-openshift.html
RUN \
    # support running as arbitrary user which belogs to the root group
    chmod g+rwx /var/cache/nginx /var/run /var/log/nginx && \
    # users are not allowed to listen on priviliged ports
    sed -i.bak 's/listen\(.*\)80;/listen 8080;/' /etc/nginx/conf.d/default.conf && \
    # comment user directive as master process is run as different user anyhow
    sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

# Finally, copy the contents of the presentation to be served
COPY --from=htmlmaker /presentation/slides.html /usr/share/nginx/html/index.html
COPY --from=htmlmaker /presentation/assets /usr/share/nginx/html/assets
COPY --from=htmlmaker /presentation/theme /usr/share/nginx/html/theme
COPY --from=htmlmaker /presentation/node_modules/asciinema-player /usr/share/nginx/html/node_modules/asciinema-player
COPY --from=htmlmaker /presentation/node_modules/reveal.js /usr/share/nginx/html/node_modules/reveal.js
COPY --from=pdfmaker /slides/slides.pdf /usr/share/nginx/html/slides.pdf

# Don't run as root even in plain docker
USER 1001:0

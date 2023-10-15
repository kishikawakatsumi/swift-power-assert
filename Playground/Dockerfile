FROM node:lts-slim as nodebuild

WORKDIR /build

ARG FONTAWESOME_TOKEN
COPY package*.json ./
RUN echo "@fortawesome:registry=https://npm.fontawesome.com/\n//npm.fontawesome.com/:_authToken=${FONTAWESOME_TOKEN}" > ./.npmrc \
    && npm ci \
    && rm -f ./.npmrc

COPY webpack.*.js ./
COPY frontend ./frontend/
RUN npx webpack --config webpack.prod.js


FROM swift:5.9-jammy as swiftbuild

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update && apt-get -q dist-upgrade -y \
    && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

COPY --from=nodebuild /build/dist/ /build/dist/
COPY ./TestModule/ ./TestModule/

RUN echo 'int isatty(int fd) { return 1; }' | \
    clang -O2 -fpic -shared -ldl -o faketty.so -xc - \
    && strip faketty.so && chmod 400 faketty.so && mv faketty.so ./TestModule/


FROM swift:5.9-jammy as swift

# Install Deno
RUN apt-get -qq update \
    && apt-get -qq -y install curl zip unzip \
    && curl -fsSL https://deno.land/x/install/install.sh | sh \
    && apt-get -qq remove curl zip unzip \
    && apt-get -qq remove --purge -y curl zip unzip \
    && apt-get -qq -y autoremove \
    && apt-get -qq clean

ENV PATH "/root/.deno/bin:$PATH"

WORKDIR /app
COPY --from=swiftbuild /build /app
RUN swift build --build-tests --package-path ./TestModule/

COPY ./backend/deps.ts .
RUN deno cache deps.ts

ADD ./backend/ .
RUN deno cache main.ts

EXPOSE 8080
CMD ["deno", "run", "--allow-net", "--allow-read", "--allow-run", "--allow-write", "main.ts"]

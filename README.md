# Nginx reverse proxy

[![Docker Repository on Quay](https://quay.io/repository/store2be/nginx-reverse-proxy/status "Docker Repository on Quay")](https://quay.io/repository/store2be/nginx-reverse-proxy)

This Docker image provides a simple Nginx reverse proxy that can be used to proxy all requests to one specific server.

The purpose of this simple proxy is to be used in Kubernetes to proxy requests to an external service. Kubernetes has a service type `ExternalName` but there you can't have any advanced configuration like setting headers. Also the annotations on an `Ingress` are very limited for now.

## Usage

```bash
docker run -p 80:80 --rm -e PROXY_URL=example.com quay.io/store2be/nginx-reverse-proxy
```

Find the available versions on [quay.io](https://quay.io/repository/store2be/nginx-reverse-proxy?tab=tags) ([Changelog](CHANGELOG.md)).

## Environment variables

Have a look at [nginx.proxy.conf.esh](nginx.proxy.conf.esh) for how the environment variables change the Nginx config.

### PROXY_URL

Required. Specifies the domain that should be proxied.

```
# Example
PROXY_URL=example.com
```

### MAIN_CACHE

Optional. Defaults to `false`. Toggles caching for the all the routes.

```
# Example
MAIN_CACHE=true
```

### MAIN_CACHE_QUERY

Optional. Defaults to `false`. Toggles ignoring query params when caching.
Takes effect only when `MAIN_CACHE` is set to `true`

```
# Example
MAIN_CACHE_QUERY=true
```

### SECONDARY_CACHE_REGEX

Optional. It is used to specify a set of routes that will behave differently from the main configuration.

Defaults to `false` which indicates this setting is inactive, otherwise the value should be in the Nginx location regex format.


```
# Example
SECONDARY_CACHE_REGEX="~ .(png|gif|jpeg)$"
```

### SECONDARY_CACHE

Optional. Defaults to `false`. Toggles caching for the routes specificed by `SECONDARY_CACHE_REGEX`.

```
# Example
SECONDARY_CACHE=true
```

### SECONDARY_CACHE_QUERY

Optional. Defaults to `false`. Toggles ignoring query params when caching for the routes specificed by `SECONDARY_CACHE_REGEX`.

```
# Example
SECONDARY_CACHE_QUERY=true
```

### CACHE_VALIDITY_DURATION

Optional. Defaults to `1h`. Sets the cache validitiy duration for non 5XX requests. The time units used should be the ones recognized by Nginx.

```
# Example
CACHE_VALIDITY_DURATION=1d
```

## Run locally

When you want to test the Docker image, you can run it locally for example with the following command:

```bash
docker build -t nginx-reverse-proxy .
docker run -p 80:80 --rm -e PROXY_URL=example.com nginx-reverse-proxy
```

### Debugging

Add this to the Dockerfile:

```
ENV TCPDUMP_VERSION 4.9.2-r4
RUN apk add --update \
  tcpdump==${TCPDUMP_VERSION} \
  strace \
  && rm -rf /var/cache/apk/*
```

And then:

```bash
docker build -t nginx-reverse-proxy .
docker run --privileged -p 80:80 --rm -e PROXY_URL=example.com nginx-reverse-proxy strace nginx-debug -g 'daemon off;'
docker exec -ti $(docker ps | grep nginx-reverse-proxy | awk '{print $1}') tcpdump not port 22 -vvv -s0 -q -XXX
```

## Releasing

### Before merging to master

Make sure you update the [CHANGELOG](CHANGELOG.md) and the [README](README.md) when appropriate.

*CHANGELOG.md entry format:*

```
## [0.0.0] - 1970-01-01
- ✨ Add a new feature
```

Bump version according to [SemVer](https://semver.org/).

### After merging to master

Tag the head with the new version and push it to Github. This then automatically generates the new image on quay.io with the version as a tag.

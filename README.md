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

Have a look at [entrypoint.sh](entrypoint.sh) for how the environment variables change the Nginx config.

### PROXY_URL

Required. Specifies the domain that should be proxied.

```
# Example
PROXY_URL=example.com
```

### CACHE

Optional. Defaults to `false`. Specifies whether or not to cache the pages.

```
# Example
CACHE=true
```
### CACHE_IGNORE_QUERY_PARAMS

You can configure caching to ignore query parameters and only cache according to the URL.

```
# Example
CACHE_IGNORE_QUERY_PARAMS=true
```

*Note:* Needs `CACHE` environment variable set to `true` to take effect.

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

Make sure you update CHANGELOG.md and README.md when appropriate.

*CHANGELOG.md entry format:*

```
## [0.0.0] - 1970-01-01
- ✨ Add a new feature
```

Bump version according to [SemVer](https://semver.org/).

### After merging to master

Tag the head with the new version, this should generate an image with the version as a tag.

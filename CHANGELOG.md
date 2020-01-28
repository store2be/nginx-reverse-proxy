# Changelog

## Unreleased

## [0.5.1] - 2020-01-28
- 🔒 Update packages

## [0.5] - 2019-08-20
- ✨ Make cache validity duration for non 5XX responses configurable

## [0.4] - 2019-07-11
- ♻️ Decrease cache timeout for 500s to 1 minute

## [0.3] - 2019-07-04
- 💥 Introduce templating and more flexible caching options
    - Include esh (https://github.com/jirutka/esh) for templating
    - Add the option to configure a single subset of the routes differently
      So the following setups are possible:

      * Secondary block (not exist / regex + with cache / regex + without cache)
      * Main block (not cache at all / cache with params / cache without params)

## [0.2] - 2019-06-27
- ✨ Add the option to remove query parameters from the cache key

## [0.1.1] - 2019-06-26
- 🐛 Ignore Cache-Control and Set-Cookie headers when caching

## [0.1] - 2019-05-26

- ✨ Enable caching with `$CACHE=true`
- ✨ Configure the reverse proxy with `$PROXY_URL`

Pattern = require 'url-pattern'

vhost = (pattern, handler) ->
  hostPattern = new Pattern pattern

  (req, res, next) ->
    match = hostPattern.match req.headers.host

    unless match
      return next()

    handler req, res, next, match

router = (predicate) ->
  (pattern, handler) ->
    urlPattern = new Pattern pattern

    (req, res, next) ->
      unless predicate req
        return next()

      urlWithoutQuerystring = req.url.split('?')[0]

      match = urlPattern.match urlWithoutQuerystring

      unless match
        return next()

      handler req, res, next, match

module.exports =
  router: router
  vhost: vhost
  any: router -> true
  get: router (req) -> req.method.toUpperCase() in ['GET', 'HEAD']
  post: router (req) -> req.method.toUpperCase() is 'POST'
  put: router (req) -> req.method.toUpperCase() is 'PUT'
  delete: router (req) -> req.method.toUpperCase() is 'DELETE'
  patch: router (req) -> req.method.toUpperCase() is 'PATCH'

newUrlPattern = require 'url-pattern'

router = (predicate) ->
    (pattern, handler) ->
        urlPattern = newUrlPattern pattern

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
    any: router -> true
    get: router (req) -> req.method.toUpperCase() in ['GET', 'HEAD']
    post: router (req) -> req.method.toUpperCase() is 'POST'
    put: router (req) -> req.method.toUpperCase() is 'PUT'
    delete: router (req) -> req.method.toUpperCase() is 'DELETE'

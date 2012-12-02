_ = require 'underscore'
Pattern = require 'url-pattern'
sequenz = require 'sequenz'

run = (req, res, next, [first, rest...]) ->
    return next() unless first?

    nextNext = -> run req, res, next, rest

    method = req.method.toLowerCase()

    unless method is first.method or first.method is 'all' or first.method is 'get' and method is 'head'
        return nextNext()

    params = first.pattern.match req.url.split('?')[0]

    return nextNext() unless params?

    req.params = params

    first.middleware req, res, nextNext

Router = class
    constructor: -> @routes = []
    middleware: (req, res, next = ->) => run req, res, next, @routes

['all', 'get', 'post', 'put', 'delete'].forEach (method) ->
    Router.prototype[method] = (pattern, middleware...) ->
        @routes.push {
            method: method
            pattern: new Pattern pattern
            middleware: sequenz middleware
        }

module.exports = Router

_ = require 'underscore'
Pattern = require 'url-pattern'

run = (req, res, next, [first, rest...]) ->
    return next() if not first?

    nextNext = -> run req, res, next, rest

    return nextNext() if not (first.method in [req.method, 'all'])

    params = first.pattern.match req.url

    return nextNext() if not params?

    req.params = params

    first.middleware req, res, nextNext

Router = class
    constructor: -> @routes = []
    middleware: (req, res, next = ->) => run req, res, next, @routes

_.each 'all get post put delete'.split(' '), (method) ->
    Router.prototype[method] = (pattern, middleware) ->
        @routes.push {
            method: method
            pattern: new Pattern pattern
            middleware: middleware
        }

module.exports = Router

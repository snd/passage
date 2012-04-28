Router = require './index'

module.exports =

    'router calls next when a route is not defined': (test) ->

        router = new Router
        router.middleware {url: '/foo', method: 'get'}, {}, -> test.done()

    'router calls handler for get route': (test) ->

        router = new Router
        router.get '/foo', (req, res) -> test.done()
        router.middleware {url: '/foo', method: 'get'}, {}, -> test.fail()

    'router calls handler for get route with uppercase method': (test) ->

        router = new Router
        router.get '/foo', (req, res) -> test.done()
        router.middleware {url: '/foo', method: 'GET'}, {}, -> test.fail()

    'router calls all handler for get route': (test) ->

        router = new Router
        router.all '/foo', (req, res) -> test.done()
        router.middleware {url: '/foo', method: 'get'}, {}, -> test.fail()

    'router does not call post handler for get route': (test) ->

        router = new Router
        router.post '/foo', (req, res) -> test.fail()
        router.middleware {url: '/foo', method: 'get'}, {}, -> test.done()

    'router does not call post handler for get route': (test) ->

        router = new Router
        router.post '/foo', (req, res) -> test.fail()
        router.middleware {url: '/foo', method: 'get'}, {}, -> test.done()

    'router adds correct params to req': (test) ->

        router = new Router
        router.post '/foo/:id1/bar/:id2', (req, res) ->
            test.deepEqual req.params, {id1: '7', id2: '8'}
            test.done()
        router.middleware {url: '/foo/7/bar/8', method: 'post'}, {}, -> test.fail()

    'router calls multiple routes correctly': (test) ->
        test.expect 20

        router = new Router

        router.all '*', (req, res, next) ->
            test.deepEqual req.params, {}
            next()

        router.put '*', (req, res, next) ->
            test.equal req.url, '/foo/7/bar/8/baz/9'
            test.deepEqual req.params, {}
            next()

        router.post '*', (req, res, next) ->
            test.equal req.url, '/foo/7/baz/9'
            next()

        router.all '/foo/:id/*', (req, res, next) ->
            test.deepEqual req.params, {id: '7'}
            next()

        router.post '*/baz/:id', (req, res, next) ->
            test.equal req.url, '/foo/7/baz/9'
            test.deepEqual req.params, {id: '9'}
            next()

        router.put '*/baz/:id', (req, res, next) ->
            test.equal req.url, '/foo/7/bar/8/baz/9'
            test.deepEqual req.params, {id: '9'}
            next()

        router.put '/foo/:one/bar/:two/*', (req, res, next) ->
            test.equal req.url, '/foo/7/bar/8/baz/9'
            test.deepEqual req.params, {one: '7', two: '8'}
            next()

        router.put '/foo/:foo/bar/:bar/baz/:baz', (req, res, next) ->
            test.equal req.url, '/foo/7/bar/8/baz/9'
            test.deepEqual req.params, {foo: '7', bar: '8', baz: '9'}
            next()

        router.put '*', (req, res, next) ->
            test.equal req.url, '/foo/7/bar/8/baz/9'
            test.deepEqual req.params, {}
            next()

        router.all '*', (req, res, next) ->
            test.deepEqual req.params, {}
            next()

        router.middleware {url: '/foo/7/bar/8/baz/9', method: 'put'}, {}, -> test.ok true
        router.middleware {url: '/foo/7/baz/9', method: 'post'}, {}, -> test.done()

passage = require '../src/passage'

module.exports =

    'matching method and matching url': (test) ->
        middleware = passage.get '/users', (req, res) ->
            test.done()
        req = {url: '/users', method: 'get'}
        res = {}
        middleware req, res, -> test.fail()

    'head is handled like a get': (test) ->
        middleware = passage.get '/users', (req, res) ->
            test.done()
        req = {url: '/users', method: 'head'}
        res = {}
        middleware req, res, -> test.fail()

    'ignore query part of url': (test) ->
        middleware = passage.get '/users', (req, res) ->
            test.done()
        req = {url: '/users?age=27', method: 'get'}
        res = {}
        middleware req, res, -> test.fail()

    'any method and matching url': (test) ->
        middleware = passage.any '/users', (req, res) ->
            test.done()
        req = {url: '/users', method: 'get'}
        res = {}
        middleware req, res, -> test.fail()

    'not matching method and matching url': (test) ->
        middleware = passage.post '/users', (req, res) ->
            test.fail()
        req = {url: '/users', method: 'get'}
        res = {}
        middleware req, res, -> test.done()

    'matching method and not matching url': (test) ->
        middleware = passage.get '/users', (req, res) ->
            test.fail()
        req = {url: '/projects', method: 'get'}
        res = {}
        middleware req, res, -> test.done()

    'params are passed to handler': (test) ->
        middleware = passage.get '/users/:userId/posts/:postId', (req, res, next, params) ->
            test.deepEqual params, {userId: '8', postId: '120'}
            test.done()
        req = {url: '/users/8/posts/120', method: 'get'}
        res = {}
        middleware req, res, -> test.fail()

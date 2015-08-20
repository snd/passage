test = require 'tape'
UrlPattern = require 'url-pattern'

passage = require '../lib/passage'

test 'router', (t) ->

    t.test 'matching method and matching url', (t) ->
      middleware = passage.get '/users', (req, res) ->
        t.end()
      req = {url: '/users', method: 'get'}
      res = {}
      middleware req, res, -> t.fail()

    t.test 'head is handled like a get', (t) ->
      middleware = passage.get '/users', (req, res) ->
        t.end()
      req = {url: '/users', method: 'head'}
      res = {}
      middleware req, res, -> t.fail()

    t.test 'ignore query part of url', (t) ->
      middleware = passage.get '/users', (req, res) ->
        t.end()
      req = {url: '/users?age=27', method: 'get'}
      res = {}
      middleware req, res, -> t.fail()

    t.test 'any method and matching url', (t) ->
      middleware = passage.any '/users', (req, res) ->
        t.end()
      req = {url: '/users', method: 'get'}
      res = {}
      middleware req, res, -> t.fail()

    t.test 'not matching method and matching url', (t) ->
      middleware = passage.post '/users', (req, res) ->
        t.fail()
      req = {url: '/users', method: 'get'}
      res = {}
      middleware req, res, -> t.end()

    t.test 'matching method and not matching url', (t) ->
      middleware = passage.get '/users', (req, res) ->
        t.fail()
      req = {url: '/projects', method: 'get'}
      res = {}
      middleware req, res, -> t.end()

    t.test 'params are passed to handler', (t) ->
      middleware = passage.get '/users/:userId/posts/:postId', (req, res, next, params) ->
        t.deepEqual params, {userId: '8', postId: '120'}
        t.end()
      req = {url: '/users/8/posts/120', method: 'get'}
      res = {}
      middleware req, res, -> t.fail()

    t.test 'POST', (t) ->
      middleware = passage.post '/users/:id', (req, res, next, params) ->
        t.deepEqual params, {id: '8'}
        t.end()
      req = {url: '/users/8', method: 'post'}
      res = {}
      middleware req, res, -> t.fail()

    t.test 'PUT', (t) ->
      middleware = passage.put '/users/:id', (req, res, next, params) ->
        t.deepEqual params, {id: '8'}
        t.end()
      req = {url: '/users/8', method: 'put'}
      res = {}
      middleware req, res, -> t.fail()

    t.test 'DELETE', (t) ->
      middleware = passage.delete '/users/:id', (req, res, next, params) ->
        t.deepEqual params, {id: '8'}
        t.end()
      req = {url: '/users/8', method: 'delete'}
      res = {}
      middleware req, res, -> t.fail()

    t.test 'PATCH', (t) ->
      middleware = passage.patch '/users/:id', (req, res, next, params) ->
        t.deepEqual params, {id: '8'}
        t.end()
      req = {url: '/users/8', method: 'patch'}
      res = {}
      middleware req, res, -> t.fail()

    t.test 'UrlPattern as argument', (t) ->
      pattern = new UrlPattern '/users/:id'
      middleware = passage.get pattern, (req, res, next, params) ->
        t.deepEqual params, {id: '8'}
        t.end()
      req = {url: '/users/8', method: 'get'}
      res = {}
      middleware req, res, -> t.fail()

    t.test 'custom matcher object', (t) ->
      t.plan 1
      pattern = new UrlPattern '/language/:slug'
      matcher =
        match: (url) ->
         match = pattern.match url
         if match? and match.slug in ['es', 'fr']
           return match

      middleware = passage.get matcher, (req, res, next, params) ->
        t.deepEqual params, {slug: 'es'}
      req = {url: '/language/es', method: 'get'}
      res = {}
      middleware req, res, -> t.fail()

      middleware = passage.get matcher, (req, res, next, params) ->
        t.fail()
      req = {url: '/language/uk', method: 'get'}
      res = {}
      middleware req, res, ->
        t.end()

  test 'vhost', (t) ->

    t.test 'match', (t) ->
      middleware = passage.vhost ':sub.example.:tld', (req, res, next, params) ->
        t.deepEqual params, {sub: 'www', tld: 'com'}
        t.end()
      req =
        headers:
          host: 'www.example.com'
      res = {}
      middleware req, res, -> t.fail()

    t.test 'no match', (t) ->
      middleware = passage.vhost ':sub.example.:tld', (req, res) ->
        t.fail()
      req =
        headers:
          host: 'www.google.com'
      res = {}
      middleware req, res, -> t.end()

# passage

[![Build Status](https://travis-ci.org/snd/passage.png)](https://travis-ci.org/snd/passage)

passage is a simple router middleware for nodejs

### install

```
npm install passage
```

### use

##### create a router

```coffeescript
Passage = require 'passage'

router = new Passage
```

##### define routes

see [url-pattern](https://github.com/snd/url-pattern) for supported url patterns.

the params extracted from the url will be available as `req.params`.

```coffeescript

# called before all following routes
router.all '*', (req, res, next) -> next()

# called only on GET /
router.get '/', (req, res, next) -> res.end 'hello'

# called before all following routes if the request url starts with /users
router.all '/users*', (req, res, next) -> next()

router.post '/users', (req, res, next) -> res.end 'post'

router.put '/users/:id', (req, res, next) ->
    # called on PUT /users/7 for example. req.params will then be {id: 7}
    res.end 'put ' + req.params.id

router.delete '/users/:id', (req, res, next) ->
    # called on DELETE /users/18 for example. req.params will then be {id: 18}
    res.end 'delete ' + req.params.id
```

##### use the middleware

```coffeescript
http = require 'http'

server = http.createServer router.middleware

server.listen 80
```

### license: MIT

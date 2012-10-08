# passage

passage is a request router for nodejs
[![Build Status](https://travis-ci.org/snd/passage.png)](https://travis-ci.org/snd/passage)

### install

```
npm install passage
```

### use

##### create a router

```coffeescript
Passage = require 'Passage'

router = new Passage
```

##### define routes

see [url-pattern](https://github.com/snd/url-pattern) for supported url patterns.

the params extracted from the url will be available as `req.params`.

```coffeescript

# called before every following route
router.all '*', (req, res, next) -> next()

# called only on GET /
router.get '/', (req, res, next) -> res.end 'hello'

# called before every following route if the request url starts with /users
router.all '/users*', (req, res, next) -> next()

router.post '/users', (req, res, next) -> res.end 'posted'

router.put '/users/:id', (req, res, next) ->
    # called for example on PUT /users/7 - req.params will then be {id: 7}

router.delete '/users/:id', (req, res, next) ->
    # called for example on DELETE /users/18 - req.params will then be {id: 18}
```

##### use the middleware

```coffeescript
http = require 'http'

server = http.createServer router.middleware

server.listen 80
```

### license: MIT

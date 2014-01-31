# passage

[![Build Status](https://travis-ci.org/snd/passage.png)](https://travis-ci.org/snd/passage)

passage is simple composable routing with middleware for nodejs

### install

```
npm install passage
```

**or**

put this line in the dependencies section of your `package.json`:

```
"passage": "1.0.0"
```

then run:

```
npm install
```

### use

a middleware is a function of three arguments:
the [request object](http://nodejs.org/api/http.html#http_http_incomingmessage) `req` from the nodejs http server,
the [response object](http://nodejs.org/api/http.html#http_class_http_serverresponse)`res` from the nodejs http server
and a callback `next`.
middleware handles the request and usually modifies the response.
if a middleware doesn't end the request it should call `next` to give control
to the next middleware.

the passage module exports an object containing the functions `get`, `post`, `put`, `delete` and `any`.
each of these functions is called with an [url-pattern](https://github.com/snd/url-pattern) (either a string or a regex)
and a middleware.
they then return a new middleware.
the returned middleware will call the argument middleware when the method matches
('get' for `get`, 'post' for `post`, ..., any method for `any`) and the url matches the url-pattern.
the argument middleware is called with the params that were parsed from the url
as an additional fourth argument.
if the method or url don't match up the returned middleware will just call `next`
to give control to the next middleware.

### simple example

```javascript
var passage = require('passage');

route1 = passage.get('/test', function(req, res, next) {
    console.log(
        'i got called for GET /test'
    );
});

route2 = passage.post('/users/:userId', function(req, res, next, params) {
    console.log(
        'i got called for POST /users/' + params.userId
    );
});
```

### complex example

the example uses [sequenz](https://github.com/snd/sequenz) to compose middleware (to make a single middleware from multiple middlewares).

```javascript
var http = require('http');
var passage = require('passage');
var sequenz = require('sequenz');

var routes = sequenz(
    passage.any('*', function(req, res, next) {
        console.log('i got called for any method and any url');
        next();
    }),
    passage.get('/', function(req, res, next) {
        console.log('i got called for GET /'
        res.end('hello');
    }),
    passage.any('/users*', function(req, res, next) {
        console.log('i got called for an url that starts with /users with any method');
        next();
    passage.get('/users/:userId/posts/:postId', function(req, res, next, params) {
        console.log('i got called for GET /users/', params.userId, '/posts/', params.postId);
        next();
    }),
);

server = http.createServer(routes);

server.listen(80);
```

### license: MIT

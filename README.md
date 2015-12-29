# passage

[![NPM Package](https://img.shields.io/npm/v/passage.svg?style=flat)](https://www.npmjs.org/package/passage)
[![Build Status](https://travis-ci.org/snd/passage.svg?branch=master)](https://travis-ci.org/snd/passage/branches)
[![codecov.io](http://codecov.io/github/snd/passage/coverage.svg?branch=master)](http://codecov.io/github/snd/passage?branch=master)
[![Dependencies](https://david-dm.org/snd/passage.svg)](https://david-dm.org/snd/passage)

**simple composable routing middleware for nodejs**

```
npm install passage
```

```javascript
var http = require('http');
var passage = require('passage');
var sequenz = require('sequenz');

var server = http.createServer(sequenz(
  passage.any('*', function(req, res, next) {
    console.log('i got called for any method and any url');
    next();
  }),
  passage.get('/', function(req, res, next) {
    res.end('i got called for GET /');
  }),
  passage.any('/users*', function(req, res, next) {
    console.log('i got called for an url that starts with /users with any method');
    next();
  passage.get('/users/:userId/posts/:postId', function(req, res, next, params) {
    res.end('i got called for GET /users/' + params.userId + '/posts/' + params.postId);
  }),
  passage.post('/users/:userId/posts', function(req, res, next, params) {
    res.end('i got called for POST /users/' + params.userId + '/posts/');
  }),
  passage.put('/users/:userId/posts/:postId', function(req, res, next, params) {
    res.end('i got called for PUT /users/' + params.userId + '/posts/' + params.postId);
  }),
  passage.patch('/users/:userId/posts/:postId', function(req, res, next, params) {
    res.end('i got called for PATCH /users/' + params.userId + '/posts/' + params.postId);
  }),
  passage.delete('/users/:id', function(req, res, next, params) {
    res.end('i got called for DELETE /users/' + params.id);
  })
));

server.listen(80);
```

[sequenz](https://github.com/snd/sequenz) takes an array of middlewares
and returns a single middleware that runs the middlewares in order.

the first argument to the passage functions can by any [url-pattern](https://github.com/snd/url-pattern).

## vhost example

```javascript
var http = require('http');
var connect = require('connect');
var passage = require('passage');
var sequenz = require('sequenz');

var routes = sequenz(
  passage.vhost('alice.example.com', connect.static('public/alice')),
  passage.vhost('bob.example.com', connect.static('public/bob')),
  passage.vhost(':sub.example.com', function(req, res, next, params) {
    console.log('i got called for ' + params.sub + '.example.com');
    next();
);

server = http.createServer(routes);

server.listen(80);
```

### [contributing](contributing.md)

### [license: MIT](LICENSE)

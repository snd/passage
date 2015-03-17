// Generated by CoffeeScript 1.7.1
var newPattern, router, vhost;

newPattern = require('url-pattern').newPattern;

vhost = function(pattern, handler) {
  var hostPattern, separator;
  separator = '.';
  hostPattern = newPattern(pattern, separator);
  return function(req, res, next) {
    var match;
    match = hostPattern.match(req.headers.host);
    if (!match) {
      return next();
    }
    return handler(req, res, next, match);
  };
};

router = function(predicate) {
  return function(pattern, handler) {
    var urlPattern;
    urlPattern = newPattern(pattern);
    return function(req, res, next) {
      var match, urlWithoutQuerystring;
      if (!predicate(req)) {
        return next();
      }
      urlWithoutQuerystring = req.url.split('?')[0];
      match = urlPattern.match(urlWithoutQuerystring);
      if (!match) {
        return next();
      }
      return handler(req, res, next, match);
    };
  };
};

module.exports = {
  router: router,
  vhost: vhost,
  any: router(function() {
    return true;
  }),
  get: router(function(req) {
    var _ref;
    return (_ref = req.method.toUpperCase()) === 'GET' || _ref === 'HEAD';
  }),
  post: router(function(req) {
    return req.method.toUpperCase() === 'POST';
  }),
  put: router(function(req) {
    return req.method.toUpperCase() === 'PUT';
  }),
  "delete": router(function(req) {
    return req.method.toUpperCase() === 'DELETE';
  }),
  patch: router(function(req) {
    return req.method.toUpperCase() === 'PATCH';
  })
};

angular.module('chatApp').service('api', function ($http, $cacheFactory) {
  var apiUrl = 'http://api.dev.watchthinkchat.com:5000';
  var apiCache = $cacheFactory('api');

  this.call = function (method, url, data, successFn, errorFn, cache) {
    if(cache){
      var cachedData = apiCache.get(url);
      if (angular.isDefined(cachedData)) {
        successFn(cachedData, 200);
        return;
      }
    }
    $http({
      method: method,
      url: apiUrl + url,
      data: data,
      headers: {
      },
      timeout: 5000
    }).
        success(function(data, status) {
          if(_.isFunction(successFn)){
            successFn(data, status);
          }
          if(cache){
            apiCache.put(url, data);
          }
        }).
        error(function(data, status) {
          console.log('API ERROR: ' + status);
          if(_.isFunction(errorFn)){
            errorFn(data, status);
          }
        });
  };
});

angular.module('chatApp').service('manageApi', function ($http, $cacheFactory) {
  var apiUrl = '/api/';
  var apiCache = $cacheFactory('manageApi');

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
      timeout: 5000
    }).success(function(data, status) {
          if(_.isFunction(successFn)){
            successFn(data, status);
          }
          if(cache){
            apiCache.put(url, data);
          }
        }).
        error(function(data, status) {
          if(_.isFunction(errorFn)){
            errorFn(data, status);
          }
        });
  };
});

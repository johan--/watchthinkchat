//= require angular
//= require lodash
//= require_self
//= require_tree

window.app = angular.module('translations_edit', []);

app.config(function($httpProvider) {
  var authToken;
  authToken = $("meta[name=\"csrf-token\"]").attr("content");
  $httpProvider.defaults.headers.common['X-CSRF-TOKEN'] = authToken;
  return $httpProvider.defaults.headers.common['Content-Type'] = 'application/json;charset=utf-8';
});

app.controller('translateCtrl', function ($scope, $http) {
  $scope.terms = window.base_translations;
  $scope.transTerm = {};

  var saveTranslation = function(id, val){
    var campaign_id = _.find(window.base_translations, {'id': parseInt(id)}).campaign_id;
    var method = 'PUT';
    if(val.trim() === ''){
      method = 'DELETE';
    }
    $http({
      method: method,
      url: '/api/campaigns/' + campaign_id + '/locales/' + window.locale_id + '/translations/' + id,
      data: {
        content: val
      }
    });
  };

  var getTranslation = function(id){
    var campaign_id = _.find(window.base_translations, {'id': id}).campaign_id;

    $http({
      method: 'GET',
      url: '/api/campaigns/' + campaign_id + '/locales/' + window.locale_id + '/translations/' + id
    }).success(function(data) {
      $scope.transTerm[id] = data.content;
    });
  };

  angular.forEach($scope.terms, function(t){
    getTranslation(t.id);
  });

  $scope.$watch('transTerm', function(newValue, oldValue) {
    angular.forEach(newValue, function(v, i){
      if(oldValue[i] !== newValue[i]){
        if(angular.isDefined(oldValue[i])){
          saveTranslation(i, v);
        }
      }
    });
  }, true);

  $scope.clearVal = function(id) {
    $scope.transTerm[id] = '';
  };
});
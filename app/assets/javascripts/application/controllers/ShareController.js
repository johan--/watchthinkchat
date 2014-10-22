angular.module('chatApp').controller('ShareController', function ($scope, $window, api) {
  api.call('get', '/v1/visitor', null, function(data){
    $scope.visitorInfo = data;
  });

  $scope.facebookShare = function(url){
    $window.open('https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(url), 'fbShare', 'height=250,width=650');
  };

  $scope.twitterShare = function(url){
    $window.open('https://twitter.com/share?url=' + encodeURIComponent(url), 'twitterShare', 'height=400,width=650');
  };
});
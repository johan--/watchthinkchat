angular.module('chatApp').controller('ShareController', function ($scope, api, facebook) {
  $scope.currentInvites = [];

  var getCurrentInvites = function(){
    api.call('get', '/v1/invitees', null, function(data){
      $scope.currentInvites = data;
    });
  };
  getCurrentInvites();

  $scope.facebookLogin = function(){
    //facebook.login();
    facebook.getFriends();
  };

  $scope.sendInvite = function(data){
    console.log(data);
    api.call('post', '/v1/invitees', {
      invitee: data
    }, function(){
      $scope.invite = {};
      getCurrentInvites();
    });
  };
});
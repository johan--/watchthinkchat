angular.module('chatApp').controller('CompleteController', function ($scope, $rootScope, $window) {
  var communityObj = $rootScope.campaign.community;

  if(communityObj.enabled){
    if(communityObj.other_campaign){
      $window.location.href = communityObj.permalink;
    }else{
      $scope.communityObj = communityObj;
    }
  }
});
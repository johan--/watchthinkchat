angular.module('chatApp').controller('ManageController', function ($scope, manageApi) {
  manageApi.call('get', 'campaigns', {}, function(data){
    $scope.myCampaigns = data;
  }, null, true);
});
angular.module('chatApp').controller('ManageEditController', function ($scope, $routeParams, manageApi) {
  manageApi.call('get', 'campaigns', {}, function(data){
    $scope.myCampaigns = data;
    if(angular.isDefined($routeParams.campaignId)){
      $scope.activeCampaign = angular.copy(_.find(data, { 'uid': $routeParams.campaignId }));
    }else{
      //new campaign defaults
      $scope.activeCampaign = {
        growth_challenge: 'auto',
        type: 'youtube',
        max_chats: 4,
        language: 'en'
      };
    }
  }, null, true);

  $scope.saveCampaign = function () {
    manageApi.call('put', 'campaigns/' + $scope.activeCampaign.uid + '.json', $scope.activeCampaign, function(data){
      console.log(data);
    });
  };

  $scope.createCampaign = function () {
    manageApi.call('post', 'campaigns', $scope.activeCampaign, function(data){
      console.log(data);
    });
  };

  $scope.languages = [
    {
      id: 'en',
      name: 'English'
    },
    {
      id: 'es',
      name: 'Spanish / Español'
    }
  ];
});
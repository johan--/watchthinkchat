angular.module('chatApp').controller('ManageEditController', function ($scope, $routeParams, $timeout, manageApi) {
  var activeCampaignIndex;
  manageApi.call('get', 'campaigns', {}, function(data){
    $scope.myCampaigns = data;
    if(angular.isDefined($routeParams.campaignId)){
      $scope.activeCampaign = angular.copy(_.find(data, { 'uid': $routeParams.campaignId }));
      activeCampaignIndex = _.findIndex(data, { 'uid': $routeParams.campaignId });

      $scope.refreshStats();
    }else{
      //new campaign defaults
      $scope.activeCampaign = {
        growth_challenge: 'auto',
        type: 'youtube',
        max_chats: 4,
        language: 'en',
        status: 'opened'
      };
    }
  }, null, true);

  $scope.refreshStats = function () {
    $scope.statsUpdateTime = '-';
    manageApi.call('get', 'campaigns/' + $routeParams.campaignId + '/stats', {}, function(data){
      $scope.campaignStats = data;
      $scope.statsUpdateTime = new Date();
    });
  };

  $scope.saveCampaign = function () {
    $scope.notify = {
      message: 'Saving...',
      class: 'bg-warning'
    };
    manageApi.call('put', 'campaigns/' + $scope.activeCampaign.uid, $scope.activeCampaign, function(data){
      $scope.notify = {
        message: 'Campaign saved.',
        class: 'bg-success'
      };
      $scope.myCampaigns[activeCampaignIndex] = data;
      console.log(activeCampaignIndex, data);

      $timeout(function() {
        $scope.notify = {};
      }, 3500);
    }, function(data){
      $scope.notify = {
        message: 'Error: ' + data,
        class: 'bg-danger'
      };
    });
  };

  $scope.createCampaign = function () {
    $scope.notify = {
      message: 'Saving...',
      class: 'bg-warning'
    };
    manageApi.call('post', 'campaigns', $scope.activeCampaign, function(data){
      $scope.myCampaigns.push(data);

      $scope.notify = {
        message: 'Campaign created.',
        class: 'bg-success'
      };
    }, function(data){
      $scope.notify = {
        message: 'Error: ' + data,
        class: 'bg-danger'
      };
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
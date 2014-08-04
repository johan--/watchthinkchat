angular.module('chatApp').controller('ManageEditController', function ($scope, $routeParams, $timeout, $location, manageApi) {
  $scope.refreshStats = function () {
    $scope.statsUpdateTime = '-';
    manageApi.call('get', 'campaigns/' + $routeParams.campaignId + '/stats', {}, function(data){
      $scope.campaignStats = data;
      $scope.statsUpdateTime = new Date();
    });
  };

  var activeCampaignIndex;
  manageApi.call('get', 'campaigns', {}, function(data){
    $scope.myCampaigns = data;
    if(angular.isDefined($routeParams.campaignId)){
      $scope.activeCampaign = angular.copy(_.find(data, { 'uid': $routeParams.campaignId }));
      activeCampaignIndex = _.findIndex(data, { 'uid': $routeParams.campaignId });

      $scope.refreshStats();
      $scope.wizardTab = 'campaign';
    }else{
      //new campaign defaults
      $scope.activeCampaign = {
        growth_challenge: 'auto',
        type: 'youtube',
        max_chats: 2,
        language: 'en',
        status: 'opened',
        preemptive_chat: 'false'
      };
      $scope.wizardTab = '1';
    }
  }, null, true);

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
        message: 'Error: ' + data.error[0],
        class: 'bg-danger'
      };
    });
  };

  $scope.createCampaign = function () {
    $scope.notify = {
      message: 'Saving...',
      class: 'bg-warning'
    };
    manageApi.call('post', 'campaigns', $scope.activeCampaign, function(data) {
      $scope.myCampaigns.push(data);

      $scope.notify = {
        message: 'Campaign created.',
        class: 'bg-success'
      };

      $location.path('/manage/' + data.uid);
    }, function(data){
      $scope.notify = {
        message: 'Error: ' + data.error[0],
        class: 'bg-danger'
      };
    });
  };

  $scope.onlineOperatorCount = function() {
    if(angular.isDefined($scope.campaignStats)) {
      return _.filter($scope.campaignStats.operators, { status: 'online' }).length;
    }else{
      return '-';
    }
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

  $scope.changeWizardTab = function(tab){
    if(tab === '2'){
        if(_.isEmpty($scope.activeCampaign.title)){
            alert('Please enter a campaign title.');
            tab = '1';
        }
        $scope.activeCampaign.permalink = encodeURIComponent($scope.activeCampaign.title);
    }
    $scope.wizardTab = tab;
  };
});
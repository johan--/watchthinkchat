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
      $scope.inviteEmails = '';
      $scope.activeCampaign = {
        growth_challenge: 'auto',
        type: 'youtube',
        max_chats: 2,
        language: 'en',
        status: 'opened',
        preemptive_chat: 'false',
        //default video #FallingPlates
        video_id: 'KGlx11BxF24'
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
    var inviteEmails = $scope.inviteEmails.split(',');

    manageApi.call('post', 'campaigns', $scope.activeCampaign, function(data) {
      $scope.myCampaigns.push(data);

      if(inviteEmails.length){
          $scope.notify = {
              message: 'Campaign created. Sending emails...',
              class: 'bg-warning'
          };

          sendEmailInvite(inviteEmails, function(){
              $scope.notify = {
                  message: 'Campaign created. Emails Sent.',
                  class: 'bg-success'
              };
          });
      }else{
          $scope.notify = {
              message: 'Campaign created.',
              class: 'bg-success'
          };
      }

      $location.path('/manage/' + data.uid);
    }, function(data){
      $scope.notify = {
        message: 'Error: ' + data.error[0],
        class: 'bg-danger'
      };
    });
  };

  var sendEmailInvite = function(inviteEmails, callback){
      var to = inviteEmails[0];
      manageApi.call('post', 'emails', {
          to: to.trim(),
          from: "noreply@watchthinkchat.com",
          from_name: "WatchThinkChat",
          message: "You have been invited to participate in '" + $scope.activeCampaign.title + "'. To access the operator console, go to http://www.godchat.tv/" + $scope.activeCampaign.permalink + ".\n\nPassword: " + $scope.activeCampaign.password,
          subject: "Invite to join '" + $scope.activeCampaign.title + "'"
      }, function() {
          inviteEmails.shift();
          if(inviteEmails.length){
              sendEmailInvite(inviteEmails, callback);
          }else{
              callback();
          }
      }, function(){
          inviteEmails.shift();
          if(inviteEmails.length){
              sendEmailInvite(inviteEmails, callback);
          }else{
              callback();
          }
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
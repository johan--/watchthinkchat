angular.module('chatApp').controller('VideoController', function ($scope, $rootScope, $location) {
  $scope.playerVars = {
    autoplay: 0,
    modestbranding: 1,
    rel: 0,
    showinfo: 0,
    iv_load_policy: 3,
    html5: 1
  };
  if($rootScope.campaign.engagement_player.media_start){
    $scope.playerVars.start = $rootScope.campaign.engagement_player.media_start;
  }
  if($rootScope.campaign.engagement_player.media_stop){
    $scope.playerVars.end = $rootScope.campaign.engagement_player.media_stop;
  }

  $scope.$on('youtube.player.ended', function ($event, player) {
    if($rootScope.campaign.survey.enabled){
      $location.path('/q/' + $rootScope.campaign.survey.questions[0].code);
    }else{
      $location.path('/complete');
    }
  });
});
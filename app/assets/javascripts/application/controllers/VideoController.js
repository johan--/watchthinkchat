angular.module('chatApp').controller('VideoController', function ($scope, $rootScope, $location) {
  console.log($rootScope.campaign);

  $scope.playerVars = {
    autoplay: 0,
    modestbranding: 1,
    rel: 0,
    showinfo: 0,
    iv_load_policy: 3,
    html5: 1
  };

  $scope.$on('youtube.player.ended', function ($event, player) {
    $location.path('/q/' + $rootScope.campaign.engagement_player.questions[0].id);
  });
});
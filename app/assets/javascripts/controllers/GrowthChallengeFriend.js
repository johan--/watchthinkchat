'use strict';

angular.module('chatApp').controller('ChallengeFriendController', function ($scope, $http, $route) {
  $('body').css('background',' #7D868c');
  window.document.title = 'WatchThinkChat Growth Challenge';
  $('.after-chat-information').show();

  $scope.successfulSubscribe = '';

  $scope.emailSubscribe = function (){
    var button_id = $route.current.params.button_id;
    $http({method: 'JSONP',
      url: 'http://gcx.us6.list-manage.com/subscribe/post-json?u=1b47a61580fbf999b866d249a&id=c3b97c030f' +
        '&EMAIL=' + encodeURIComponent($scope.visitor_email) +
        '&FRIEND=' + encodeURIComponent('Yes') +
        '&RESPCODE=' + encodeURIComponent(button_id) +
        '&c=JSON_CALLBACK'
    }).success(function (data, status, headers, config) {
      if (data.result === 'success') {
        $scope.successfulSubscribe = data.msg;
        $scope.visitor_email = '';
      } else {
        alert('Error: ' + data.msg);
      }
    }).error(function (data, status, headers, config) {
      alert('Error: Could not connect to mail service.');
    });
  }
});

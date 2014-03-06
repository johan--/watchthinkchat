'use strict';

angular.module('chatApp').controller('ChallengeFriendController', function ($scope, $http, $route, Crypt) {
  $('body').css('background',' #58504A');
  window.document.title = 'WatchThinkChat Growth Challenge';
  $('.after-chat-information').show();

  $scope.friendsEmail = Crypt.decodeStr($route.current.params.refer);
  if($route.current.params.n==''){
    $scope.friendsName = '';
  }else{
    $scope.friendsName = Crypt.decodeStr($route.current.params.n);
  }
  $scope.successfulSubscribe = '';

  $scope.emailSubscribe = function (){
    var button_id = $route.current.params.button_id;
    $http({method: 'JSONP',
      url: 'https://gcx.us6.list-manage.com/subscribe/post-json?u=1b47a61580fbf999b866d249a&id=c3b97c030f' +
        '&EMAIL=' + encodeURIComponent($scope.visitor_email) +
        '&FRIEND=' + encodeURIComponent('Yes') +
        '&RESPCODE=' + encodeURIComponent(button_id) +
        '&c=JSON_CALLBACK'
    }).success(function (data, status, headers, config) {
      if (data.result === 'success') {
          //notify mission hub
          var post_data = {
              challenge_friend_accepted: $scope.visitor_email
          };
          $http({method: 'PUT', url: '/api/visitors/'+$route.current.params.v, data: post_data}).
              success(function (data, status, headers, config) {
              }).error(function (data, status, headers, config) {
              });
        $scope.successfulSubscribe = data.msg;
        $scope.visitor_email = '';
      } else {
        alert('Error: ' + data.msg);
      }
    }).error(function (data, status, headers, config) {
      alert('Error: Could not connect to mail service.');
    });
  }

    $scope.facebookLogin = function () {
        FB.login(function (response) {
            if (response.authResponse) {
                FB.api('/me', function (response) {
                    //console.log(response);
                    $scope.$apply(function () {
                        $scope.visitor_email = response.email;
                        $scope.visitor_fb_data = response;
                    });
                });
            }
        });
    }
});

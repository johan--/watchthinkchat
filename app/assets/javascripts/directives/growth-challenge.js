angular.module('chatApp')
  .directive('growthChallenge', function () {
    return {
      restrict: 'E',
      templateUrl: '/templates/growthchallenge.html',
      link: function (scope, element, attrs){
        if(attrs.step == '2'){
          $('#after-chat-information-02').show();
        }
      },
      controller: function ($scope, $http, $route) {
        $scope.nextStep = function(step){
          if(step == 2){
            $('#after-chat-information-01, .after-chat-challenge').hide();
            if(window.innerWidth <= 800 && !angular.isDefined($route.current.params.button_id)){
              window.open('/challenge?button_id=' + $scope.button_clicked.id);
            }else{
              $('#after-chat-information-02').show();
            }
          }else if(step == 3){
            if(angular.isDefined($scope.button_clicked)){
              var button_id = $scope.button_clicked.id;
            }else{
              var button_id = $route.current.params.button_id;
            }
            $scope.friend_url = 'http://www.watchthinkchat.com/challenge/friend?button_id='+button_id
            $http({method: 'JSONP',
              url: 'http://gcx.us6.list-manage.com/subscribe/post-json?u=1b47a61580fbf999b866d249a&id=c3b97c030f' +
                '&EMAIL=' + encodeURIComponent($scope.visitor_email) +
                '&RESPCODE=' + encodeURIComponent(button_id) +
                '&c=JSON_CALLBACK'
            }).success(function (data, status, headers, config) {
              if (data.result === 'success') {
                $('#after-chat-information-02').hide();
                $('#after-chat-information-03').show();
              } else {
                alert('Error: ' + data.msg);
              }
            }).error(function (data, status, headers, config) {
              alert('Error: Could not connect to mail service.');
              return;
            });
          }else if(step == 4){
            FB.ui({
              method: 'send',
              link: $scope.friend_url
            });
            $scope.nextStep(7);
          }else if(step == 5){
            $('#after-chat-information-05').modal({backdrop: false, show: true});
          }else if(step ==6){
            $('#after-chat-information-05').modal('hide');
            $scope.nextStep(7);
          }else if(step == 7){
            $('#after-chat-information-06').show();
            $('#after-chat-information-03').hide();
          }else if(step == 99){
            $('.after-chat-information').hide();
            $('#after-chat-information-exit').show();
          }
        };

        FB.init({
          appId      : '555591577865154',
          status     : true,
          xfbml      : true
        });
      }
    };
  });
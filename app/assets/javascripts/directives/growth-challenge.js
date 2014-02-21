angular.module('chatApp')
  .directive('growthChallenge', function () {
    return {
      restrict: 'E',
      templateUrl: '/templates/growthchallenge.html',
      link: function (scope, element, attrs){
        if(attrs.step == '2'){
          setTimeout(function(){ scope.nextStep(2); },1500);
        }
      },
      controller: function ($scope, $http, $route) {
        var visitor_fb_data = {
          id: '',
          first_name:'',
          last_name: '',
          email: ''
        };
        $scope.nextStep = function(step, fblogin){
          if(step == 1){
            if(window.innerWidth <= 800){ //if mobile
              var challengeUrl = '/challenge?button_id=' + $scope.button_clicked.id + '&fb=' + fblogin;
              if(fblogin){
                window.open('https://www.facebook.com/dialog/oauth?client_id=555591577865154&redirect_uri=' + encodeURIComponent('http://www.watchthinkchat.com'+challengeUrl));
              }else{
                window.open(challengeUrl);
              }
            }else{ //if desktop
              if(fblogin){
                FB.login(function(response) {
                  if (response.authResponse) {
                    $scope.nextStep(2, fblogin);
                  }
                });
              }else{
                $scope.nextStep(2, fblogin)
              }
            }
          }else if(step == 2){
            $('#after-chat-information-01, .after-chat-challenge').hide();
            $('#after-chat-information-02').show();
            if(fblogin || $route.current.params.fb == 'true'){
              FB.api('/me', function(response) {
                visitor_fb_data = response;
                $scope.$apply(function(){
                  $scope.visitor_email = visitor_fb_data.email;
                  $scope.visitor_name = visitor_fb_data.name;
                });
                try{
                  $scope.postVisitorInfo(response);
                }catch(e){
                }
              });
            }
          }else if(step == 3){
            if(angular.isDefined($scope.button_clicked)){
              var button_id = $scope.button_clicked.id;
            }else{
              var button_id = $route.current.params.button_id;
            }
            $scope.friend_url = 'http://www.watchthinkchat.com/challenge/friend?button_id='+button_id
            $http({method: 'JSONP',
              url: 'https://gcx.us6.list-manage.com/subscribe/post-json?u=1b47a61580fbf999b866d249a&id=c3b97c030f' +
                '&EMAIL=' + encodeURIComponent($scope.visitor_email) +
                '&FNAME=' + encodeURIComponent(visitor_fb_data.first_name) +
                '&LNAME=' + encodeURIComponent(visitor_fb_data.last_name) +
                '&RESPCODE=' + encodeURIComponent(button_id) +
                '&c=JSON_CALLBACK'
            }).success(function (data, status, headers, config) {
              if (data.result === 'success') {
                $('#after-chat-information-02').hide();
                $('#after-chat-information-03').show();

                try{
                  $scope.postActivityMessage('Visitor has signed up for the Growth Challenge.');
                }catch(e){
                }

                //notify mission hub
                var post_data = {
                  fb_uid: visitor_fb_data.id,
                  visitor_email: $scope.visitor_email,
                  challenge_subscribe_self: true
                };
                $http({method: 'POST', url: '/api/visitors/'+window.localStorage.getItem('gchat_visitor_id'), data: post_data}).
                  success(function (data, status, headers, config) {
                  }).error(function (data, status, headers, config) {
                  });
              } else {
                alert('Error: ' + data.msg);
              }
            }).error(function (data, status, headers, config) {
              alert('Error: Could not connect to mail service.');
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
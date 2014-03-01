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
        if(window.innerWidth <= 800){
          $scope.isMobile = true
        }else{
          $scope.isMobile = false
        }
        var visitor_fb_data = {
          id: '',
          first_name:'',
          last_name: '',
          email: ''
        };
        $scope.nextStep = function(step, fblogin){
          if(step == 0){
            $('#after-chat-information-02').hide();
            $('.after-chat-challenge, #after-chat-information-01').fadeIn();
          }else if(step == 1){
            if($scope.isMobile){ //if mobile
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
                $scope.postVisitorInfo(response);
              });
            }
          }else if(step == 3){
            if(angular.isDefined($scope.button_clicked)){
              var button_id = $scope.button_clicked.id;
            }else{
              var button_id = $route.current.params.button_id;
            }
            var chat_uid = window.localStorage.getItem('gchat_chat_uid');
            $scope.friend_url = 'http://www.watchthinkchat.com/challenge/friend?session='+chat_uid+'&button_id='+button_id
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
                $http({method: 'PUT', url: '/api/visitors/'+window.localStorage.getItem('gchat_visitor_id'), data: post_data}).
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
            $scope.email_message='I just watched a Christian film called #FallingPlates and decided to accept the "Growth Challenge" that was offered. I got to pick one friend to help me grow spiritually and I chose you!\n\n' +
              'Would you be willing to help by looking at the email content we would get, and then discussing it with me? This means 4 emails, 4 conversations over 4 weeks. That\'s it.\n\n' +
              'Lets take the challenge together!\n\n' +
              'You can click here to find out more information:\n' +
              $scope.friend_url;
            $('#after-chat-information-05').modal({backdrop: false, show: true});
          }else if(step ==6){
            if(!$scope.visitor_name){
              alert('Please enter Your Name.');
              return;
            }
            if(!validateEmail($scope.visitor_email)){
              alert('Your Email must be a valid email address.');
              return;
            }
            if(!validateEmail($scope.friend_email)){
              alert('Your Friend\'s Email must be a valid email address.');
              return;
            }

            //Send email
            $('#after-chat-information-05 .modal-footer button').hide();
            $('#after-chat-information-05 .modal-footer p').show();
            var post_data = {
              to: $scope.friend_email,
              from: $scope.visitor_email,
              from_name: $scope.visitor_name,
              subject: 'Take the "Growth Challenge" with me',
              message: $scope.email_message
            };
            $http({method: 'POST', url: '/api/emails', data: post_data}).
              success(function (data, status, headers, config) {
                $('#after-chat-information-05').modal('hide');
                $scope.nextStep(7);
              }).error(function (data, status, headers, config) {
                $('#after-chat-information-05 .modal-footer button').show();
                $('#after-chat-information-05 .modal-footer p').hide();
                alert('Error: '+data);
              });
          }else if(step == 7){
            //notify mission hub
            var post_data = {
              fb_uid: visitor_fb_data.id,
              visitor_email: $scope.visitor_email,
              challenge_subscribe_friend: $scope.friend_email || 'facebook'
            };
            $http({method: 'PUT', url: '/api/visitors/'+window.localStorage.getItem('gchat_visitor_id'), data: post_data}).
              success(function (data, status, headers, config) {
              }).error(function (data, status, headers, config) {
              });
            $('#after-chat-information-06').show();
            $('#after-chat-information-03').hide();
          }else if(step == 99){
            $('.after-chat-information').hide();
            $('#after-chat-information-exit').show();
          }
        };

        /*$scope.postVisitorInfo = function(data){
          try{
            $scope.postActivityMessage('Visitor has logged in with Facebook.');
          }catch(e){}
          var chat_uid = window.localStorage.getItem('gchat_chat_uid');
          var visitor_uid = window.localStorage.getItem('gchat_visitor_id');
          var post_data = {
            user_uid: visitor_uid,
            message_type: 'fbName',
            message: data.name
          };
          $http({method: 'POST', url: '/api/chats/'+chat_uid+'/messages', data: post_data}).
            success(function (data, status, headers, config) {
            }).error(function (data, status, headers, config) {
            });
          var post_data = {
            user_uid: visitor_uid,
            message_type: 'fbEmail',
            message: data.email
          };
          $http({method: 'POST', url: '/api/chats/'+chat_uid+'/messages', data: post_data}).
            success(function (data, status, headers, config) {
            }).error(function (data, status, headers, config) {
            });
          var post_data = {
            user_uid: visitor_uid,
            message_type: 'fbId',
            message: data.id
          };
          $http({method: 'POST', url: '/api/chats/'+chat_uid+'/messages', data: post_data}).
            success(function (data, status, headers, config) {
            }).error(function (data, status, headers, config) {
            });
        }*/

        var validateEmail = function(email) {
          var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
          return re.test(email);
        }

/*        FB.init({
          appId      : '555591577865154',
          status     : true,
          xfbml      : true
        });*/
      }
    };
  });
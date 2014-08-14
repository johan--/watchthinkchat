angular.module('chatApp')
  .directive('growthChallenge', function () {
    return {
      restrict: 'E',
      templateUrl: '/templates/growthchallenge.html',
      link: function (scope, element, attrs){

      },
      controller: function ($scope, $rootScope, $http, Crypt) {
        $scope.growthChallengeNextStep = function(step){
          if(step==2){
            $('.after-chat-challenge').hide();
            $scope.growthChallengeStep=2;
          }else if(step==3){
            var button_id = $scope.button_clicked.id;
            if($scope.button_clicked.id===6){
              $scope.friend_url = 'http://www.watchthinkchat.com/c/' + $scope.campaign_data.uid +
                '?o=' + $scope.operator_data.uid +
                '&refer=' + encodeURIComponent(Crypt.encodeStr($scope.visitor_email)) +
                '&n=' + encodeURIComponent(Crypt.encodeStr($rootScope.visitor_data.first_name));
            }else{
              $scope.friend_url = 'http://www.watchthinkchat.com/challenge/friend?v=' + $rootScope.visitor_data.uid +
                '&button_id='+button_id +
                '&c=' + encodeURIComponent($scope.campaign_data.uid) +
                '&refer=' + encodeURIComponent(Crypt.encodeStr($scope.visitor_email)) +
                '&n=' + encodeURIComponent(Crypt.encodeStr($rootScope.visitor_data.first_name));
            }

            //create short url
            $http({method: 'POST', url: '/api/url_fwds', data: {url: $scope.friend_url}}).
              success(function (data, status, headers) {
                $scope.friend_url = 'http://www.watchthinkchat.com' + data.short_url;
              }).error(function() {
              });
            $http({method: 'JSONP',
              url: 'https://gcx.us6.list-manage.com/subscribe/post-json?u=1b47a61580fbf999b866d249a&id=c3b97c030f' +
                '&EMAIL=' + encodeURIComponent($scope.visitor_email) +
                '&FNAME=' + encodeURIComponent($rootScope.visitor_data.first_name) +
                '&LNAME=' + encodeURIComponent($rootScope.visitor_data.last_name) +
                '&RESPCODE=' + encodeURIComponent(button_id) +
                '&c=JSON_CALLBACK'
            }).success(function (data, status, headers, config) {
              if (data.result === 'success') {
                $scope.growthChallengeStep=3;

                //notify mission hub
                var post_data = {
                  fb_uid: $rootScope.visitor_data.fb_id,
                  visitor_email: $scope.visitor_email,
                  challenge_subscribe_self: true
                };
                $http({method: 'PUT', url: '/api/visitors/'+$rootScope.visitor_data.uid, data: post_data});
              } else {
                alert('Error: ' + data.msg);
              }
            }).error(function (data, status, headers, config) {
              alert('Error: Could not connect to mail service.');
            });
          }
        };

        $scope.growthChallengePrevStep = function(){
          switch($scope.growthChallengeStep){
            case 1:
              $scope.growthChallengeStep=0;
              $('.after-chat-challenge').hide();
              break;
            case 2:
              $scope.growthChallengeStep=1;
              $('.after-chat-challenge').show();
              break;
            case 3:
              $scope.growthChallengeStep=2;
              break;
            case 9:
              $scope.growthChallengeStep=3;
              break;
          }
        };

        $scope.growthChallengeInviteFriend = function(how){
          if(how=='fb'){
            FB.ui({
              method: 'send',
              link: $scope.friend_url
            });
            $scope.growthChallengeStep=10;
            clicky.goal($scope.campaign_data.permalink + ': Invited friend and completed Growth Challenge via Facebook');
          }else if(how=='email'){
            $scope.email_message=$scope.translation.GC_FORM_MESSAGE_1 + $scope.friend_url;
            $('#growth-challenge-invite-friend').modal({backdrop: true, show: true});
          }else if(how=='sendemail'){
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
            $('#growth-challenge-invite-friend .modal-footer button').hide();
            $('#growth-challenge-invite-friend .modal-footer p').show();
            var post_data = {
              to: $scope.friend_email,
              from: $scope.visitor_email,
              from_name: $scope.visitor_name,
              subject: $scope.translation.GC_EMAIL_SUBJECT + ' ' + $scope.visitor_name,
              message: '=== [' + $scope.visitor_name + '\'s Comments] ===\n\n' +
                $scope.friend_name + ', ' + $scope.email_message +
                '\n\n === [Note from WatchThinkChat] ===\n\n'+
                'Greetings ' + $scope.friend_name + '\n\n'+
                'You are receiving this email because a friend of yours, ' + $scope.visitor_name + ' thought you would be able to talk with them and help them grow closer to Jesus Christ.\n\n' +
                'We are writing to introduce ourselves at WatchThinkChat.  We are a ministry dedicated to intentionally present the Gospel of Jesus Christ to all people so everyone knows someone who truly follows Jesus. This initiative is simply meant to connect people who are asking for guidance with trusted friends that can help them grow their relationship with Jesus. We are not selling anything. We just want to make meaningful connections in building the kingdom for the Lord.\n\n' +
                'Please click this link to learn a little more about the process regarding connecting with ' + $scope.visitor_name + '\n\n' +
                $scope.friend_url +
                'We will send you some free resources to help you be a great mentor. This will also let us know that you will be connecting with your friend.\n\n' +
                'We are delighted that ' + $scope.visitor_name + ' enjoyed the WatchThinkChat experience sufficiently to connect with you to provide assistance.\n\n' +
                'Serving with you,\nThe WatchThinkChat Team'
            };
            $http({method: 'POST', url: '/api/emails', data: post_data}).
              success(function (data, status, headers, config) {
                $('#growth-challenge-invite-friend').modal('hide');
                $scope.growthChallengeStep=10;
              }).error(function (data, status, headers, config) {
                $('#growth-challenge-invite-friend .modal-footer button').show();
                $('#growth-challenge-invite-friend .modal-footer p').hide();
                alert('Error: ' + data);
              });
            clicky.goal($scope.campaign_data.permalink + ': Invited friend and completed Growth Challenge via email');
          }else if(how=='accept'){
            //Send email
            $scope.growthChallengeStep=10;
            var post_data = {
              to: $scope.christianFriendEmail,
              from: $scope.visitor_email,
              from_name: $scope.visitor_name,
              subject: $scope.translation.GC_ACCEPTED_EMAIL_SUBJECT,
              message: $rootScope.visitor_data.name + '(' + $scope.visitor_email + ') ' + $scope.translation.GC_ACCEPTED_EMAIL_MESSAGE
            };
            $http({method: 'POST', url: '/api/emails', data: post_data});
          }
        };

      }
    };
  });
'use strict';

angular.module('chatApp').controller('OperatorController', function ($scope, $rootScope, $location, $route, $http) {
  var operator_data = {
    uid: $route.current.params.operatorId,
    profile_pic: '/assets/avatar.png'
  };
  var active_chat = '';
  var campaign_id = $location.search()['campaign'] || '';
  var operator_channel_connected = false;
  $scope.operator_edit_mode = false;
  var window_focus=true;
  var window_focus_timeout;

  if(!operator_data.uid){
    document.write('Invalid operator id');
    return;
  }
  if(!operator_data.uid){
    document.write('Invalid operator id');
    return;
  }

  if(!campaign_id){
    document.write('Invalid campaign id');
    return;
  }

  $scope.active_sessions=[];

  $scope.validatePassword = function() {
    $http({
      method: 'POST',
      url: '/api/campaigns/' + campaign_id + '/password',
      data: {
        password: $scope.campaignPassword
      }
    }).success(function (data, status, headers, config) {
      $('.password-overlay').fadeOut();
      $scope.operator_chat_url = "http://www.watchthinkchat.com/c/" + campaign_id + "?o=" + operator_data.uid;
      $http({method: 'GET', url: '/api/operators/' + operator_data.uid}).
        success(function (data, status, headers, config) {
          operator_data = data;
          $scope.operator_data = data;
          $scope.toggleOperatorStatus();
        }).error(function (data, status, headers, config) {

        });
    }).error(function (data, status, headers, config) {
      $('.password-overlay .alert').fadeIn().delay(2000).fadeOut();
    });
  };

  var pusher = new Pusher('249ce47158b276f4d32b');
  pusher.connection.bind('state_change', function(states) {
    // states = {previous: 'oldState', current: 'newState'}
/*    $('.operator_status').html(states.current);
    if(states.current === 'connected'){
      $('.operator_status').removeClass('operator_status_pending').addClass('operator_status_online');
    }else{
      $('.operator_status').removeClass('operator_status_online').addClass('operator_status_pending');
    }*/
  });


  $scope.switchChat = function (id) {
    var conversation = $('#chatbox_'+id+' .conversation');
    $('.chatbox').hide();
    $('#chatbox_' + id).show();
    $('#activesessions li').removeClass('activechat');
    $('#session_' + id).addClass('activechat');
    $('#session_' + id + ' .newmessage').css('visibility','hidden');
    active_chat = id;
    conversation.scrollTop(conversation[0].scrollHeight);
  };

  $scope.postMessage = function (id) {
    var message = $('#chatbox_' + id + ' .chat-message').val();
    $('#chatbox_' + id + ' .chat-message').val('');
    var conversation = $('#chatbox_' + id + ' .conversation');

    var post_data = {
      user_uid: operator_data.uid,
      message_type: 'user',
      message: message
    };
    $http({method: 'POST', url: '/api/chats/'+id+'/messages', data: post_data}).
      success(function (data, status, headers, config) {
        conversation.append('<li class="graybg"><div class="person">You</div>      <div class="timestamp pull-right timestamp-refresh" timestamp="' + Math.round(+new Date()).toString() + '">Just Now</div><div class="message">' + message + '</div></li>');
        conversation.scrollTop(conversation[0].scrollHeight);
      }).error(function (data, status, headers, config) {

      });
  };

  $scope.endChat = function (id) {
    $http({method: 'DELETE', url: '/api/chats/'+id}).
      success(function (data, status, headers, config) {
        var index = _.findIndex($scope.active_sessions, function(session) {
          return session.chat_uid == id;
        });
        $scope.active_sessions.splice(index, 1);
        pusher.unsubscribe('chat_'+id);
      }).error(function (data, status, headers, config) {

      });
  };

  $scope.toggleOperatorStatus = function(){
    if(operator_channel_connected){
      pusher.unsubscribe('operator_' + operator_data.uid);
      $('.operator_status').removeClass('operator_status_online').addClass('operator_status_offline');
      $('.operator_status').html('Offline');
      operator_channel_connected = false;
    }else{
      $('.operator_status').removeClass('operator_status_offline').addClass('operator_status_online');
      $('.operator_status').html('Online');
      operator_channel_connected = true;
      pusher.subscribe('operator_' + operator_data.uid).bind('newchat', function (newchat_data) {
        console.log('New Incoming Chat: '+ newchat_data.chat_uid);

        if(newchat_data.visitor_name == ''){
          newchat_data.visitor_name = 'Visitor '+($scope.active_sessions.length+1);
        }

        $scope.$apply(function () {
          $scope.active_sessions.push({
            chat_uid: newchat_data.chat_uid,
            visitor_uid: newchat_data.visitor_uid,
            visitor_name: newchat_data.visitor_name,
            visitor_profile: '/assets/avatar.png',
            activity: ''
          });
        });

        var chat_channel = pusher.subscribe('chat_'+newchat_data.chat_uid);
        chat_channel.bind('event', function (data) {
          if(data.user_uid != operator_data.uid){
            var conversation = $('#chatbox_'+newchat_data.chat_uid+' .conversation');
            if(data.message_type=='activity'){
              var index = _.findIndex($scope.active_sessions, function(session) {
                return session.chat_uid == newchat_data.chat_uid;
              });
              $scope.$apply(function () {
                $scope.active_sessions[index].activity = data.message;
              });
              conversation.append('<li> <div class="message-activity">' + data.message + '</div>      <div class="timestamp pull-right timestamp-refresh" timestamp="' + Math.round(+new Date()).toString() + '">Just Now</div>      <div class="person">' + newchat_data.visitor_name + '</div></li>');
            }else{
              conversation.append('<li> <div class="person">' + newchat_data.visitor_name + '</div>           <div class="timestamp pull-right timestamp-refresh" timestamp="' + Math.round(+new Date()).toString() + '">Just Now</div>      <div class="message">' + data.message + '</div></li>');
            }
            conversation.scrollTop(conversation[0].scrollHeight);

            if(active_chat != newchat_data.chat_uid || window_focus === false){
              var element = $('#session_' + newchat_data.chat_uid + ' .newmessage');
              element.css('visibility','visible');
              var distance = '5px';
              var speed = 210;
              var i;
              for(i = 0; i < 4; i++) {
                element.animate({marginTop: '-='+distance},speed)
                  .animate({marginTop: '+='+distance},speed);
              }
              $('#operatorAlert')[0].play();
            }
          }
        });
        chat_channel.bind('end', function () {
          console.log('End Chat: '+newchat_data.chat_uid);
          $scope.endChat(newchat_data.chat_uid);
        });
      });
    }

  };

/*  $scope.active_sessions.push({
    chat_uid: '265gf95sdg43',
    visitor_uid: '01',
    visitor_name: 'Visitor #1',
    visitor_profile: 'http://meisatransportation.com/img/Person_Undefined_Male_Light.png'
  });
  $scope.active_sessions.push({
    chat_uid: '265gfrth9sdg43',
    visitor_uid: '02',
    visitor_name: 'Visitor #2',
    visitor_profile: 'http://upload.wikimedia.org/wikipedia/commons/1/18/Gnome-Wikipedia-user-male.png'
  });*/

  var timeUpdate = setInterval(function () {
    $('.conversation .timestamp-refresh').each(function (i) {
      var origtime = parseInt($(this).attr('timestamp'));
      var unixtime = Math.round(+new Date());

      if ((unixtime - origtime) < 10000) {
        $(this).html('Just Now');
      } else if ((unixtime - origtime) < 60000) {
        $(this).html('about ' + Math.round((unixtime - origtime)/1000).toString() + ' seconds ago');
      } else if ((unixtime - origtime) < 120000) {
        $(this).html('about 1 min ago');
      } else if ((unixtime - origtime) < 240000) {
        $(this).html('about ' + Math.floor(((unixtime - origtime) / 60000)).toString() + ' mins ago');
      }else{
        $(this).html($filter('date')(origtime, 'shortTime'));
        $(this).removeClass('timestamp-refresh');
      }
    });
  }, 5000);

  $(window).focus(function() {
    window_focus=true;
    clearTimeout(window_focus_timeout);
  }).blur(function() {
    window_focus=false;
    window_focus_timeout = setTimeout(function(){
      console.log('2 mins inactivity, status set to: Offline');
      if(operator_channel_connected){
        $scope.toggleOperatorStatus();
      }
    },120000);
  }).trigger('focus');

});
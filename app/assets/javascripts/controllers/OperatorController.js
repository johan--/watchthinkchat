'use strict';

angular.module('chatApp').controller('OperatorController', function ($scope, $rootScope, $location, $http) {
  var operator_id = $location.search()['o'];
  var active_chat = '';
  $location.search('o', null);

  if(!operator_id){
    document.write('Invalid operator id');
    return;
  }

  $scope.operator_chat_url = "http://www.watchthinkchat.com/c" + $location.$$path + "?o=" + operator_id;
  $scope.active_sessions=[];

  var pusher = new Pusher('249ce47158b276f4d32b');
  var channel_operator = pusher.subscribe('operator_' + operator_id);
  channel_operator.bind('newchat', function (newchat_data) {
    console.log('New Incoming Chat: '+ newchat_data.chat_uid);

    if(newchat_data.visitor_name == ''){
      newchat_data.visitor_name = 'Visitor '+($scope.active_sessions.length+1);
    }

    $scope.$apply(function () {
      $scope.active_sessions.push({
        chat_uid: newchat_data.chat_uid,
        visitor_uid: newchat_data.visitor_uid,
        visitor_name: newchat_data.visitor_name,
        visitor_profile: 'http://www.newportoak.com/wp-content/uploads/default-avatar.jpg'
      });
    });

    pusher.subscribe('chat_'+newchat_data.chat_uid).bind('event', function (data) {
      console.log(data);
      if(data.user_uid != operator_id){
        var conversation = $('#chatbox_'+newchat_data.chat_uid+' .conversation');
        if(data.message_type=='activity'){
          conversation.append('<li>      <div class="message-activity">' + data.message + '</div>      <div class="timestamp pull-right timestamp-refresh" timestamp="' + Math.round(+new Date()).toString() + '">Just Now</div>      <div class="person">' + newchat_data.visitor_name + '</div></li>');
        }else{
          conversation.append('<li>      <div class="message">' + data.message + '</div>      <div class="timestamp pull-right timestamp-refresh" timestamp="' + Math.round(+new Date()).toString() + '">Just Now</div>      <div class="person">' + newchat_data.visitor_name + '</div></li>');
        }
        conversation.scrollTop(conversation[0].scrollHeight);

        if(active_chat != newchat_data.chat_uid){
          var element = $('#session_' + newchat_data.chat_uid + ' .newmessage');
          element.show();
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
  });

  $scope.switchChat = function (id) {
    var conversation = $('#chatbox_'+id+' .conversation');
    $('.chatbox').hide();
    $('#chatbox_' + id).show();
    $('#activesessions li').removeClass('activechat');
    $('#session_' + id).addClass('activechat');
    $('#session_' + id + ' .newmessage').hide();
    active_chat = id;
    conversation.scrollTop(conversation[0].scrollHeight);
  };

  $scope.postMessage = function (id) {
    var message = $('#chatbox_' + id + ' input').val();
    $('#chatbox_' + id + ' input').val('');
    var conversation = $('#chatbox_' + id + ' .conversation');

    var post_data = {
      user_uid: operator_id,
      message_type: 'user',
      message: message
    };
    $http({method: 'POST', url: '/api/chats/'+id+'/messages', data: post_data}).
      success(function (data, status, headers, config) {
        conversation.append('<li>      <div class="message text-right">' + message + '</div>      <div class="timestamp pull-right timestamp-refresh" timestamp="' + Math.round(+new Date()).toString() + '">Just Now</div>      <div class="person">You</div></li>');
        conversation.scrollTop(conversation[0].scrollHeight);
      }).error(function (data, status, headers, config) {

      });
  };

  $scope.endChat = function (id) {
    var index = _.findIndex($scope.active_sessions, function(session) {
      return session.chat_uid == id;
    });
    $scope.active_sessions.splice(index, 1);
    pusher.unsubscribe('chat_'+id);
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
});
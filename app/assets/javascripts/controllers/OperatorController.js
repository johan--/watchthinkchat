'use strict';

angular.module('chatApp').controller('OperatorController', function ($scope, $rootScope, $location) {
  var operator_id = $location.search()['o'];
  $location.search('o', null);

  $scope.operator_chat_url = "http://www.watchthinkchat.com/c" + $location.$$path + "?o=" + operator_id;
  $scope.active_sessions=[];

  var pusher = new Pusher('249ce47158b276f4d32b');
  var channel_operator = pusher.subscribe('operator_' + operator_id);
  channel_operator.bind('event', function (data) {
    console.log(data);
  });

  $scope.switchChat = function (id) {
    $('.chatbox').hide();
    $('#chatbox_' + id).show();
    $('#activesessions li').removeClass('activechat');
    $('#session_' + id).addClass('activechat');
    $('#session_' + id + ' .newmessage').hide();
  };

  $scope.postMessage = function (id) {
    var message = $('#' + id + ' input').val();
    var conversation = $('#' + id + ' .conversation');
    conversation.append('<li>      <div class="message text-right">' + message + '</div>      <div class="timestamp pull-right" timestamp="' + Math.round(+new Date()).toString() + '">Just Now</div>      <div class="person">You</div></li>');

    $('#' + id + ' input').val('');

    conversation.scrollTop(conversation[0].scrollHeight);
  };

  var createNewChat = function (chat_uid, visitor_uid, visitor_name) {

  };

  $scope.active_sessions.push({
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
  });
  $scope.active_sessions.push({
    chat_uid: '265gf9sdg43',
    visitor_uid: '03',
    visitor_name: 'Visitor #3',
    visitor_profile: 'http://upload.wikimedia.org/wikipedia/commons/4/49/Gnome-Wikipedia-user-female.png'
  });

});
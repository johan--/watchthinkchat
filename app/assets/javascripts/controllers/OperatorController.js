'use strict';

angular.module('chatApp').controller('OperatorController', function ($scope, $rootScope, $location) {
  var operator_id=$location.search()['o'];
  $location.search('o', null);
  console.log(operator_id);

  var pusher = new Pusher('249ce47158b276f4d32b');
  var channel_operator = pusher.subscribe('operator_'+operator_id);
  channel_operator.bind('event', function (data) {
    console.log(data);
  });

  $scope.switchChat = function (id) {
    $('.chatbox').hide();
    $('#chatbox_'+id).show();
    $('#activesessions li').removeClass('activechat');
    $('#session_'+id).addClass('activechat');
    $('#session_'+id+' .newmessage').hide();
  }

  $scope.postMessage = function (id) {
    var unixtime = Math.round(+new Date() / 1000);
    var message = $('#'+id+' input').val();
    var conversation    = $('#'+id+' .conversation');
    conversation.append('<li>      <div class="message text-right">' + message + '</div>      <div class="timestamp pull-right" timestamp="' + unixtime.toString() + '">Just Now</div>      <div class="person">You</div></li>');

    $('#'+id+' input').val('');

    conversation.scrollTop(conversation[0].scrollHeight);
  }
});
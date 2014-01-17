'use strict';

angular.module('chatApp').controller('ChatController', function ($scope, $rootScope, $route, $http, $cookies, $location, $filter) {
  var campaign_data;
  var visitor_data={};
  var chat_data={};
  var operator_data={
    uid: $location.search()['o'] || ''
  };
  var video_completed=false;
  $scope.followup_buttons=[];

  $http({method: 'GET', url: '/api/campaigns/' + $route.current.params.campaignId}).
    success(function (data, status, headers, config) {
      campaign_data = data;
      $scope.campaign_data = campaign_data;
      console.log(campaign_data);

      if (campaign_data.type === 'youtube') {
        var player;

        var tag = document.createElement('script');
        var title = document.title;
        tag.src = "//www.youtube.com/iframe_api";
        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

        window.onYouTubeIframeAPIReady = function () {
          player = new YT.Player('player', {
            height: '390',
            width: '640',
            videoId: campaign_data.video_id,
            playerVars: {
              autoplay: 0,
              modestbranding: 1,
              rel: 0,
              showinfo: 0,
              iv_load_policy: 3,
              html5: 1
            },
            events: {
              'onStateChange': onPlayerStateChange
            }
          });
          $('.box, #chat').addClass('paused');
        };
      }

      $scope.followup_buttons.push({
        text: 'No',
        action: 'url',
        value: 'http://cru.org'
      });
      $scope.followup_buttons.push({
        text: 'I follow another religion',
        action: 'chat',
        value: ''
      });
      $scope.followup_buttons.push({
        text: 'I am not sure',
        action: 'chat',
        value: ''
      });
      $scope.followup_buttons.push({
        text: 'I want to start',
        action: 'chat',
        value: ''
      });
      $scope.followup_buttons.push({
        text: 'I am trying',
        action: 'chat',
        value: ''
      });
      $scope.followup_buttons.push({
        text: 'I am following you',
        action: 'chat',
        value: ''
      });
    }).error(function (data, status, headers, config) {

    });

  if (!$cookies.gchat_visitor_id) {
    $http({method: 'POST', url: '/api/visitors'}).
      success(function (data, status, headers, config) {
        visitor_data = data;
        console.log('================ New Visitor Created: ' + data.uid);
        $cookies.gchat_visitor_id = visitor_data.uid;
      }).error(function (data, status, headers, config) {

      });
  } else {
    visitor_data.uid = $cookies.gchat_visitor_id;
  }
  console.log('operator: '+operator_data.uid,'visitor: '+visitor_data.uid);

  $scope.postMessage = function () {
    $('.conversation').append('<li>      <div class="message text-right">' + $scope.chatMessage + '</div>      <div class="timestamp pull-right timestamp-refresh" timestamp="' + Math.round(+new Date()).toString() + '">Just Now</div>      <div class="person">You</div></li>');
    $scope.chatMessage = '';
    $('.conversation').scrollTop($('.conversation')[0].scrollHeight);
  }

  $scope.startChat = function(initialMsg){
    if(!video_completed){
      $('#finishVideo').fadeIn().delay(3000).fadeOut();
      return;
    }
    var data = {
      campaign_uid: campaign_data.uid,
      visitor_uid: visitor_data.uid,
      operator_uid: operator_data.uid
    };

    $http({method: 'POST', url: '/api/chats', data: data}).
      success(function (data, status, headers, config) {
        chat_data = data;
        operator_data = data.operator;
        console.log(chat_data);
        console.log('================ New Chat Created: ' + data.chat_uid);

        $('#chatbox').fadeIn();
        $('.after-chat-buttons').fadeOut();

        $('.conversation').append('<li>      <div class="message">You are now chatting with ' + operator_data.name + '</div>      <div class="timestamp pull-right timestamp-refresh" timestamp="' + Math.round(+new Date()).toString() + '">Just Now</div>      <div class="person">-</div></li>');
        console.log('Inital message: '+initialMsg);

        var pusher = new Pusher('249ce47158b276f4d32b');
        var channel_chat = pusher.subscribe('chat_'+chat_data.chat_uid);
        channel_chat.bind('event', function (data) {
          $('.conversation').append('<li>      <div class="message">' + data.message + '</div>      <div class="timestamp pull-right timestamp-refresh" timestamp="' + Math.round(+new Date()).toString() + '">Just Now</div>      <div class="person">' + data.user + '</div></li>');
        });
      }).error(function (data, status, headers, config) {
        alert('Error: ' + (data.error || 'Cannot create new chat.'));
      });
  };

  var launchWebPage = function(url){
    $('#player').hide();
    $('#webpage').show();
    $('#webpage').attr('src',url);
  };

  $scope.buttonClick = function(button){
    $('.after-chat-buttons').fadeOut();
    console.log(button);
    if(button.action == 'url'){
      launchWebPage('http://cru.org');
    }else{
      $scope.startChat(button.text);
    }
  };

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

      //$(this).html(NiceTime(currentval)+'<span>'+currentval+'</span>');
    });
  }, 5000);

  var onPlayerStateChange = function (evt) {
    switch (evt.data) {
      case YT.PlayerState.PLAYING:
        break;
      case YT.PlayerState.ENDED:
        if(!video_completed){
          $('.after-chat-buttons').fadeIn(2000);
        }
        video_completed=true;
        break;
      case YT.PlayerState.PAUSED:
        break;
    }
  };

});
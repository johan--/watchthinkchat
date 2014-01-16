'use strict';

angular.module('chatApp').controller('ChatController', function ($scope, $rootScope, $route, $http, $cookies, $location) {
  var campaign_data;
  var visitor_data={};
  var chat_data={};
  var operator_data={
    uid: $location.search()['o']
  };

  console.log('operator: '+operator_data.uid);
  $http({method: 'GET', url: '/api/campaigns/' + $route.current.params.videoId}).
    success(function (data, status, headers, config) {
      campaign_data = data;
      $scope.campaign_data = campaign_data;

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
              autoplay: 1,
              modestbranding: 1,
              rel: 0,
              showinfo: 0,
              iv_load_policy: 3,
              html5: 1
            },
            events: {
              //'onStateChange': onPlayerStateChange
            }
          });
          $('.box, #chat').addClass('paused');
          $('#chatbox').fadeIn();
        };
      }
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

  $scope.postMessage = function () {
    var unixtime = Math.round(+new Date() / 1000);
    $('.conversation').append('<li>      <div class="message text-right">' + $scope.chatMessage + '</div>      <div class="timestamp pull-right" timestamp="' + unixtime.toString() + '">Just Now</div>      <div class="person">You</div></li>');
    $scope.chatMessage = '';
  }

  $scope.startChat = function(){
    var data = {
      campaign_permalink: campaign_data.permalink,
      visitor_uid: visitor_data.uid,
      operator_uid: operator_data.uid
    };
    console.log(data);

    $http({method: 'POST', url: '/api/chats', data: data}).
      success(function (data, status, headers, config) {
        console.log(data);
        console.log('================ New Chat Created: ' + data.chat_uid);
      }).error(function (data, status, headers, config) {

      });

    var pusher = new Pusher('249ce47158b276f4d32b');
    var channel = pusher.subscribe('test_chat');
    channel.bind('event', function (data) {
      var unixtime = Math.round(+new Date() / 1000);
      $('.conversation').append('<li>      <div class="message">' + data.message + '</div>      <div class="timestamp pull-right" timestamp="' + unixtime.toString() + '">Just Now</div>      <div class="person">' + data.user + '</div></li>');
    });

  }

  var timeUpdate = setInterval(function () {
    $('.conversation .timestamp').each(function (i) {
      var origtime = parseInt($(this).attr('timestamp'));
      var unixtime = Math.round(+new Date() / 1000);

      if ((unixtime - origtime) < 10) {
        $(this).html('Just Now');
      } else if ((unixtime - origtime) < 60) {
        $(this).html('about ' + (unixtime - origtime).toString() + ' seconds ago');
      } else if ((unixtime - origtime) < 120) {
        $(this).html('about 1 min ago');
      } else {
        $(this).html('about ' + Math.floor(((unixtime - origtime) / 60)).toString() + ' mins ago');
      }

      //$(this).html(NiceTime(currentval)+'<span>'+currentval+'</span>');
    });
  }, 5000);

  //{"message":"Thanks!", "user":"Steve"}

});
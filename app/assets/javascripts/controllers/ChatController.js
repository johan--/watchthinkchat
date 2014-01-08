'use strict';

angular.module('chatApp').controller('ChatController', function ($scope, $rootScope, $route) {
  //alert($route.current.params.videoId);

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
      videoId: 'KGlx11BxF24',
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


  $scope.postMessage = function(){
    var unixtime = Math.round(+new Date()/1000);
    $('.conversation').append('<li>      <div class="message text-right">'+$scope.chatMessage+'</div>      <div class="timestamp pull-right" timestamp="'+unixtime.toString()+'">Just Now</div>      <div class="person">You</div></li>');
    $scope.chatMessage='';
  }

  var pusher = new Pusher('249ce47158b276f4d32b');
  var channel = pusher.subscribe('test_chat');
  channel.bind('event', function(data) {
    var unixtime = Math.round(+new Date()/1000);
    $('.conversation').append('<li>      <div class="message">'+data.message+'</div>      <div class="timestamp pull-right" timestamp="'+unixtime.toString()+'">Just Now</div>      <div class="person">'+data.user+'</div></li>');


  });

  var timeUpdate = setInterval(function(){
    $('.conversation .timestamp').each(function(i){
      var origtime=parseInt($(this).attr('timestamp'));
      var unixtime = Math.round(+new Date()/1000);

      if((unixtime - origtime) < 10){
        $(this).html('Just Now');
      }else if((unixtime - origtime) < 60){
        $(this).html('about '+(unixtime - origtime).toString()+' seconds ago');
      }else if((unixtime - origtime) < 120){
        $(this).html('about 1 min ago');
      }else{
        $(this).html('about '+Math.floor(((unixtime - origtime)/60)).toString()+' mins ago');
      }

      //$(this).html(NiceTime(currentval)+'<span>'+currentval+'</span>');
    });
  },5000);

  //{"message":"Thanks!", "user":"Steve"}

});
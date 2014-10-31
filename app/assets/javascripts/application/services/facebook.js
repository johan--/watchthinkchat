angular.module('chatApp').service('facebook', function () {
  this.status = function () {
    FB.getLoginStatus(function(response) {
    });
  };

  this.login = function(){
    FB.login(function(response) {
      if (response.authResponse) {
        console.log('Welcome!  Fetching your information.... ');
        FB.api('/me', function(response) {
          console.log('Good to see you, ' + response.name + '.');
        });
      } else {
        console.log('User cancelled login or did not fully authorize.');
      }
    });
  };

  this.getFriends = function(){
    FB.api(
        "/me/friends",
        function (response) {
          if (response && !response.error) {
            console.log(response);
          }else{
            console.log(response.error);
          }
        }
    );
  };
});

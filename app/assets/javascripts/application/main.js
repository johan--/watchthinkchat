angular.module('chatApp', ['ngRoute', 'youtube-embed'])
    .config(function ($routeProvider) {
      $routeProvider.when('/', {
        templateUrl: '/templates/video.html',
        controller: 'VideoController'
      }).otherwise({
        redirectTo: '/'
      });
    }).run(function ($rootScope, $window) {
        $rootScope.campaign = $window.campaign;
    }).config(["$httpProvider", function(provider) {
      //provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    }]);

angular.module('chatApp', ['ngRoute', 'youtube-embed'])
    .config(function ($routeProvider) {
      $routeProvider.when('/', {
        templateUrl: '/templates/video.html',
        controller: 'VideoController'
      }).when('/q/:questionId', {
        templateUrl: '/templates/question.html',
        controller: 'QuestionController',
        resolve: {
          question: ['$rootScope', '$route', function ($rootScope, $route) {
            return _.find($rootScope.campaign.engagement_player.questions, { 'code': $route.current.params.questionId });
          }],
          nextQuestion: ['$rootScope', '$route', function ($rootScope, $route) {
            var questionIndex = _.findIndex($rootScope.campaign.engagement_player.questions, { 'code': $route.current.params.questionId });
            return $rootScope.campaign.engagement_player.questions[questionIndex + 1];
          }]
        }
      }).when('/jumpTo/:jumpId', {
        template: '',
        controller: 'JumpToController',
        resolve: {
          option: ['$rootScope', '$route', function ($rootScope, $route) {
            return _.find(_.flatten($rootScope.campaign.engagement_player.questions, 'options'), { 'code': $route.current.params.jumpId });
          }]
        }
      }).when('/complete', {
        templateUrl: '/templates/complete.html'
      }).otherwise({
        redirectTo: '/'
      });
    }).run(function ($rootScope, $window) {
        $rootScope.campaign = $window.campaign;
        $rootScope.navigateBack = function(){
          $window.history.back();
        };
    }).config(["$httpProvider", function(provider) {
      //provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    }]);

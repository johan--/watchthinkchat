angular.module('chatApp', ['ngRoute', 'ui.bootstrap', 'youtube-embed'])
    .config(function ($routeProvider) {
      $routeProvider.when('/', {
        template: '',
        controller: 'MainController'
      }).when('/player', {
        templateUrl: '/templates/video.html',
        controller: 'VideoController'
      }).when('/q/:questionId', {
        templateUrl: '/templates/question.html',
        controller: 'QuestionController',
        resolve: {
          question: ['$rootScope', '$route', function ($rootScope, $route) {
            return _.find($rootScope.campaign.survey.questions, { 'code': $route.current.params.questionId });
          }],
          nextQuestion: ['$rootScope', '$route', function ($rootScope, $route) {
            var questionIndex = _.findIndex($rootScope.campaign.survey.questions, { 'code': $route.current.params.questionId });
            return $rootScope.campaign.survey.questions[questionIndex + 1];
          }]
        }
      }).when('/jumpTo/:jumpId', {
        template: '',
        controller: 'JumpToController',
        resolve: {
          option: ['$rootScope', '$route', function ($rootScope, $route) {
            return _.find(_.flatten($rootScope.campaign.survey.questions, 'options'), { 'code': $route.current.params.jumpId });
          }]
        }
      }).when('/complete', {
        templateUrl: '/templates/complete.html',
        controller: 'CompleteController'
      }).when('/pair', {
        templateUrl: '/templates/share.html',
        controller: 'PairController'
      }).otherwise({
        redirectTo: '/'
      });
    }).run(function ($rootScope, $window, api) {
      $rootScope.campaign = $window.campaign;

      $rootScope.back = function(){
        $window.history.back();
      };

      $rootScope.$on("$routeChangeStart", function(event, next, current) {
        var nextController = next.$$route.controller;
        var currentController = '';
        if(angular.isDefined(current)){ currentController = current.$$route.controller; }

        if(nextController === currentController){
          return;
        }

        if(getResourceInfo(currentController)){
          api.interaction({
            interaction: {
              resource_id: getResourceInfo(currentController).id,
              resource_type: getResourceInfo(currentController).resource_type,
              action: 'finish'
            }
          });
        }

        if(getResourceInfo(nextController)){
          api.interaction({
            interaction: {
              resource_id: getResourceInfo(nextController).id,
              resource_type: getResourceInfo(nextController).resource_type,
              action: 'start'
            }
          });
        }
      });

      var getResourceInfo = function(controller){
        switch(controller) {
          case 'VideoController':
            return $rootScope.campaign.engagement_player;
          case 'QuestionController':
            return $rootScope.campaign.survey;
          case 'ShareController':
            return $rootScope.campaign.share;
          case 'PairController':
            return $rootScope.campaign.guided_pair;
          default:
            return null;
        }
      };
    }).config(["$httpProvider", function(provider) {
      //provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    }]);

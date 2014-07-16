angular.module('chatApp', ['ngRoute'])
  .config(function ($routeProvider, $locationProvider) {
    $locationProvider.html5Mode(true);
    $routeProvider.when('/', {
      templateUrl: '/templates/dashboard.html',
      controller: 'DashboardController as ctrl'
    }).when('/tour', {
      templateUrl: '/templates/tour.html',
      controller: 'TourController as ctrl'
    }).when('/features', {
      templateUrl: '/templates/features.html',
      controller: 'FeaturesController as ctrl'
    }).when('/c/:campaignId', {
      templateUrl: '/templates/chat.html',
      controller: 'ChatController as ctrl',
      resolve: {
        campaign_data: ['$route', 'campaignResolve', function ($route, campaignResolve) {
          return campaignResolve.getCampaignInfo($route.current.params.campaignId);
        }]
      }
    }).when('/challenge/friend', {
      templateUrl: '/templates/growthchallenge_friend.html',
      controller: 'ChallengeFriendController as ctrl',
      resolve: {
        campaign_data: ['$route', 'campaignResolve', function ($route, campaignResolve) {
          return campaignResolve.getCampaignInfo($route.current.params.c);
        }]
      }
    }).when('/challenge/resources', {
        templateUrl: '/templates/mentor_resources.html'
        //controller: 'ChallengeController as ctrl'
    }).when('/privacypolicy', {
      templateUrl: '/templates/privacy_policy_full.html'
    }).when('/operator/:operatorId', {
      templateUrl: '/templates/operator.html',
      controller: 'OperatorController as ctrl'
    }).when('/manage', {
      templateUrl: '/templates/manage/index.html',
      controller: 'ManageController as ctrl'
    }).when('/manage/new', {
      templateUrl: '/templates/manage/new.html',
      controller: 'ManageEditController as ctrl'
    }).when('/manage/:campaignId', {
      templateUrl: '/templates/manage/edit.html',
      controller: 'ManageEditController as ctrl'
    }).otherwise({
      redirectTo: '/'
    });
  }).run(function ($rootScope) {
    $rootScope.YouTubeApiLoaded = false;
  }).config(["$httpProvider", function(provider) {
    provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
  }]);

var validateEmail = function(email) {
  var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return re.test(email);
};
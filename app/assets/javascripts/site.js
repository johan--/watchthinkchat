'use strict';
/*
angular.module("chatApp", ["ngRoute"]).config(($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode true
  $routeProvider.when("/",
    templateUrl: "/templates/dashboard.html"
  controller: "DashboardController as ctrl"
  ).when("/tour",
    templateUrl: "/templates/tour.html"
  controller: "TourController as ctrl"
  ).when("/features",
    templateUrl: "/templates/features.html"
  controller: "FeaturesController as ctrl"
  ).otherwise redirectTo: "/"
).run ($rootScope) ->
  $rootScope.YouTubeApiLoaded = false
*/

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
      controller: 'ChatController as ctrl'
    }).when('/c2/:campaignId', {
      templateUrl: '/templates/chat_redesign.html',
      controller: 'ChatController as ctrl'
    }).when('/challenge', {
      template: '<div class="visitor_chat" style="position: relative;"><growth-challenge step="2"></growth-challenge></div>',
      controller: 'ChallengeController as ctrl'
    }).when('/challenge/friend', {
      templateUrl: '/templates/growthchallenge_friend.html',
      controller: 'ChallengeFriendController as ctrl'
    }).when('/privacypolicy', {
      templateUrl: '/templates/privacy_policy_full.html'
    }).when('/operator/:operatorId', {
      templateUrl: '/templates/operator.html',
      controller: 'OperatorController as ctrl'
    }).otherwise({
      redirectTo: '/'
    });
  }).run(function ($rootScope) {
    $rootScope.YouTubeApiLoaded = false;
  }).config(["$httpProvider", function(provider) {
    provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
  }]);
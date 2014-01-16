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

angular.module('chatApp', ['ngRoute', 'ngCookies'])
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
      }).when('/operator', {
        templateUrl: '/templates/operator.html',
        controller: 'OperatorController as ctrl'
      }).otherwise({
        templateUrl: '/templates/operator.html',
        controller: 'OperatorController as ctrl',
        reloadOnSearch: false
      });
  }).run(function ($rootScope) {
    $rootScope.YouTubeApiLoaded = false;
  });
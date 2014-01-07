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
    $locationProvider.html5Mode(false);
    $routeProvider.when('/', {
      templateUrl: '/templates/dashboard.html',
      controller: 'DashboardController as ctrl'
    }).when('/tour', {
        templateUrl: '/templates/tour.html',
        controller: 'TourController as ctrl'
      }).when('/features', {
        templateUrl: '/templates/features.html',
        controller: 'FeaturesController as ctrl'
      }).when('/u/:videoId', {
        templateUrl: '/templates/chat.html',
        controller: 'ChatController as ctrl'
      }).otherwise({ redirectTo: '/' });
  }).run(function ($rootScope) {
    $rootScope.YouTubeApiLoaded = false;
  });
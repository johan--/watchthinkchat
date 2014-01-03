'use strict';
/*chatApp = angular.module('chatApp', ['ngRoute','ngResource'])
.config ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode true
  $routeProvider.when '/', templateUrl: '/templates/dashboard.html', controller: 'DashboardController as ctrl'
  $routeProvider.when '/tour', templateUrl: '/templates/tour.html', controller: 'TourController as ctrl'
  $routeProvider.when '/features', templateUrl: '/templates/features.html', controller: 'FeaturesController as ctrl'
  $routeProvider.otherwise redirectTo: '/'
.run($rootScope) ->
  alert 'hi'*/


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
      }).otherwise({ redirectTo: '/' });
  }).run(function ($rootScope) {
    $rootScope.YouTubeApiLoaded = false;
  });
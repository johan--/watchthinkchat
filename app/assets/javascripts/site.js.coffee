chatApp = angular.module('chatApp', ['ngRoute'])

chatApp.config ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode true
  $routeProvider.when '/', templateUrl: '/templates/dashboard.html', controller: 'DashboardController as ctrl'
  $routeProvider.when '/tour', templateUrl: '/templates/tour.html', controller: 'TourController as ctrl'
  $routeProvider.otherwise redirectTo: '/'


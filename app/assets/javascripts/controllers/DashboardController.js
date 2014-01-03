/*
angular.module('chatApp').controller 'DashboardController',
  class DashboardController
    constructor: ($routeParams) ->

    addTodo: ->
      @list.push
        text: @input
        done: false
      @input = ''

*/
'use strict';

angular.module('chatApp').controller('DashboardController', function ($scope, $rootScope) {
  try {
    $rootScope.bt.end();
  }
  catch (err) {
  }
});
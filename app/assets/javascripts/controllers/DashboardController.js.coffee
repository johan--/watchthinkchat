angular.module('chatApp').controller 'DashboardController',
  class DashboardController
    constructor: ($routeParams) ->

    addTodo: ->
      @list.push
        text: @input
        done: false
      @input = ''

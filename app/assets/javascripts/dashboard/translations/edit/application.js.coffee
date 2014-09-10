#= require bootstrap
#= require jquery
#= require jquery_ujs
#= require jquery-ui/sortable
#= require angular
#= require angular-resource
#= require angular-ui
#= require angular-ui-bootstrap
#= require_self
#= require_tree

$(document).on 'page:load', ->
  $('[ng-app]').each ->
    module = $(this).attr('ng-app')
    angular.bootstrap(this, [module])

window.app = angular.module 'translations_edit', ['ngResource','ui.bootstrap', 'ui']
app.config ($httpProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").
    attr("content")
  $httpProvider.defaults.headers.
    common['X-CSRF-TOKEN'] = authToken
  $httpProvider.defaults.headers.
    common['Content-Type'] = 'application/json;charset=utf-8'
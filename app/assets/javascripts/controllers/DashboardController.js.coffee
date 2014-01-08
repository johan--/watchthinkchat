angular.module("chatApp").controller "DashboardController", ($scope, $rootScope) ->
  try
    $rootScope.bt.end()
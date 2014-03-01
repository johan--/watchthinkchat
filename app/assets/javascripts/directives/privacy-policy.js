angular.module('chatApp')
  .directive('privacyPolicy', function () {
    return {
      restrict: 'E',
      templateUrl: '/templates/privacy_policy.html',
      link: function (scope, element, attrs){
      },
      controller: function ($scope, $http, $route) {
        $('#privacy-policy').modal({backdrop: true, show: false});
      }
    };
  });
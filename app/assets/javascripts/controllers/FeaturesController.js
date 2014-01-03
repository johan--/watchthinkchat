/*angular.module('chatApp').controller 'FeaturesController',
  class FeaturesController
    constructor: () ->
      @showFooter = true*/

'use strict';

angular.module('chatApp').controller('FeaturesController', function ($scope, $rootScope) {
  try {
    $rootScope.bt.end();
  }
  catch (err) {
  }
});
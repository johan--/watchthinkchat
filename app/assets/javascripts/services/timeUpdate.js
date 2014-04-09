angular.module('chatApp')
    .service('timeUpdate', function ($filter) {
        var timeUpdate = setInterval(function () {
            $('.timestamp-refresh').each(function (i) {
                var origtime = parseInt($(this).attr('timestamp'));
                var unixtime = Math.round(+new Date());

                if ((unixtime - origtime) < 10000) {
                    $(this).html('Just Now');
                } else if ((unixtime - origtime) < 60000) {
                    $(this).html('about ' + Math.round((unixtime - origtime)/1000).toString() + ' seconds ago');
                } else if ((unixtime - origtime) < 120000) {
                    $(this).html('about 1 min ago');
                } else if ((unixtime - origtime) < 240000) {
                    $(this).html('about ' + Math.floor(((unixtime - origtime) / 60000)).toString() + ' mins ago');
                }else{
                    $(this).html($filter('date')(origtime, 'shortTime'));
                    $(this).removeClass('timestamp-refresh');
                }
            });
        }, 5000);
    });

angular.module('chatApp')
  .service('visitorInfo', function () {
    this.getBrowser = function(){
      var ua= navigator.userAgent, tem,
        M= ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*([\d\.]+)/i) || [];
      if(/trident/i.test(M[1])){
        tem=  /\brv[ :]+(\d+(\.\d+)?)/g.exec(ua) || [];
        return 'IE '+(tem[1] || '');
      }
      M= M[2]? [M[1], M[2]]:[navigator.appName, navigator.appVersion, '-?'];
      if((tem= ua.match(/version\/([\.\d]+)/i))!= null) M[2]= tem[1];
      return M.join(' ');
    };

    this.isMobile = function() {
      var mobileBrowser = 'No';
      if(navigator.userAgent.match(/Android/i) !== null){
        mobileBrowser = 'Yes, Android';
      }
      if(navigator.userAgent.match(/BlackBerry/i) !== null){
        mobileBrowser = 'Yes, BlackBerry';
      }
      if(navigator.userAgent.match(/iPhone/i) !== null){
        mobileBrowser = 'Yes, iPhone';
      }
      if(navigator.userAgent.match(/iPad/i) !== null){
        mobileBrowser = 'Yes, iPad';
      }
      if(navigator.userAgent.match(/iPod/i) !== null){
        mobileBrowser = 'Yes, iPod';
      }
      if(navigator.userAgent.match(/IEMobile/i) !== null){
        mobileBrowser = 'Yes, Windows Phone';
      }
      return mobileBrowser;
    };


    this.getOS = function(){
      var OSName="Unknown OS";
      if (navigator.appVersion.indexOf("Win")!=-1) OSName="Windows";
      if (navigator.appVersion.indexOf("Mac")!=-1) OSName="MacOS";
      if (navigator.appVersion.indexOf("X11")!=-1) OSName="UNIX";
      if (navigator.appVersion.indexOf("Linux")!=-1) OSName="Linux";
      return OSName;
    };
  });
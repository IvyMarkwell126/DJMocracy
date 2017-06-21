//window.fbAsyncInit = function() {
//  FB.init({
//    appId:  "101362207154011",
//    cookie: true
//  });
//  $('#sign_in').click(function(e) {
//    e.preventDefault();
//    return FB.login(function(response) {
//      if (response.authResponse) {
//        return window.location = '/auth/facebook/callback?' + $.param({signed_request: response.authResponse.signedRequest });
//      }
//    });
//  });
//  return $('#sign_out').click(function(e) {
//    FB.getLoginStatus(function(response) {
//      if (response.authResponse) {
//        return FB.logout();
//      }
//    });
//    return true;
//  });
//};
//


//get this to run when the page is changed
//$(document).ready(checkLogin);
$(document).on('turbolinks:load', function() {
    console.log('turbolinks load function was called'); 
    jQuery(function() {
        $('body').prepend('<div id="fb-root"></div>');
        return $.ajax({
            url: window.location.protocol + "//connect.facebook.net/en_US/all.js",
            dataType: 'script',
            cache: true
        });
    });

    window.fbAsyncInit = function() {
        FB.init({
            appId            : '101362207154011',
            cookie: true, 
            xfbml            : true,
            version          : 'v2.9'
        })

    FB.getLoginStatus(function(response){
        statusChangeCallback(response);
    });

    };

    var checkLogin = function checkLoginState() {
        FB.getLoginStatus(function(response) {
            statusChangeCallback(response);
        });
    }

    function testAPI() {
        console.log('Welcome! Getting your info....');
        FB.api('/me', function(response) {
            console.log('Successful login for: ' + response.name);
            //document.getElementById('status').innerHTML = 'Thanks for logging in, ' + response.name;
            //we have gotten the response back from Facebook and can now create the user and put them in the db
            //uncomment this to hide the login button once you're logged into the application
            //$("#fb_login_button").hide();
        });
    };




    (function(d, s, id){
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) {return;}
        js = d.createElement(s); js.id = id;
        js.src = "//connect.facebook.net/en_US/sdk.js";
        fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));

  function statusChangeCallback(response) {
    console.log('statusChangeCallback');
    console.log(response);

    if(response.status === 'connected') {
        testAPI();
    } else {
        document.getElementById('status').innerHTML = 'Please log into this app.';
    }
}


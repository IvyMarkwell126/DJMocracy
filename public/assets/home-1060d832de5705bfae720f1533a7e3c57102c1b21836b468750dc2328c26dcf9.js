console.log('in home.js finally');

var bindFacebookEvents, initializeFacebookSDK, loadFacebookSDK, restoreFacebookRoot, saveFacebookRoot;

$(function() {
      loadFacebookSDK();
      if (!window.fbEventsBound) {
              return bindFacebookEvents();
            }
});

bindFacebookEvents = function() {
      $(document).on('page:fetch', saveFacebookRoot).on('page:change', restoreFacebookRoot).on('page:load', function() {
              return typeof FB !== "undefined" && FB !== null ? FB.XFBML.parse() : void 0;
            });
      return this.fbEventsBound = true;
};

saveFacebookRoot = function() {
      if ($('#fb-root').length) {
              return this.fbRoot = $('#fb-root').detach();
            }
};

restoreFacebookRoot = function() {
      if (this.fbRoot != null) {
              if ($('#fb-root').length) {
                        return $('#fb-root').replaceWith(this.fbRoot);
                      } else {
                        return $('body').append(this.fbRoot);
                      }
            }
};

loadFacebookSDK = function() {
      window.fbAsyncInit = initializeFacebookSDK;
      return $.getScript("//connect.facebook.net/en_US/sdk.js");
};

function checkLoginState() {
    FB.getLoginStatus(function(response) {
        statusChangeCallback(response);
    });
}

function statusChangeCallback(response) {

    if(response.status === 'connected'){
        //get the user id
        var id = response['authResponse']['userID'];

        //Make a request to Facebook to get all of the users information
        user_path = '/' + id
        FB.api(user_path, function(res) {
            var user_name = res['name']

            //send a POST request to create a user with id and name as
            //params
            var payload = JSON.stringify({"user": {"name": user_name,"fb_id": id}});
            //console.log(payload)
            
            //Possible solution to stop the infinite link
            //set a user variable saying that the user is logged in
            //be able to set it on login, check it elsewise, and set it false on logout

            $.ajax({
                type: 'POST',
                url: '/users',
                data: payload,
                contentType: 'application/json',
                dataType: 'json',
                success: function(data) {
                    console.log('We have success!!');
                    //window.location.pathname = data;
                    console.log(data['url']);
                   // window.open(data['url'], '_self');
                },
                error: function(data) {
                    console.log('there is an ajax error');
                    console.log(data);}
            });
        });
    } else {
        console.log('Nobody is currently logged in');
    }
}


function initialLogin(response){
    console.log('in initial login');
    if(response.status === 'connected'){
        var id = response['authResponse']['userID'];

        //Make a request to Facebook to get all of the users information
        user_path = '/' + id
        FB.api(user_path, function(res) {
            var user_name = res['name']

            //send a POST request to create a user with id and name as
            //params
            var payload = JSON.stringify({"user": {"name": user_name,"fb_id": id}});
            //console.log(payload)

            //Possible solution to stop the infinite link
            //set a user variable saying that the user is logged in
            //be able to set it on login, check it elsewise, and set it false on logout

            $.ajax({
                type: 'POST',
                url: '/users',
                data: payload,
                contentType: 'application/json',
                dataType: 'json',
                success: function(data) {
                    console.log('We have success!!');
                    //window.location.pathname = data;
                    console.log(data['url']);
                    //window.open(data['url'], '_self');
                },
                error: function(data) {
                    console.log('there is an ajax error');
                    console.log(data);}
            });
        });
    } else {
        console.log('Nobody is currently logged in');
    }
}

initializeFacebookSDK = function() {
    console.log('init facebook in home js');
    FB.init({
        appId: '101362207154011',
        status: true,
        cookie: true,
        xfbml: true,
        version: 'v2.7'
    });
    FB.getLoginStatus(function(response) {
        initialLogin(response);
    });
};

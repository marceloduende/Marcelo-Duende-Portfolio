
function login(){
	getFlashMovie("myFlash").displayStatus("login");
	
}

function logout(){
	getFlashMovie("myFlash").displayStatus("logout");
}

function goLogin(){
	FB.login(function(response) {
	  if (response.session) {
		    if (response.perms) {
		    	getFlashMovie("myFlash").displayStatus("login");
		    } else {
			    
			}
	   } else {
		   
	   }
	}, {perms:'publish_stream'});
}

function getStatus(){
	FB.getLoginStatus(function(response) {
		
        if (response.session) {
				getFlashMovie("myFlash").displayStatus("login");
        }else{
		   		getFlashMovie("myFlash").displayStatus("logout");
		   }
   });
}

function goLogout(){
	FB.logout(function(response) {
		getFlashMovie("myFlash").displayStatus("logout");
	});
}

function getData(){
	FB.api('/me', function(response) {
		getFlashMovie("myFlash").updateData(response.id);
	});
}

function getFlashMovie(movieName) {
	if (navigator.appName.indexOf("Microsoft") != -1) {
        return window[movieName];
    } else {
        return document[movieName];
    }
}
function feedback(){
	document.getElementById('forecho').appendChild('<span>a feedback</span>');
}

function notready(){
	document.getElementById('forecho').appendChild('<span>not ready</span>');
}


function queryFriends()
{
  FB.api('/me', function(response) {
        var query = FB.Data.query('select name, uid, pic_square from user where uid IN (SELECT uid2 FROM friend WHERE uid1={0})', response.id);
        query.wait(function(rows) {
              var data = "";
              var book = new Array(); 
              for (var i = 0; i < rows.length; ++i){
                    data += rows[i].name+',';
                    book[i] = new bookInfo("foo",rows[i].name,rows[i].uid,rows[i].pic_square);
					                /*
    if (rows[i].name)
                        data += "<br />" + rows[i].uid + "<br />";
                        data += '<img src="' + rows[i].pic_square + '" alt="" />' + "<br />";
                    data += "<br />";
*/
              }
             //document.getElementById('name').innerHTML = book; 
              collectText(book);
         });
    });

}



global with sharing class CustomLoginController 
{
  global String username {get; set;}
  global String password {get; set;}
  global CustomLoginController () {
  	System.debug('Enter : ' + username + ' $$$$$$$$$$$$$$$$$$$$$ : ' + password);
  }
  
  global PageReference login() 
  {  		
  	 System.debug('Enter : ' + username + ' @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ : ' + password);
 	 return Site.login(username, password, 'CommunityHomePage');  	 
  } 
}
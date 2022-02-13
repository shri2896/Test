public class CommunityHomePage {
	public String userName{get;set;}
	public String userId{get;set;}
	public boolean chngpass{get;set;} /*Use for show change password outputpanelBlock in CommunityHomePage*/
	
	public CommunityHomePage(){
		chngpass = false;
		userName = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
		userId = UserInfo.getUserName();
	}
	public void showChangePasswordBlock(){
		chngpass = true;
	}

	public PageReference chngPassword(){
		try{
			String newPass = ApexPages.currentPage().getParameters().get('newPassword');
			String cnfrmPass = ApexPages.currentPage().getParameters().get('confirmPassword');
			String oldPass = ApexPages.currentPage().getParameters().get('oldPassword');
			System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@new pass : ' + newPass + '  cnfrmPass : ' + cnfrmPass + '  oldPass : ' + oldPass);
			if(newPass==null || newPass=='' || cnfrmPass == null || cnfrmPass == '' || oldPass == null || oldPass == ''){
				System.debug('if');
				ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Filed can not be blank...!!!'));	
				return null;
			}
			else{
				System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@new pass : ' + newPass + '  cnfrmPass : ' + cnfrmPass + '  oldPass : ' + oldPass);
				chngpass = false;
				return Site.changePassword(newPass, cnfrmPass, oldPass);			
			}
		}
		catch(Exception e){
			System.debug('catch');
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Error in changePassword : ' + e));
			return null;	
		}
	}
}
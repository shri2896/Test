@isTest
public class GoogleDriveAuthenticationTest {
     
     public static testmethod void accessTokenTest()
    {    	    
        Test.setMock(HttpCalloutMock.class, new GoogleDriveMockCallout());	
        PageReference pageRef = Page.pGoogleDriveAuthentication;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('code','4/8wDUjBlcp2cLLcDl9nmCJX_LBPowqao5i8_szg5WoD7JXCSh1TuQgtMYs99ExFQtSojLnFO-1UgxLqZrVrjJVPs');        
    	GoogleDriveAuthentication gd = new GoogleDriveAuthentication();          
		gd.DriveAuth();                     
        gd.createFolder();  
        gd.deleteFolder();
        gd.DownloadFile();
        gd.openFIle();        
        ApexPages.currentPage().getParameters().put('directoryFolderName','0');           
        gd.navigationOfFolder();
        gd.fileName='abc.txt';
        gd.fileSize='2000';       
        gd.fileType='application/octet-stream';
        gd.fileData=Blob.valueOf('e,point_longitude,line,construction,point_granularity');
        gd.uploadFile();
        ApexPages.currentPage().getParameters().put('folderId','0');        
        gd.showChildFolder();
    }
}
public class GoogleDriveControllerForCommunity
{
    public String userId{get;set;}
    public String UserName{get;set;}
    private String key='424589915414-ggfvn5ecet5nppdh1tpg4dssk4cuk2nq.apps.googleusercontent.com';
    private String secret = 'x7Tm9m17DQJ6TxEMno_QJd8N';
    private String redirectURL='https://briskminds-developer-edition.ap4.force.com/cmunity/GoogleDriveCommunity';
    private String code='';    
    private String accessToken='';
    public GoogleDriveServiceForCommunity gdService = new GoogleDriveServiceForCommunity();
    public String folderName{get;set;}
    public List<FileDetailsWrapper.FileDetail>lstOfFolder{get;set;}
    public List<FileDetailsWrapper.FileDetail>lstOfFile{get;set;}
    String folderId='root';  
    public Transient Blob data{get;set;}
    public Transient String recFileName{get;set;}
    public Transient String fileType{get;set;} 
    public List<FileDetailsWrapper.FileDetail>breadCrum{get;set;}
    private String refreshtoken='1/QS8DQYc5v4CglYMzXjFNbQCvWVllVHCOZGQEn2NSuk0';
    Community__c cmunty = new Community__c();
    public String previewLink{get;set;}

    public GoogleDriveControllerForCommunity(){                 

        breadCrum = new List<FileDetailsWrapper.FileDetail>();
        FileDetailsWrapper.FileDetail tmp = new FileDetailsWrapper.FileDetail();
        tmp.Id = 'root';
        tmp.name = 'home';
        breadCrum.add(tmp);
        lstOfFile = new List<FileDetailsWrapper.FileDetail>();              
        lstOfFolder = new List<FileDetailsWrapper.FileDetail>();                           
    }

    public PageReference getAuthCode(){    
        PageReference pg;                 
        List<Community__c> usrlst = [select userId__c from Community__c where userId__c = :UserInfo.getUserId()];        

        if(usrlst.size()>0){                    
            Community__c singleCommunityRec = [select GoogleDriveRefreshToken__c from Community__c where userId__c = :UserInfo.getUserId() Limit 1];
            if(singleCommunityRec.GoogleDriveRefreshtoken__c == null || singleCommunityRec.GoogleDriveRefreshtoken__c == ''){/*if user id is already exists and authenticated from other app inseteda of google drive than store refreshtoken, accesstoken in the object*/
                pg = gdService.getAuthURL(key, redirectURL);
                code = ApexPages.currentPage().getParameters().get('code');
                if(code!=null && code!=''){                 
                    HttpResponse response = gdService.getAccessToken(code,key, secret, redirectURL);
                    FileDetailsWrapper.googleDriveAccessTokenResponse responsewrapr = (FileDetailsWrapper.googleDriveAccessTokenResponse)JSON.deserialize(response.getBody(), FileDetailsWrapper.googleDriveAccessTokenResponse.class);                    
                    
                    Community__c insrtUserRec = new Community__c();
                    
                    insrtUserRec.userId__c = UserInfo.getUserId();
                    
                    insrtUserRec.GoogleDriveRefreshtoken__c = responsewrapr.refresh_token;
                    
                    if(insrtUserRec.GoogleDriveRefreshtoken__c==null){
                        insrtUserRec.GoogleDriveRefreshtoken__c = refreshtoken;
                    }
                    
                    accessToken=insrtUserRec.GoogleDriveAccessToken__c = responsewrapr.access_token;                
                    
                    upsert insrtUserRec userId__c;
                    //upsert integrationvriable userid__c
                    showFolder('root');
                }
                else{
                    System.debug('Controller : Auth code is null : ' + code);
                    return pg;
                }            
                return null;
            }   
            else{/*if user is already authenticated with google drive butt access token is expired.. than login via refresh token*/
                System.debug('Controller : singleCommunityRec.GoogleDriveRefreshtoken__c : ' + singleCommunityRec.GoogleDriveRefreshtoken__c);
                HttpResponse response = gdService.getNewAccessToken(key, secret, singleCommunityRec.GoogleDriveRefreshtoken__c);
                if(response.getStatusCode()==400 || response.getStatusCode()==401){
                    pg = gdService.getAuthURL(key, redirectURL);
                    code = ApexPages.currentPage().getParameters().get('code');
                    if(code==null || code==''){
                        return pg;
                    }
                    else{
                       response = gdService.getAccessToken(code, key, secret, redirectURL);
                        if(response.getStatusCode()==400 || response.getStatusCode()==401){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Invalid access token...!!!'));
                        }
                        else{
                            FileDetailsWrapper.googleDriveAccessTokenResponse responsewrapr = (FileDetailsWrapper.googleDriveAccessTokenResponse)JSON.deserialize(response.getBody(), FileDetailsWrapper.googleDriveAccessTokenResponse.class);                    
                            Community__c insrtUserRec = new Community__c();
                            insrtUserRec.userid__c = UserInfo.getUserId();
                            accessToken = insrtUserRec.GoogleDriveAccessToken__c = responsewrapr.access_token;                            
                            if(responsewrapr.refresh_token == null || responsewrapr.refresh_token == ''){
                                insrtUserRec.GoogleDriveRefreshtoken__c = refreshtoken;
                            }
                            else{
                                insrtUserRec.GoogleDriveRefreshtoken__c = responsewrapr.refresh_token;
                            }                                                     
                            
                            showFolder('root');
                            upsert insrtUserRec userid__c;
                        }
                    }
                }
                else{
                    FileDetailsWrapper.googleDriveAccessTokenResponse driveTokenResponse = (FileDetailsWrapper.googleDriveAccessTokenResponse)JSON.deserialize(response.getBody(), FileDetailsWrapper.googleDriveAccessTokenResponse.class);
                    System.debug('Controller : ' + driveTokenResponse);
                    accessToken = driveTokenResponse.access_token;
                    showFolder('root');
                }
            }                    
            return null;  
        }
        else{ /* upsert user record if user login frist time  */           
            
            pg = gdService.getAuthURL(key, redirectURL);
            code = ApexPages.currentPage().getParameters().get('code');
            if(code!=null && code!=''){                
                HttpResponse response = gdService.getAccessToken(code,key, secret, redirectURL);
                FileDetailsWrapper.googleDriveAccessTokenResponse responsewrapr = (FileDetailsWrapper.googleDriveAccessTokenResponse)JSON.deserialize(response.getBody(), FileDetailsWrapper.googleDriveAccessTokenResponse.class);
                System.debug('Controller : ' +responsewrapr);
                Community__c insrtUserRec = new Community__c();
                insrtUserRec.userId__c = UserInfo.getUserId();            
                insrtUserRec.GoogleDriveRefreshtoken__c = responsewrapr.refresh_token;
                if(insrtUserRec.GoogleDriveRefreshtoken__c==null){
                    insrtUserRec.GoogleDriveRefreshtoken__c = refreshtoken;
                }                
                accessToken=insrtUserRec.GoogleDriveAccessToken__c = responsewrapr.access_token;                                
                showFolder('root');
                insert(insrtUserRec); 
                return null;    
            }
            else{
                System.debug('Controller : Auth code is null : ' + code);
                return pg;
            }                                   
        }
    // Function Close
    }     
    /*Get Folder Id from VF page and according to this id Sub folder will be show*/
    public void showSubFolder(){
        folderId = ApexPages.currentPage().getParameters().get('folderId');
        String fName = ApexPages.currentPage().getParameters().get('folderName');
         FileDetailsWrapper.FileDetail tmp = new FileDetailsWrapper.FileDetail();
        tmp.Id = folderId;
        tmp.name = fName;
        breadCrum.add(tmp);

        if(folderId==null || folderId==''){
            folderId='root';
        }
        System.debug('Folder Id : ' + folderId);
        showFolder(folderId);
    }

    //Show All the folder according to folder id 
    public void showFolder(String fId){
        System.debug('fId : ' + fId);
        lstOfFile.clear();
        lstOfFolder.clear();
        FileDetailsWrapper lstOfFileFolder = new FileDetailsWrapper();
        lstOfFileFolder = gdService.getData(fId, accessToken);
        System.debug('lstOfFileFolder : ' + lstOfFileFolder);
        for(FileDetailsWrapper.FileDetail fDetail : lstOfFileFolder.files){
            if(fDetail.mimeType=='application/vnd.google-apps.folder'){
                lstOfFolder.add(fDetail);
            }
            else{
                lstOfFile.add(fDetail);
            }   
        }        
    //Show Folder Close    
    }

    public void getFolderName(){        
        folderName = ApexPages.currentPage().getParameters().get('folderName');
        System.debug('Folder Name : ' + folderName);
        System.debug('Folder Id : ' + folderId);
        gdService.createFolder(folderName, folderId, accessToken);
        showFolder(folderId);
    }   

    public void deleteFolder(){
        String fId=ApexPages.currentPage().getParameters().get('FolderId');        
        gdService.deleteFolder(fId, accessToken);
        showFolder(folderId);
    }

    public PageReference downloadFile(){
        folderId = ApexPages.currentPage().getParameters().get('fileId');
        System.debug('File id : ' + folderId);
        PageReference pg = new PageReference(gdService.downloadFile(folderId, accessToken));        
        return pg;
    }

    public PageReference viewFile(){
        folderId = ApexPages.currentPage().getParameters().get('fileId');
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'folderName : ' + folderId));
        System.debug('File id : ' + folderId);
        /*PageReference pg = new PageReference(gdService.viewFile(folderId, accessToken));
        return pg;*/
        previewLink = gdService.viewFile(folderId, accessToken);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Web view link : ' + previewLink));
        return null;
    }

    public void uploadFile(){
        try{  
            if(recFileName == null || recFileName == ''){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Select at least one file for upload...!!!'));
            }        
            else{
                gdService.uploadFile(recFileName,fileType, data, folderId, accessToken);
                showFolder(folderId);
                recFileName='';            
            }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'File data exceeds limit...!!!'));
        }
    }

    public void breadCrumFolderNavigation(){
        folderId = ApexPages.currentPage().getParameters().get('folderId');
        Integer i=0;
        List<FileDetailsWrapper.FileDetail> tmp = new List<FileDetailsWrapper.FileDetail>();
        tmp.addAll(breadCrum);

        for( ; i<breadCrum.size(); i++)
        {
            if(folderId == breadCrum[i].id){
                break;
            }
        }

        breadCrum.clear();
        System.debug('tmp.size : ' + tmp.size());
        for(Integer j=0; j<=i; j++){   
        System.debug('j : ' + j);                     
            if(j>=i){                
                breadCrum.add(tmp[j]);
                break;
            }
            else{
                breadCrum.add(tmp[j]);
            }
        }

        showFolder(folderId);
    }

}


// Key :- 424589915414-ggfvn5ecet5nppdh1tpg4dssk4cuk2nq.apps.googleusercontent.com
// Secrect :- x7Tm9m17DQJ6TxEMno_QJd8N
// refresh token :- 1/QS8DQYc5v4CglYMzXjFNbQCvWVllVHCOZGQEn2NSuk0;
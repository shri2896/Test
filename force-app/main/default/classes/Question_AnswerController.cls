/**
* @ Description : For Return all the question, correct answer and options of the question for the selected language
* @ Author : Shrikant Mittal
* @ Date : 17-07-19
*/

//For Return all the question, correct answer and options of the question for the selected language
public class Question_AnswerController {
    

    //Return list of language
    @AuraEnabled
    public static List<Language__c> getLanguageList(){
        List<Language__c> queLst = new List<Language__c>();
        queLst = [Select Name from Language__c];
        return queLst;
    }
    
    //Return question & all the options of the selected language
    @AuraEnabled
    public static List<Question__c> getQuestionList(String languageId){
    	List<Question__c> questionList = [Select Question__c, Question_has_single_ans__c, CorrectAns__c, (Select Name, Question__c, Options__c from Answers__r) from Question__c where Language__c = :languageId];

    	system.debug('questionList : ' + questionList);
        //system.debug('rec : ' + [select Question__c from Question__c where ID = 'a0b6F00000QKePhQAL']);
        for(Question__c q : questionList){
            system.debug('que : ' + q);
            for(Answer__c a : q.Answers__r){
                system.debug('anser : ' + a);
            }
        }
    	return questionList;
    }

    //Return language name
    @AuraEnabled    
    public static String getLanguageName(ID languageId){
        Language__c lang = [Select Name from Language__c where ID = :languageId LIMIT 1];

        return lang.Name;
    }

    @AuraEnabled
    public static Boolean userRecord(String fName, String lName, String email){        

        List<Contact> contactLst = [Select Email, Name from Contact where Email = :email];
        if(contactLst.size() > 0){
            return true;
        }
        else{
            Contact cont = new Contact();
            cont.LastName = lName;
            cont.Email = email;
            
            insert cont;

            return false;
        }        
    }

    //Return instruction of selected language
    @AuraEnabled    
    public static Language__c getInstructions(String language){
        system.debug('language : ' + language);
        List<Language__c> instruction = [Select Instructions__c, Hours__c, Minute__c from Language__c where Id = :language];
        system.debug('instruction : ' + instruction);

        if(!instruction.isEmpty()){
            return instruction[0];
        }
        else{
            return null;
        }
        
    }
}
({
    getLanguageHelper : function(component, event) {
        
        var action = component.get('c.getLanguageList');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set('v.languageLst', response.getReturnValue());
            }
            else{
                alert('Error  ' + response.getError());
            }

        })
        $A.enqueueAction(action);       
     },

     //Set the time for quiz and getInstructions for selected language
     getSelectedLanguage : function(component, event){
         var language = component.get('v.selectedLanguageID');
         
         if(language != 'None'){
            var action = component.get('c.getInstructions');
            action.setParams({'language' : language});

            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var getInstruction = response.getReturnValue();
                    
                    component.set('v.instructions', getInstruction.Instructions__c);
                    if(getInstruction.Hours__c == undefined){
                        component.set('v.hours', 0);
                    }
                    else{
                        component.set('v.hours', getInstruction.Hours__c);
                    }

                    if(getInstruction.Minute__c == undefined){
                        component.set('v.minute', 0);
                    }
                    else{
                        component.set('v.minute', getInstruction.Minute__c);
                    }                                
                    
                    component.set('v.showLanguage', false);                    
                }
                else{
                    alert('error in getting instructions : ' + JSON.stringify(response.getError()));
                }
            })
            $A.enqueueAction(action);
         }
         else{
            component.find('startbutton').set('v.disabled', true);
         }         
     },

     //Start quiz time and show all the question
     startQuizHelper : function(component, event){
        var fName = component.get('v.firstName');
        var lName = component.get('v.lastName');
        var email = component.get('v.email');
        
        var action = component.get('v.getTime');
        component.set('v.showQuizQuestion', 'true');

     },

     checkUserRecord : function(component, event, fName, lName, email){
         
         var action = component.get('c.userRecord');
         action.setParams({'fName' : fName, 'lName' : lName, 'email' : email});
         action.setCallback(this, function(response){
             var state = response.getState();
             if(state === 'SUCCESS'){
                if(response.getReturnValue() == true){
                    alert('Email already registered');
                }
                else{                    
                    component.set('v.showQuizQuestion', 'true');
                }
             }
             else{
                 alert('error in user record : ' + JSON.stringify(response.getError()));
             }
         })
         $A.enqueueAction(action);
     }
    
})
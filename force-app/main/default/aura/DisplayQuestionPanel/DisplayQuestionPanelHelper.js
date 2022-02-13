({
    findUnAnsweredQuestion : function(component, event){
   		var queLst = component.get('v.questionList');
        var ansLst = component.get('v.answeredQuestion');
        var updateToAnsLst = [];

        for(var i = 0 ; i < ansLst.length; i++){            
            var que = ansLst[i].question;
            updateToAnsLst.push({'Question__c' : que.Question__c, 'Question_has_single_ans__c' : que.Question_has_single_ans__c, 'CorrectAns__c' : que.CorrectAns__c, 'Id' : que.Id, 'Answers__r' : que.Answers__r})                        
        }
        component.set('v.answeredQuestion', updateToAnsLst)

        this.getUnAnsweredQuestion(component, event);
    },
    
    getUnAnsweredQuestion : function(component, event){
        var allQue = component.get('v.questionList');
        var ansQue = component.get('v.answeredQuestion');
        var unAnsQue = [];

        allQue.filter(function(allQueObj){
            var status = false;
            ansQue.filter(function(ansQueObj){
                if(allQueObj.Id == ansQueObj.Id){
                    status = true;
                }
            })

            if(!status){
                unAnsQue.push(allQueObj);
            }
        })
        
        component.set('v.unAnsweredQuestion', unAnsQue);
    },

    getSelectedQueHelper : function(component, event) {
        var que = event.currentTarget.getAttribute("data-attriVal");
        
        component.getEvent('sendSelectedQuestion').setParams({'selectedQuestion' : que}).fire();
        component.destroy();     
    }
})
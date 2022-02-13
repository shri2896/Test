({
    //set option background for wrong question & right question
    setOptionBackgroundHelper : function(component, event) {
        var questionLst = component.get('v.questionList');
        var lstToUpdate = [];

        for(var i = 0; i < questionLst.length; i++){
            var optionLst = [];
            var isSingleSelection = questionLst[i].question.Question_has_single_ans__c;            
            var opt = questionLst[i].option;
            var rightAns = questionLst[i].question.CorrectAns__c;
            var answerStaus = 'Correct';

            //For radio button
            if(isSingleSelection){
                for(var j = 0; j < opt.length; j++){
                    
                    //remove formatting text from rich-text-area field
                    var element = document.createElement("DIV");
                    element.innerHTML = opt[j].Name;
                    var removeFormattingText = element.textContent;

                    //When user select wrong anser
                    if(opt[j].isChecked && removeFormattingText != rightAns){
                        optionLst.push({'Name' : opt[j].Name, 'isChecked' : opt[j].isChecked, 'isWrong' : 'yes'});
                        answerStaus = 'Incorrect';
                    }
                    //when user select right answer
                    else if(removeFormattingText == rightAns){                        
                        optionLst.push({'Name' : opt[j].Name, 'isChecked' : opt[j].isChecked, 'isWrong' : 'no'});                        
                    }
                    //when option not include in either right answer nor wrong answer
                    else{
                        optionLst.push({'Name' : opt[j].Name, 'isChecked' : opt[j].isChecked, 'isWrong' : ''});
                    }
                }
            }
            else{
                // For checkbox
                var ansArr = rightAns.split(',');

                for(var j = 0; j < opt.length; j++){

                    var element = document.createElement("DIV");
                    element.innerHTML = opt[j].Name;
                    var formattingRemoveText = element.textContent;
                    
                    if(opt[j].isChecked && !ansArr.includes(formattingRemoveText)){
                        optionLst.push({'Name' : opt[j].Name, 'isChecked' : opt[j].isChecked, 'isWrong' : 'yes'});
                        answerStaus = 'Incorrect';
                    }
                    else if(ansArr.includes(formattingRemoveText)){
                        if(!opt[j].isChecked){
                            answerStaus = 'Incorrect';
                        }                        
                        optionLst.push({'Name' : opt[j].Name, 'isChecked' : opt[j].isChecked, 'isWrong' : 'no'});                     
                    }
                    else{
                        optionLst.push({'Name' : opt[j].Name, 'isChecked' : opt[j].isChecked, 'isWrong' : ''});
                    }
                }
            }

            lstToUpdate.push({'question' : questionLst[i].question, 'answerStatus' : answerStaus, 'option' : optionLst});            
        }
        
        //console.log('questionlist : ' + JSON.stringify(lstToUpdate));

        component.set('v.questionList', lstToUpdate);
        this.findAllWrongAnswer(component, event);
    },

    checkQuestionRightOrWrongHelper : function(component, event){
        var status = event.getParam('ansStatus');        
        if(status == true){
            component.set('v.answerstatus', 'InCorrect');
        }
    },

    //distinguish between right and wrong answer list
    findAllWrongAnswer : function(component, event){

        var questionLst = component.get('v.questionList');
        var wrongQueLst = [];
        var correctQueLst = [];

        for(var i = 0 ; i < questionLst.length; i++){            
            var options = questionLst[i].option;
            var optionLst = [];
            var status = false;
            
            if(questionLst[i].answerStatus == 'Correct'){
                correctQueLst.push(questionLst[i]);
            }
            else{
                wrongQueLst.push(questionLst[i]);
            }

            // for(var j = 0; j < options.length; j++){
            //     if(options[j].isWrong == 'yes'){
            //         status = true;
            //     }
            // }

            // if(status){
            //     wrongQueLst.push(questionLst[i]);
            // }

            // else{
            //     correctQueLst.push(questionLst[i]);
            // }
        }
         
        if(correctQueLst.length > 0){
            this.sendCorrectQuesList(component, event, correctQueLst);
        }

        if(wrongQueLst.length > 0){
            this.sendWrongQuesList(component, event, wrongQueLst);
        }
    },    

    sendCorrectQuesList : function(component, event, correctQueLst){
        component.getEvent('correctAnswer').setParams({'correctAnswer' : correctQueLst}).fire();
    },

    sendWrongQuesList : function(component, event, wrongQueLst){        
        component.getEvent('wrongAnswer').setParams({'wrongAnswer' : wrongQueLst}).fire();
    },

})
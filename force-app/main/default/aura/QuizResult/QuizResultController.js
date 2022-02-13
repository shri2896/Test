({
    doInit : function(component, event, helper) {        
    },

    setCorrectAnswer : function(component, event, helper){
        component.set('v.correctAnswerList', event.getParam('correctAnswer'));
        var totalQues = component.get('v.questionCount');
        var correctAnsLength = event.getParam('correctAnswer').length;
        var resultStatus = (correctAnsLength / totalQues) * 100;        
        component.set('v.result', Math.floor(resultStatus));
        
        if(resultStatus < 35){
            component.set('v.resultStatus', 'Fail');
        }
        else if(resultStatus > 35 && resultStatus < 60){
            component.set('v.resultStatus', 'Need of improvement');
        }
        else if(resultStatus > 60 && resultStatus < 80){
            component.set('v.resultStatus', 'Good');
        }
        else if(resultStatus > 80){
            component.set('v.resultStatus', 'Excellent');
        }

    },

    setWrongAnwser : function(component, event, helper){
        component.set('v.wrongAnswerList', event.getParam('wrongAnswer'));
    }
})
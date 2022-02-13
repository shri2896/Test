({
    clickCreate: function(component, event, helper){
        var validExpense = component.find('expenseform').reduce(function( validSoFar, inputCmp){             															  
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid            
        },true );
        if(validExpense){
            var newExpense = component.get("v.newExpense")
            console.log("create expense " + JSON.stringify(newExpense))
            helper.createExpense(component, newExpense)
        }
    },
    doInit: function(component, event, helper){
        var action = component.get("c.getExpenses");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){                
                component.set("v.expenses", response.getReturnValue());               
            }
            else{
                console.log("Faild : " + state)
            }
        })
        $A.enqueueAction(action)
    },
    
    handleUpdateExpense: function(component, event){
        var updateExp = event.getParam("expense")
        console.log("event val : " + updateExp)
        helper.updateExpense(component, updateExp)
    }
})
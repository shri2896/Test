({
    createExpense: function(component, expense){
        var action = component.get("c.saveExpenses")
      	action.setParams({
        	"expense": expense            
        })
        action.setCallback(this, function(response){
        var state = response.getState();
        if(state == 'SUCCESS'){
         	var expenses = component.get("v.expenses");
          	expenses.push(response.returnValue())
           	componenet.set("v.expenses", expenses)
        }
        })
        $A.enqueueAction(action)
    },
    updateExpense: function(component, expense){
        var action = component.get("c.saveExpenses")
        action.setParam({
            "expense":expense
        })
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                console.log("Success" + expense)
            }
        })
        $A.enqueueAction(action)
    }
})
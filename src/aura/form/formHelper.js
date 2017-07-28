({
	getExpenses : function(component) {
		var action = component.get("c.getExpense");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.expenses", response.getReturnValue());
                this.updateTotal(component);
            }
        });
        $A.enqueueAction(action);
	}, //delimited for future code additions/resuse
    createExpense : function(component, expense){
        this.upsertExpense(component, expense, function(a) {
        var expenses = component.get("v.expenses");
        expenses.push(a.getReturnValue());
        component.set("v.expenses", expenses);
        this.updateTotal(component);
      });
    },
    upsertExpense : function(component, expense, callback) {
    	var action = component.get("c.saveExpense");
    	//Sending JSON Message to the controller action 
        action.setParams({ 
        	"expense": expense
    	});
    	if (callback) {
      		action.setCallback(this, callback);
    	}
    	$A.enqueueAction(action);
    }, //add more functions below this line
    updateTotal : function(component){
        var expensevar = component.get("v.expenses");
        component.set("v.totalExp", expensevar.length);
    },
})
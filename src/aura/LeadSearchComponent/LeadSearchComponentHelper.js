({
	helperSearch : function(component, event) {
		var searchText = component.find("searchTerm").get("v.value");
        console.log(searchText);
        var recordLimit = component.get("v.maxResults");
        var action = component.get("c.getLeads");
        console.log(action);
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
           	if (component.isValid() && state === "SUCCESS") {
            	component.set("v.leadList", response.getReturnValue());
        	}
            else
                throw new Error("The response coming back form the controller is error "+response.message);
      	});
        $A.enqueueAction(action);
        
    }
})
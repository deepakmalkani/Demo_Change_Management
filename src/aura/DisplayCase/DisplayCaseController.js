({
	getCases : function(component, event, helper) {
		var recordId = component.get("v.caseId");
        console.log('---> the record id is '+recordId);
        var action = component.get("c.getCaseFromId");
        if(typeof(recordId) == null || typeof(recordId) == 'undefined')
        {
        	action.setParams({
            	caseID : null    
        	});
        }
        else
        {
            console.log('i am in else');
            action.setParams({
            	caseID : recordId    
        	});
        }
        action.setCallback(this, function(response){
            console.log(response.getState());
            if(response.getState() == "SUCCESS"){
                component.set("v.record", response.getReturnValue());
                console.log('--> the response is '+response.getReturnValue());
            }
            else if(response.getState() == "ERROR"){
                var errors = response.getError();
                if(errors)
                {
                    console.log("Error Message "+errors[0].message);
                }
                else
                {
                    console.log("Unknown Error");
                    $A.log('Error');
                }    
            }
            
        });
        $A.enqueueAction(action);
    }
})
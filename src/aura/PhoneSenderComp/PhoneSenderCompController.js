({
	fireEvt : function(component, event, helper) {
		var myPhone = component.find("Phone").get("v.value");
        console.log(myPhone);
        //var myPhone = event.source.get("v.Phone");
        $A.get("e.c:PhoneAppEvt").setParams({
            PhoneStr: myPhone
        }).fire();
        //console.log(event.getName());
        //console.log(event.getParams());
	}
})
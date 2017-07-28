({
	firePhone : function(component, event, helper) {
		var phoneText = component.find("phone").get("v.value");
        console.log(phoneText);
        $A.get("e.c:PhoneNumberEvent").setParams({
            phone: phoneText
        }).fire();
	}
})
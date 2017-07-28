({
	myReceiving : function(component, event, helper) {
		var myPhoneText = event.getParam("PhoneStr");
        component.find("myOutputPhone").set("v.value", myPhoneText);
	}
})
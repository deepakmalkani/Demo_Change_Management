({
	myPhoneReceiver : function(component, event, helper) {
		var receiveText = event.getParam("phone");
        console.log('I received'+receiveText);
        component.set("v.number", receiveText);
	}
})
({
	myreceiver2 : function(component, event, helper) {
		var text = event.getParam("text");
		component.set("v.myText2", text);
	}
})
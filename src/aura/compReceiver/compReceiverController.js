({
	send : function(component, event, helper) {
		var myText = event.source.get("v.label");
		component.getEvent("myMessageEvent").setParams({
			"myText": myText
		}).fire();
	}, 
	
	answer : function(component, event, helper) {
		var myTextMssg = event.getParam("myText");
		component.set('v.myText', myTextMssg);
	}
})
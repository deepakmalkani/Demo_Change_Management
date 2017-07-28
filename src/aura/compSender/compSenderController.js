({
	send : function(component, event, helper) {
		var myText = event.source.get("v.label");
		component.getEvent("myMessageEvent").setParams({
			"myText": myText
		}).fire();
	}
})
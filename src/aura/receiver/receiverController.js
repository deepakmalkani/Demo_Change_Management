({
	answer : function(component, event, helper) {
			var text = event.getParam("text");
			component.set("v.myText", 'I received the message too '+text);
	}
})
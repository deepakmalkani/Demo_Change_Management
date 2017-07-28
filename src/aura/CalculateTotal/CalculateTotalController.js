({
	calculate : function(component, event, helper) {

		var number1 = component.find("inputOne").get("v.value");
		var number2 = component.find("inputTwo").get("v.value");
		var number3 = component.find("inputThree").get("v.value");
		var numberCalc;

		numberCalc = parseInt(number1) + parseInt(number2) - parseInt(number3);
		component.find("totalValue").set("v.value", numberCalc);

	}
})
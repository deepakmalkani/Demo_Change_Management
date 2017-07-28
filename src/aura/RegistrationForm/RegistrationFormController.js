({
	getInput : function(component, event, helper) {
		var myFirstName = cmp.find("fName").get("v.value");
		var myLastName = cmp.find("lName").get("v.value");
		var myPhone = cmp.find("Phone").get("v.value");
		var mySalutation = cmp.find("Sal").get("v.value");
		cmp.find("OutFirstName").set("v.value", myFirstName);
		cmp.find("OutLastName").set("v.value", myLastName);
		cmp.find("OutPhone").set("v.value", myPhone);
		cmp.find("OutSal").set("v.value", mySalutation);
	}
})
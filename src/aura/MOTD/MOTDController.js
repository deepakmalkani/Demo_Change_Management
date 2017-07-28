({
	checkWeekDay : function(component, event, helper) {
		var d = new Date();
		var WeekDay = $A.get("$Locale.nameOfWeekDays");
		var n = WeekDay[d.getDay()].fullName;
		component.set("v.DayOfTheWeek", n);
	}
})
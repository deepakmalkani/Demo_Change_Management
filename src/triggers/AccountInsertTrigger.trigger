trigger AccountInsertTrigger on Account (before insert, after insert) {



    if(trigger.isBefore){
        if(trigger.isInsert){

        }
    }
    if(trigger.isAfter){
        if(trigger.isInsert){
    //        AccountInsertHandler accntHandler = new AccountInsertHandler();
    //        accntHandler.getOwners(trigger.new);
        }
    }
}
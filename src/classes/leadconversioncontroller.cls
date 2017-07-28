public class leadconversioncontroller 
{
    public ID getLeadId = System.currentPagereference().getParameters().get('vaLeadId');    
    public ID returnId;
    
    public String getvLeadId()
    { 
        return getLeadId; 
    }
    public Flow.Interview.Custom_Lead_ConvertFlow myCustomLeadConversion {get;set;}
    
    public String getvUserId()
    {
        return Userinfo.getUserId();
    }
    
    public String getvUserLang()
    {
        User usr = [SELECT LocaleSidKey FROM user WHERE id =: Userinfo.getUserId()];
        String userLanguage = usr.LocaleSidKey;
        return userLanguage;
    }
    
    public PageReference getmyreturnUrl()
    {
        if(myCustomLeadConversion != null) 
          returnId = getLeadId;
            
        PageReference send = new PageReference('/' + returnId);
        send.setRedirect(true);
        return send;

    }


    


}
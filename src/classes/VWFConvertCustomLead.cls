global class VWFConvertCustomLead implements Process.Plugin 
{
    // This method runs when the step is reached in a Flow
    global Process.PluginResult invoke(Process.PluginRequest request) 
    {
        // set up variables to store input parameters from the Flow
        
        String leadID = (String) request.inputParameters.get('LeadID');
        //Adding lead name as the input parameter
        
        String leadname = (String) request.inputParameters.get('LeadName');
        String contactID = (String) request.inputParameters.get('ContactID');
        String accountID = (String) request.inputParameters.get('AccountID');
        String convertedStatus = (String) request.inputParameters.get('ConvertedStatus');
        Boolean overWriteLeadSource = (Boolean) request.inputParameters.get('OverwriteLeadSource');
        Boolean createOpportunity = (Boolean) request.inputParameters.get('CreateOpportunity');
        //add this to the flow to ask use the option of creating an optional opportunity or not
        
        String opportunityName = (String) request.inputParameters.get('ContactID');
        Boolean sendEmailToOwner = (Boolean) request.inputParameters.get('SendEmailToOwner');   
        
        // Set the default handling for booleans 
        if (overWriteLeadSource == null) overWriteLeadSource = false;
        if (createOpportunity == null) createOpportunity = true;
        if (sendEmailToOwner == null) sendEmailToOwner = false;
        
        // convert the lead by passing to a helper method
        Map<String,Object> result = new Map<String,Object>();    
        result = convertLead(leadID, contactID, accountID, convertedStatus, overWriteLeadSource, createOpportunity, opportunityName, sendEmailToOwner);
        return new Process.PluginResult(result); 
    }
    
    // This method describes this plugin, as well as its inputs and outputs to the Cloud Designer
    // NOTE: Implementing this method is what makes this class appear in the designer
    
    global Process.PluginDescribeResult describe() 
    {
        // Set up plugin metadata
        Process.PluginDescribeResult result = new Process.PluginDescribeResult();
        result.description = 'The LeadConvert Flow Plug-in converts a lead into an account and contact, as well as (optionally) an opportunity.';
        result.tag = 'Lead Management';
        
        // create a list that stores both mandatory and optional *input* parameters from a Flow
        // NOTE: Only primitive types (STRING, NUMBER, etc) are supported at this time.
        // Collections are not currently supported
        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            // Lead ID, Name (mandatory)
            new Process.PluginDescribeResult.InputParameter('LeadID', 
                    Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('Leadname',
                    process.PluginDescribeResult.ParameterType.STRING, true),
            // Account Id (optional)
            new Process.PluginDescribeResult.InputParameter('AccountID', 
                    Process.PluginDescribeResult.ParameterType.STRING, false),
            // Contact ID (optional)
            new Process.PluginDescribeResult.InputParameter('ContactID', 
                    Process.PluginDescribeResult.ParameterType.STRING, false),            
            // Status to use once converted
            new Process.PluginDescribeResult.InputParameter('ConvertedStatus', 
                    Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('OpportunityName', 
                    Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('OverwriteLeadSource', 
                    Process.PluginDescribeResult.ParameterType.BOOLEAN, false),
            new Process.PluginDescribeResult.InputParameter('CreateOpportunity', 
                    Process.PluginDescribeResult.ParameterType.BOOLEAN, false),
            new Process.PluginDescribeResult.InputParameter('SendEmailToOwner', 
                    Process.PluginDescribeResult.ParameterType.BOOLEAN, false)                                                   
        };

        // Create a list that stores *output* parameters sent *to* your flow.
        // The Output parameters are : Account Name, Opportunity Name,OpptyId, AccntId and ContactId
        result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter>{
            // Account ID of the converted lead
            new Process.PluginDescribeResult.OutputParameter('AccountID', 
                    Process.PluginDescribeResult.ParameterType.STRING),
            // Account Name of the converted Lead
            new Process.PluginDescribeResult.OutputParameter('AccountName',
                    Process.PluginDescribeResult.ParameterType.STRING),
            // Contact ID of the converted lead
            new Process.PluginDescribeResult.OutputParameter('ContactID', 
                    Process.PluginDescribeResult.ParameterType.STRING),
            // Opportunity ID of the converted lead
            new Process.PluginDescribeResult.OutputParameter('OpportunityID', 
                    Process.PluginDescribeResult.ParameterType.STRING),
            //Opportunity Name of the converted Lead
            new Process.PluginDescribeResult.OutputParameter('OpportunityName',
                    Process.PluginDescribeResult.ParameterType.STRING)
        };

        return result;
    }
        
    /**
     * Implementation of the LeadConvert plugin
     * Converts a given lead with several options:
     * leadID - The ID of the lead to convert
     * contactID - 
     * accountID - ID of the Account to attach the converted Lead/Oppty/Contact to.
     * convertedStatus - 
     * overWriteLeadSource - 
     * createOpportunity - true if you want to create a new Opportunity upon conversion
     * opportunityName - Name of the new Opportunity.
     * sendEmailtoOwner - true if you are changing owners upon conversion and want to send an email to the new owner of the Oppty.
     *
     * returns: a Map with the following output:
     * AccountID - ID of the Account created or attached to upon conversion.
     * ContactID - ID of the contact created or attached to upon conversion.
     * OpportunityID - ID of the opportunity created upon conversion.
     */
     
     //Your entire Lead conversion logic happens here.
     
    public Map<String,String> convertLead (
                               String leadID,
                               String contactID,
                               String accountID,
                               String convertedStatus,
                               Boolean overWriteLeadSource,
                               Boolean createOpportunity,
                               String opportunityName,
                               Boolean sendEmailToOwner
        ) 
        {
        Map<String,String> result = new Map<String,String>();
                                
        if (leadId == null) throw new ConvertLeadPluginException('Lead Id cannot be null.Lead is not found');
        
        // check for multiple leads with the same ID
        Lead[] leads = [Select Id, Name, FirstName, LastName, Company From Lead where Id = :leadID];
        if (leads.size() > 0) {
            Lead l = leads[0];
            // CheckAccount = true, checkContact = false
            //This condition means that a new account will be created on lead conversion
            if (accountID == null && l.Company != null) 
                {
                    Account[] accounts = [Select Id, Name FROM Account where Name = :l.Company LIMIT 1];
                    if (accounts.size() > 0) 
                    {
                        accountId = accounts[0].id;
                    }
                }
            
            // perform the lead conversion
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(leadID);
            lc.setOverwriteLeadSource(overWriteLeadSource);
            lc.setDoNotCreateOpportunity(!createOpportunity);
            lc.setConvertedStatus(convertedStatus);
            if (sendEmailToOwner != null) 
                lc.setSendNotificationEmail(sendEmailToOwner);
            if (accountId != null && accountId.length() > 0) 
                lc.setAccountId(accountId);
            if (contactId != null && contactId.length() > 0) 
                lc.setContactId(contactId);
            if (createOpportunity) 
                {
                    lc.setOpportunityName(opportunityName);
                }
            
            Database.LeadConvertResult lcr = Database.convertLead(lc, true);
            if (lcr.isSuccess()) 
                {
                    List<Account> accnt = [SELECT id, name FROM Account WHERE id =: lcr.getAccountId() LIMIT 1];                
                    if(accnt.Size() >0)
                        result.put('AccountName', accnt[0].name);
                    result.put('AccountID', lcr.getAccountId());                    
                    result.put('ContactID', lcr.getContactId());
                    if (createOpportunity) 
                    {
                        List<Opportunity> oppty = [SELECT id, name FROM Opportunity WHERE id =: lcr.getContactId() LIMIT 1];
                        if(oppty.Size() >0)
                            result.put('OpportunityName', oppty[0].name);
                        result.put('OpportunityID', lcr.getOpportunityId());
                    }
                } 
                else 
                {
                    String error = lcr.getErrors()[0].getMessage();
                    throw new ConvertLeadPluginException(error);
                }
        } 
        else 
        { 
            throw new ConvertLeadPluginException('No leads found with Id : "' + leadId + '"');
        }
        return result;
    }
        
        // Utility exception class
        class ConvertLeadPluginException extends Exception {}
}
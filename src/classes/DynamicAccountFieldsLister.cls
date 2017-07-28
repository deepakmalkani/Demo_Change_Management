public class DynamicAccountFieldsLister {

    public List<String> editableFields{
        get{
            if(editableFields== null)
            {
                editableFields= new List<String>();
                editableFields.add('Industry');
                editableFields.add('Name');
                editableFields.add('AnnualRevenue');
            }
            return editableFields;
        }
        private set;
        }
        
    public DynamicAccountFieldsLister(ApexPages.StandardController controller) {
        controller.addFields(editableFields);
    }
    
    
}
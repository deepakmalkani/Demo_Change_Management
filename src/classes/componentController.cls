public class componentController{

    //Deepak Malkani : Part 2 : getter methods for custom component controller and constructor will start.
   
    public String selectedValue{
        get;
        set{
            //incorrect, so it correct this behavior, I am using a setter for editMode
            editMode = (value != null);
            selectedValue = value;
        }
    }
    //public Boolean editMode { get; private set; }
    public Boolean editMode{
        get{
            return (this.selectedValue != null);
        }
        set;            
        }
    
}
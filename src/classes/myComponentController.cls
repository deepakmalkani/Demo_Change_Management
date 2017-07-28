public with sharing class myComponentController {

    public String componentValue;
    public void setcomponentValue(String s){
        this.componentValue = s.toUpperCase();
    }
    public String getComponentValue(){
        return componentValue;
    }
}
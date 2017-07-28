public with sharing class OpportunityControllerExt {

        
    public transient List<SelectOption> options;
    public String selectedRegVal;
    public String selectedAssVal;
    public String selectedProdVal;
    public transient List<SelectOption> assetoptions;
    public transient List<SelectOption> productoptions;
    public List<ProductWrapper> prodWrapList;
    public transient Boolean regionQueryFire = false;
    public transient Boolean vehicleQueryFire = false;    
    public transient Boolean assetQueryFire = false;
    public transient Boolean productQueryFire = false;
    public List<Product2> selectedProdList = new List<Product2>();
    public String ProductId;
    public Set<String> prodselectedSet = new Set<String>();
    public Set<String> productIds = new Set<String>();    
    public Opportunity opptyRec;

    
    public OpportunityControllerExt(ApexPages.StandardController controller) {
        opptyRec = (Opportunity) controller.getRecord();
    }
    
    public String getselectedRegion(){
        return selectedRegVal;
    }
    
    public void setselectedRegion(String myRegion){
        system.debug('--> region parameter passed is '+myRegion);
        selectedRegVal = myRegion;
    }
    
    public void setselectedProduct(String myProd){
        selectedProdVal = myProd;
    }

    public String getselectedProduct(){
        return selectedProdVal;
    }
    
    public String getselectedAsset(){
        return selectedAssVal;
    }
    
    public void setselectedAsset(String myAsset){
        system.debug('----> asset parameter passed is '+myAsset);    
        selectedAssVal = myAsset;
    }
   
    public String getProductId(){
        return ProductId;        
    }

    public void setProductId(String prodId){
        ProductId = prodId;
        if(prodselectedSet.contains(ProductId))
            prodselectedSet.remove(ProductId);
        else 
            prodselectedSet.add(ProductId);

        system.debug('---> Product Selected Set is '+prodselectedSet);
    }

    public List<SelectOption> getRegion(){
        options = new List<SelectOption>();
        for(dpklightning__MAM_Region__c regions : [SELECT Name FROM dpklightning__MAM_Region__c]){
            regionQueryFire = true;
            options.add(new SelectOption(regions.Id, regions.Name));
        }
        if(selectedRegVal == null)
        {
            selectedRegVal = [SELECT Name FROM dpklightning__MAM_Region__c LIMIT 1].Id;
        }
        return options;        
    }
    
    public List<SelectOption> getAsset(){
        
        assetQueryFire = true;
        //Get assets based on Vehicle.
        assetoptions =  new List<SelectOption>();       
        for(dpklightning__MAM_Assets__c assets : [SELECT name FROM dpklightning__MAM_Assets__c WHERE dpklightning__Region__r.id=: selectedRegVal]){
            assetoptions.add(new SelectOption(assets.id, assets.name));
        }
       
        if(selectedAssVal == null || regionQueryFire == true)
            selectedAssVal = [SELECT name FROM dpklightning__MAM_Assets__c WHERE dpklightning__Region__r.id=: selectedRegVal LIMIT 1].id;
        
        return assetoptions;
    }

    public List<ProductWrapper> getWrapperProducts(){
        system.debug('---> inside getwrapper products');
        productQueryFire = true;
   
        //This block will fire on region section change or on load for the first time or on asset value change
        if(assetQueryFire == false || assetQueryFire == null)
        {
            //value will be null on first time page load
            if(selectedRegVal == null)
            {    
                selectedRegVal = [SELECT Name FROM dpklightning__MAM_Region__c LIMIT 1].Id;
                selectedAssVal = [SELECT name FROM dpklightning__MAM_Assets__c WHERE dpklightning__Region__r.id=: selectedRegVal LIMIT 1].id;
            }
            else //value will not be null, if the page has already loaded.
            {
                selectedRegVal = this.getselectedRegion();
                //if the asset has not changed, just the region has changed
                if(regionQueryFire == true)
                    selectedAssVal = [SELECT name FROM dpklightning__MAM_Assets__c WHERE dpklightning__Region__r.id=: selectedRegVal LIMIT 1].id;
                else
                    //fetch the value of the asset here, as page has already been loaded.
                    selectedAssVal = this.getselectedAsset();
            }
        }
        
        prodWrapList = new List<ProductWrapper>();
        prodWrapList.clear();
        for(Product2 prod : [SELECT id, Name, dpklightning__Asset__c, ProductCode, Description, isActive, dpklightning__Multi__c 
                                FROM Product2 
                                WHERE dpklightning__Asset__r.Id =: selectedAssVal])
        {
            if(prodselectedSet.contains(prod.Id))
                prodWrapList.add(new ProductWrapper(true, prod));
            else
                prodWrapList.add(new ProductWrapper(false, prod));
        }
        return prodWrapList;
    }

    public List<Product2> getSelectProd()
    {
        selectedProdList.clear();
        //First we query if there are already any productIds on the Opportunity
        if(OpptyRec.Id != null)
        {
            String OpptyProdId = [SELECT ProductIds__c FROM Opportunity WHERE id =: OpptyRec.Id LIMIT 1].ProductIds__c;
            productIds = (Set<String>)JSON.deserialize(OpptyProdId, Set<String>.class);
            if(!productIds.isEmpty())
                for(Product2 prod : [SELECT id, Name, dpklightning__Asset__c, ProductCode, Description, isActive, dpklightning__Multi__c
                                    FROM Product2
                                    WHERE id IN : productIds])
                {
                    selectedProdList.add(prod);
                }
        }
        if(!prodselectedSet.isEmpty())
            for(Product2 p : [SELECT id, Name, Description, ProductCode, dpklightning__Asset__c,isActive, dpklightning__Multi__c 
                                FROM Product2
                                WHERE id IN : prodselectedSet])
            {
                if(!productIds.isEmpty())
                    if(productIds.contains(p.Id))
                    {
                        //DO NOT ADD TO THE selectedProdList
                    }
                    else
                    {
                        selectedProdList.add(p);
                    }
                else
                    selectedProdList.add(p);
            }
        
        return selectedProdList;
    }

    public PageReference Save(){
        List<dpklightning__MAM_Product_Relationships__c> opptyProdList = new List<dpklightning__MAM_Product_Relationships__c>();
        //This contains all the newly added products
        String selproductIds = JSON.serialize(prodselectedSet);
        //productIds - is a set which contains already added products.
        // we need to add the selected products to the productIds set
        for(Integer j=0; j< selectedProdList.size(); j++)
        {
            if(!productIds.contains(selectedProdList[j].Id))
                productIds.add(selectedProdList[j].Id);
        }
        
        if(OpptyRec.Id == null)
        {
            OpptyRec.ProductIds__c = selproductIds;
            insert OpptyRec;
        }
        else
        {
            OpptyRec.ProductIds__c = (String) JSON.serialize(productIds);
            update OpptyRec;
        }
        
        //Insert only those Products to the relationship obect, which are new

        for(Integer i=0; i<selectedProdList.size(); i++){
            
            dpklightning__MAM_Product_Relationships__c opptyProd = new dpklightning__MAM_Product_Relationships__c();
            opptyProd.Opportunity__c = OpptyRec.Id;
            opptyProd.Product__c = selectedProdList[i].Id;
            opptyProd.dpklightning__Asset_Class__c = selectedProdList[i].dpklightning__Asset__c;
            opptyProd.dpklightning__AssetProdKey__c = selectedProdList[i].Id+''+selectedProdList[i].dpklightning__Asset__c;
            opptyProdList.add(opptyProd);
        }
        if(!opptyProdList.isEmpty())
            upsert opptyProdList dpklightning__AssetProdKey__c;

        PageReference pg = new PageReference('/'+OpptyRec.Id);
        pg.setRedirect(true);
        return pg;
    }

    //Inner wrapper class
    public class ProductWrapper{
        public Boolean selector {get; set; }
        public Product2 prodObj {get; set; }
        public ProductWrapper(Boolean check, Product2 prod){
            selector = check;
            prodObj = prod;
        }
    }

}
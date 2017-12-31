/**
* This class is a utility class for WebServices and other API classes

*/
global with sharing class APIUtils {
    global final static Integer STATUS_OK = 200;
    global final static Integer STATUS_CREATED = 201;
    global final static Integer STATUS_ACCEPTED = 202;
    global final static Integer STATUS_BAD = 400;
    global final static Integer STATUS_FORBIDDEN = 403;
    global final static Integer STATUS_NOTFOUND = 404;
    global final static Integer STATUS_NOTALLOWED = 405;
    global final static Integer STATUS_ISE = 500;
 
    public virtual class UnknownException extends Exception {}
 
    /**
    * This class is an abstraction of the MyObject__c object
    */
    global class APIMyObject {
        WebService Integer returnCode;
        WebService String message;
 
        WebService String name;
        WebService Boolean isAwesome;
        WebService String myField;
 
        /**
        * A blank constructor
        */
        public APIMyObject() {}
 
        /**
        * A constructor based on MyObject__c
        * @param o My Object
        * @param awesomeness Is the object awesome
        */
        public APIMyObject(MyObject__c o, Boolean awesomeness) {
            this.name = o.Name;
            this.myField = o.MyField__c;
            this.isAwesome = awesomeness;
        }
 
        /**
        * A constructor based on MyObject__c
        * @param o My Object
        */
        public APIMyObject(MyObject__c o) {
            this(o, true);
        }
    }
 
    /**
    * This class is list of APIMyObjects
    */
    global class APIMyObjects {
        WebService Integer returnCode;
        WebService String message;
 
        WebService List<APIMyObject> myObjects;
 
        /**
        * A blank constructor
        */
        public APIMyObjects() {}
 
        /**
        * A constructor based on a list of MyObject__c
        */
        public APIMyObjects(List<MyObject__c> objList) {
            this.myObjects = new List<APIMyObject>();
            for (MyObject__c o: objList) {
                this.myObjects.add(new APIMyObject(o));
            }
        }
    }
}

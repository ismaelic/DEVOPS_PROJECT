/**
 * @description Quality Clouds Scan Controller class whit connections to Flows
// Test Class Test_Run_QualityClouds_Scan_Controller
 */
public with sharing class Run_QualityClouds_Scan_Page_Controller {

    /**
     * @description public variables
     */
    public static String repoURL{get;set;}
    public static Instance__c instance;
    
   
     /**
     * @description Quality Cloud Scan whit Invocable for flow
     */
    @InvocableMethod(label= 'Run Scan' description='Run Quality Clouds Scan from Run_QualityClouds_Scan_Page_Controller')
    public static List<String> doScan(List<copado__User_Story__c> userStory){
             
        List<String> result = new List<String>();
        
        Boolean manual= true;
        if(userStory[0].copado__Cancellation_Reason__c == 'automatic'){
            manual = false;
        }
        
        try{
            repoURL = [SELECT copado__Project__r.copado__Deployment_Flow__r.copado__Git_Repository__r.copado__URI__c 
                        FROM copado__User_Story__c 
                        WHERE Id = :userStory[0].id].copado__Project__r.copado__Deployment_Flow__r.copado__Git_Repository__r.copado__URI__c;
    
            repoURL = '%' + repoURL.substringAfterLast('/');
        
            instance = [SELECT url__c, 
                            Description__c, 
                            ID__c, 
                            Environment_Type__c, 
                            Instance_Type__c, 
                            Is_Featured_Banch__c, 
                            Id 
                        FROM Instance__c 
                        WHERE Is_Featured_Banch__c = true
                        AND url__c 
                        LIKE :repoURL 
                        ORDER BY CreatedDate DESC LIMIT 1];

            if(instance != null){
                globalCallsToQC globalCallsToQCObj = new globalCallsToQC();
                if(!Test.isRunningTest()){
                    String success = globalCallsToQCObj.execute_scann(instance, 'feature/' + [SELECT Name FROM copado__User_Story__c WHERE Id = :userStory[0].id].Name, manual);
                    result.add(success);
                }
            }
        }catch(QueryException e) {
            result.add('Failure');
        }
        return result;  
    }
}
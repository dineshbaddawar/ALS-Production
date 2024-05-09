@isTest
public class LeadStageUpdateControllerTest {
    /*
     @isTest static void Testmy(){
        test.startTest();
        LeadStageUpdateController.mytest();
        test.stopTest();
    }
   */ 
    
    @isTest
    static void testUpdateStageToAudit() {
        
        Lead__c leadRecord = new Lead__c();
        leadRecord.First_Name__c = 'Anwar';
        leadRecord.Name = 'Chikle';
        leadRecord.Company__c = 'Test';
        leadRecord.Region__c = 'South';
        leadRecord.Vertical_Segment__c = 'Pharma';
        leadRecord.Email__c = 'tina.g@gmail.com';
        Insert leadRecord;
        leadRecord.Sub_Stage__c ='Audit';
        leadRecord.Lead_Status__c = 'Audit';
        leadRecord.Audited__c = true;
        Time myTime = Time.newInstance(1, 2, 3, 0);
        leadRecord.Audit_Date__c = system.today();
        leadRecord.Audit_Time__c = myTime;
        leadRecord.Audit_Location__c = 'Bengaluru';
        leadRecord.Audit_Notes__c = 'NA';
        update leadRecord;
        Stakeholder_Details__c shdRecord = new Stakeholder_Details__c(Lead__c = leadRecord.Id);
        insert shdRecord;
        
        LeadStageUpdateController.updateStageToAudit(leadRecord.Id);
        LeadStageUpdateController.updateStageToJunk(leadRecord.Id);
        LeadStageUpdateController.fetchStakeHolderDetails(leadRecord.Id);
    }
  
}
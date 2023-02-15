/*Function: Prevents the Service_Request__c Name field is modified*/

trigger secureSRName on Service_Request__c (before insert, before update) {
    for (Service_Request__c newSR : Trigger.new)
    {
   
        if (Trigger.isUpdate) 
        {
            Service_Request__c oldSR = Trigger.oldMap.get(newSR.Id);
            if (oldSR.Name != newSR.Name)
            {
                newSR.Name = oldSR.Name;
            }
        }
        else// Is insert
        {
            Integer MaxLength = 80;
            RecordType rt = [Select Id, Name From RecordType Where Id =:newSR.RecordTypeId Limit 1]; 
            String opportunityName = [Select Name From Opportunity Where Id=:newSR.Opportunity__c].Name;
            String name = rt.Name + ' - ' + opportunityName;
            if (name.length() > MaxLength)name = name.substring(0,MaxLength);
            newSR.Name = name;
        }
    }
}
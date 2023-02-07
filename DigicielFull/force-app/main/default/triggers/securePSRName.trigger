/*Function: Prevents the Pre_Sales_Request__c Name field is modified*/

trigger securePSRName on Pre_Sales_Request__c (before insert, before update)
{
    for (Pre_Sales_Request__c newPSR : Trigger.new)
    {
        if (Trigger.isUpdate) 
        {
            Pre_Sales_Request__c oldPSR = Trigger.oldMap.get(newPSR.Id);
            if (oldPSR.Name != newPSR.Name)
            {
                newPSR.Name = oldPSR.Name;
            }
        }
        else// Is insert
        {
            RecordType rt = [Select Id, Name From RecordType Where Id =:newPSR.RecordTypeId Limit 1]; 
            String opportunityName = [Select Name From Opportunity Where Id=:newPSR.Opportunity__c].Name;
            String name = rt.Name + ' - ' + opportunityName;
            if(name.length() > 80) name = name.substring(0,80);
            newPSR.Name = name;
        }
        
       
    }
}
/*Function: Prevents the Service_Delivery_Updates__c Name field is modified*/

trigger secureSDUName on Service_Delivery_Updates__c (before insert, before update) {
    for (Service_Delivery_Updates__c newSDU : Trigger.new)
    {
        if (Trigger.isUpdate) 
        {
            Service_Delivery_Updates__c oldSDU = Trigger.oldMap.get(newSDU.Id);
            if (oldSDU.Name != newSDU.Name)
            {
                newSDU.Name = oldSDU.Name;
            }
        }
        else// Is insert
        {
            String srName = [Select Name From Service_Request__c Where Id=:newSDU.Service_Request__c].Name;
            Datetime currentDate = Datetime.now();
            String currentDateStr = currentDate.format('dd-MM-yyyy');
            String name = srName + ' - ' + currentDateStr;
            if(name.length() > 80) name = srName.substring(0,67) + ' - ' + currentDateStr;
            newSDU.Name = name;
        }
    }
}
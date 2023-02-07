/*Function: Prevents the Pre_Sales_Update__c Name field is modified*/

trigger securePSUName on Pre_Sales_Update__c (before insert, before update) {
    for (Pre_Sales_Update__c newPSU : Trigger.new)
    {
        if (Trigger.isUpdate) 
        {
            Pre_Sales_Update__c oldPSU = Trigger.oldMap.get(newPSU.Id);
            if (oldPSU.Name != newPSU.Name)
            {
                newPSU.Name = oldPSU.Name;
            }
        }
        else// Is insert
        {
            String psrName = [Select Name From Pre_Sales_Request__c Where Id=:newPSU.Pre_Sales_Request__c].Name;
            Datetime currentDate = Datetime.now();
            String currentDateStr = currentDate.format('dd-MM-yyyy');
            String name = psrName + ' - ' + currentDateStr;
            if(name.length() > 80) name = psrName.substring(0,67) + ' - ' + currentDateStr;
            newPSU.Name = name;
        }
    }
}
trigger QuoteCheck on Quote (Before Insert) {

For (Quote Q : Trigger.new){

    //Below code queries the Opportunity associated to the Quote
    Opportunity O = [Select ID, StageName from Opportunity where ID = :Q.OpportunityID];
    
        // Checks the Opportunity Stage, this is where you add values to have the trigger cause an error.
        If(O.StageName == 'Business Needs Discovery'){
        
        // Adds the error, modify the text in quotes to change the error message. You can modify the 
        // Field after the Q to display the error in a different location.
        // IE: To display it on the page just change it to Q.Adderror etc..
        Q.Name.AddError('You cannot save the Quote. The Revenue validation must be done. Please submit for approval');
        
                        }
        If(O.StageName == 'Prospecting & Qualification')  {
        Q.Name.AddError('You cannot save the Quote. The Revenue validation must be done. Please submit for approval' );       
                                          }
         If(O.StageName == 'Solution Design')  {
        Q.Name.AddError('You cannot save the Quote. The Revenue validation must be done. Please submit for approval');       
                                          }
         
         If(O.StageName == 'Proposal Preparation')  {
        Q.Name.AddError('You cannot save the Quote. The Revenue validation must be done. Please submit for approval');       
                                          }  
         If(O.StageName == 'Revenue Validation')  {
        Q.Name.AddError('You cannot save the Quote. The Revenue validation must be done. Please submit for approval');       
                                          }                                        
               }
               
}
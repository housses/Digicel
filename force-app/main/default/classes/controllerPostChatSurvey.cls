public class controllerPostChatSurvey {
  
  public Boolean showQ1 {get; set;}
  public Boolean showQ2 {get; set;}
  public Boolean showQ3 {get; set;}
  
  public String answerQ1 {get; set;}
  public String answerQ2 {get; set;}
  public String answerQ3 {get; set;}
  
  public Boolean showCommentsQ1 {get; set;}
  public Boolean showCommentsQ2 {get; set;}
  public Boolean showCommentsQ3 {get; set;}
  
  public String commentsQ1 {get; set;}
  public String commentsQ2 {get; set;}
  public String commentsQ3 {get; set;}
  
  public Boolean showSuccess {get; set;}
  public Boolean showError {get; set;}
  
  public String errorMessage {get; set;}
  
  public String attachedRecords {get; set;}
  private Id caseId;
  
  private Post_Chat_Survey__c survey;
  
  public controllerPostChatSurvey(){
    errorMessage='There was a problem while saving your response, no related chat was found.';
    caseId=null;
    if( ApexPages.currentPage().getParameters().containsKey('attachedRecords')){
      attachedRecords = ApexPages.currentPage().getParameters().get('attachedRecords');      
    }
    
    if(attachedRecords!=null && attachedRecords.contains('"Case":"')){
      caseId = attachedRecords.substring(attachedRecords.indexOf('"Case":"') + 8, attachedRecords.indexOf('"Case":"') + 26);
    }else{
      showError=true;
      errorMessage='Thank you for your query. Hope it was attended successfully, due to an issue the post-chat survey cannot be displayed at the moment.';
    }
    
    /*if( ApexPages.currentPage().getParameters().containsKey('ar')){
      attachedRecords = ApexPages.currentPage().getParameters().get('ar');
      try{
        caseId = attachedRecords.substring(attachedRecords.indexOf('"Case":"') + 8, attachedRecords.indexOf('"Case":"') + 26);
      }catch(System.Exception e){
        showError=true;
        errorMessage='Thank you for your query. Hope it was attended successfully, due to an issue the post-chat survey cannot be displayed at the moment.';
      }
    }
    
    if(caseId!=null){
      survey = new Post_Chat_Survey__c(Case__c = caseId);
      try{
        insert survey;
      }catch(System.Exception e){
        showError=true;
        errorMessage='Survey could not be created due to the following error: '+e.getMessage();
      }
    }*/
    
    showQ1=true;
    showQ2=false;
    showQ3=false;
    
    answerQ1='- No Response -';
    answerQ2='- No Response -';
    answerQ3='- No Response -';
    
    showCommentsQ1=false;
    showCommentsQ2=false;
    showCommentsQ3=false;
    
    commentsQ1 = '';
    commentsQ2 = '';
    commentsQ3 = '';
    
    showSuccess=false;
    
  }
  
  public void createSurvey(){
    if(caseId!=null){
      survey = new Post_Chat_Survey__c(Case__c = caseId);
      try{
        insert survey;
      }catch(System.Exception e){
        showError=true;
        errorMessage='Survey could not be created due to the following error: '+e.getMessage();
      }
    }
  }
    
    public List<SelectOption> getOptionsQ1(){
      List<SelectOption> optionsQ1 = new List<SelectOption>();
      optionsQ1.add(new SelectOption(' - No Response - ', ' - No Response - '));
      optionsQ1.add(new SelectOption('Yes', 'Yes'));
      optionsQ1.add(new SelectOption('No', 'No'));
      
      return optionsQ1;
    }
    
    public List<SelectOption> getOptionsQ2(){
      List<SelectOption> optionsQ2 = new List<SelectOption>();
      optionsQ2.add(new SelectOption(' - No Response - ', ' - No Response - '));
      optionsQ2.add(new SelectOption('Excellent', 'Excellent'));
      optionsQ2.add(new SelectOption('Very Good', 'Very Good'));
      optionsQ2.add(new SelectOption('Good', 'Good'));
      optionsQ2.add(new SelectOption('Fair', 'Fair'));
      optionsQ2.add(new SelectOption('Poor', 'Poor'));
      
      return optionsQ2;
    }
    
    public List<SelectOption> getOptionsQ3(){
      List<SelectOption> optionsQ3 = new List<SelectOption>();
      optionsQ3.add(new SelectOption(' - No Response - ', ' - No Response - '));
      optionsQ3.add(new SelectOption('Yes', 'Yes'));
      optionsQ3.add(new SelectOption('No', 'No'));
      
      return optionsQ3;
    }
    
    public void refreshQ1(){
      if(answerQ1 == 'No') showCommentsQ1=true;
      else  showCommentsQ1=false;
      
      //if(!showQ1) showCommentsQ1=false;
    }
    
    public void refreshQ2(){
      if(answerQ2 == 'Poor' || answerQ2 == 'Fair') showCommentsQ2=true;
      else  showCommentsQ2=false;
      
      //if(!showQ2) showCommentsQ2=false;
    }
    
    public void refreshQ3(){
      if(answerQ3 == 'Yes') showCommentsQ3=true;
      else  showCommentsQ3=false;
      
      //if(!showQ3) showCommentsQ3=false;
    }
    
    public void toQ1(){
      showQ1=true;
      showQ2=false;
      showQ3=false;
    }
    
    public void toQ2(){
      showQ2=true;
      showQ1=false;
      showQ3=false;
    }
    
    public void toQ3(){
      showQ3=true;
      showQ2=false;
      showQ1=false;
    }
    
    public PageReference save(){
      if(survey != null){
        survey.Was_your_query_resolved__c = answerQ1;
        survey.If_Query_resolved_is_No_why__c = commentsQ1;
        survey.Please_rate_your_customer_experience__c = answerQ2;
        survey.If_Customer_experience_is_Fair_or_Poor__c = commentsQ2;
        survey.Additional_Comments_or_Feedback_needed__c = answerQ3;
        survey.Additional_Comments_or_Feedback__c = commentsQ3;
        
        update survey;
        showSuccess=true;
      showQ1=false;
      showQ2=false;
      showQ3=false;
        return null;
      }
      showError=true;
      return null;
    }
}
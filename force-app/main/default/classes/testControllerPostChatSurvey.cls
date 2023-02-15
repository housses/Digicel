@IsTest (seeAllData=false)
public class testControllerPostChatSurvey {
    static testMethod void myUnitTest() {
      Case testCase = new Case();
      insert testCase;
      
      controllerPostChatSurvey controller = new controllerPostChatSurvey();
      controller.save();
      
      PageReference testPage = Page.vfPostChatSurvey;
      testPage.getParameters().put('attachedRecords','"Case":"'+testCase.Id+'"');
      Test.setCurrentPage(testPage);
      
      controller = new controllerPostChatSurvey();
      controller.answerQ1 = 'No';
      controller.answerQ2 = 'Poor';
      controller.answerQ3 = 'Yes';
      
      controller.refreshQ1();
      controller.refreshQ2();
      controller.refreshQ3();
      
      controller.answerQ1 = 'Yes';
      controller.answerQ2 = 'Excellent';
      controller.answerQ3 = 'No';
      
      controller.refreshQ1();
      controller.refreshQ2();
      controller.refreshQ3();
      
      controller.toQ1();
      controller.toQ2();
      controller.toQ3();
      
      controller.save();
      
      List<SelectOption> options = controller.getOptionsQ1();
      options = controller.getOptionsQ2();
      options = controller.getOptionsQ3();
    }
}
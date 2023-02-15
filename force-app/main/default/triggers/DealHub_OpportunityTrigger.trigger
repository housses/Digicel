trigger DealHub_OpportunityTrigger on Opportunity (after update) {

    DealHub_SubscriptionUtils.oppSubscriptionHandler(trigger.new, trigger.oldMap);
}
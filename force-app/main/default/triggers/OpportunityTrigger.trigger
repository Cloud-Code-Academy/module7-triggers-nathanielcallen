trigger OpportunityTrigger on Opportunity (before update, before delete) {
    if (trigger.isBefore) {    
        if (trigger.isUpdate) {
            for (Opportunity opp : trigger.new) {
                if(opp.Amount < 5000 ){
                    opp.addError('Opportunity amount must be greater than 5000');
                }
                        
            }
            Map<Id,Contact> contactsMap = new Map<Id,Contact>([SELECT Id, AccountId, Title FROM Contact WHERE Title = 'CEO']);
            Map<Id,Id> accountToContactsMap = new Map<Id,Id>();
            for (Id conId : contactsMap.keySet()) {
                accountToContactsMap.put(contactsMap.get(conId).AccountId,conId);
            }
            List<Contact> primaryContacts = new List<Contact>();
            for (Opportunity opp : trigger.new) {
                if (accountToContactsMap.keySet().contains(opp.AccountId)) {
                    opp.Primary_Contact__c = accountToContactsMap.get(opp.AccountId);
                }
            }
            
        }
        else if (trigger.isDelete) {
            Map<Id, Account> accountsMap  = new Map<Id,Account>([
                SELECT Id, Industry
                FROM Account
                WHERE Industry = 'Banking']
                );

            for (Opportunity opp : trigger.old){
                if (opp.StageName == 'Closed Won' && accountsMap.keySet().contains(opp.AccountId)) {
                    opp.addError('Cannot delete closed opportunity for a banking account that is won');
                }
            }
            
        }
    }
}
/*
    * Question 7
    * Opportunity Trigger
    * When an opportunity is updated set the primary contact on the opportunity to the contact on the same account with the title of 'CEO'.
    * Trigger should only fire on update.
    */
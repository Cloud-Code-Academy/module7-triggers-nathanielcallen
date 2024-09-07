trigger AccountTrigger on Account (before insert, after insert) {
    if (trigger.isBefore) {
        for (Account acc : Trigger.new) {
            if(acc.Type == null){
                acc.Type = 'Prospect';
            }
            if (acc.ShippingStreet != null &&
                    acc.ShippingCity != null &&
                    acc.ShippingState != null &&
                    acc.ShippingCountry != null &&
                    acc.ShippingPostalCode != null) {
                acc.BillingStreet = acc.ShippingStreet;
                acc.BillingCity = acc.ShippingCity;
                acc.BillingState = acc.ShippingState;
                acc.BillingPostalCode = acc.ShippingPostalCode;
                acc.BillingCountry = acc.ShippingCountry;            
            }
            if (acc.Website != null &&
                acc.Fax != null &&
                acc.Phone != null) {
                acc.Rating = 'Hot';
            }
        }
    }        
    if (trigger.isAfter) {
        List<Contact> myContacts = new List<Contact>();
        for (Account acc : Trigger.new){            
            Contact myContact = new Contact();
            myContact.AccountId = acc.Id;
            myContact.LastName = 'DefaultContact';
            myContact.Email = 'default@email.com';
            myContacts.add(myContact);
        }
        insert myContacts;
    }
    
}


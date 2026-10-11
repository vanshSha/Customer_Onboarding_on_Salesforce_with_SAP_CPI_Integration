public class CustomerOnboardingService {

    public static void processNewAccounts(List<Account> accounts) {

        List<Account> accountsToUpdate = new List<Account>();
        Set<Id> accountIds = new Set<Id>();

        for (Account acc : accounts) {

            if (String.isNotBlank(acc.Name)
                && String.isNotBlank(acc.Phone)
                && String.isNotBlank(acc.BillingCountry)) {

                accountsToUpdate.add(new Account(
                    Id = acc.Id,
                    CPI_Sync_Status__c = 'Pending'
                ));

                accountIds.add(acc.Id);
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
            System.enqueueJob(
                new CustomerOnboardingQueueable(accountIds)
            );
        }
    }
}
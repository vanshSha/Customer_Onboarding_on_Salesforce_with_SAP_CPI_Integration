public class AccountTriggerHandler {

    public static void validateDuplicateAccounts(List<Account> accounts) {

        Set<String> phoneNumbers = new Set<String>();

        for (Account acc : accounts) {
            if (String.isNotBlank(acc.Phone)) {
                phoneNumbers.add(acc.Phone);
            }
        }

        if (phoneNumbers.isEmpty()) {
            return;
        }

        Map<String, Account> existingAccountsByPhone = new Map<String, Account>();

        for (Account existingAccount : [
            SELECT Id, Name, Phone
            FROM Account
            WHERE Phone IN :phoneNumbers
        ]) {
            existingAccountsByPhone.put(existingAccount.Phone, existingAccount);
        }

        Set<String> phonesSeenInTransaction = new Set<String>();

        for (Account acc : accounts) {

            if (String.isBlank(acc.Phone)) {
                continue;
            }

            if (existingAccountsByPhone.containsKey(acc.Phone)) {

                acc.addError(
                    'An Account with this Phone already exists: '
                    + acc.Phone
                );

            } else if (phonesSeenInTransaction.contains(acc.Phone)) {

                acc.addError(
                    'Duplicate Account Phone in this transaction: '
                    + acc.Phone
                );

            } else {

                phonesSeenInTransaction.add(acc.Phone);
            }
        }
    }


    public static void handleAfterInsert(List<Account> accounts) {
        CustomerOnboardingService.processNewAccounts(accounts);
    }
}
trigger AccountTrigger on Account (before insert, after insert) {

    if (Trigger.isBefore && Trigger.isInsert) {
        AccountTriggerHandler.validateDuplicateAccounts(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        AccountTriggerHandler.handleAfterInsert(Trigger.new);
    }
}
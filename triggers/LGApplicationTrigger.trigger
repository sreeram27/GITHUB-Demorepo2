/*
 * Trigger Name: LGApplicationTrigger
 * Current Version: 1.0
 * Created Date: October 2019
 * Author: Archima
 * Description: This trigger processes inserts of LG Application platform events.
 */
trigger LGApplicationTrigger on LG_Application__e (after insert) {

    if (Trigger.isInsert && Trigger.isAfter) {
        LGApplicationTriggerHandler.onAfterInsert(Trigger.new);
    }

}
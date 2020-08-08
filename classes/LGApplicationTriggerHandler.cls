/*
 * Class Name: LGApplicationTriggerHandler
 * Current Version: 1.0
 * Created Date: October 2019
 * Author: Archima
 * Description: This class handles processing for the LG Application platform event trigger.
 */
public with sharing class LGApplicationTriggerHandler {

    public static void onAfterInsert(List<LG_Application__e> lgApplicationEvents) {
        // This code is intentionally calling the Anthem API in a loop.
        // The event API is not bulkified and thus a future method per record.
        for (LG_Application__e applicationEvent : lgApplicationEvents) {
            AnthemAPI.postEvent(JSON.serialize(applicationEvent));
        }
    }
}
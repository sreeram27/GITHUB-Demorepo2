/**************************************************************************************
Apex Class Name:  LGRenewalBatchSchedulerTest
Version     : 1.0 
Created Date    : 14 March 2018
* @Author: Deloitte offshore
Function    : Test class for LGRenewalBatchScheduler
Test Class for Scheduling Renewal Batch Apex Class
*************************************************************************************/
@isTest 
public class LGRenewalBatchSchedulerTest extends staticVariableClass
{
 
    static testMethod void testMethodSchedular() 
    {
        
        Test.startTest();

            LGRenewalBatchScheduler Sch = new LGRenewalBatchScheduler();      
           
           string sc=staticVariableClass.String_cronexpression;
           System.assert(sc!='','test');

           system.schedule('Test',sc,Sch);
            
        Test.stopTest();
    }
    }
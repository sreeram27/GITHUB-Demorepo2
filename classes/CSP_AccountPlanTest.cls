/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CSP_AccountPlanTest {

	static Map<String,Object> inputMap {get;set;}
	static Map<String,Object> inputPAMap {get;set;}
	static Account acct {get;set;}
	static Contact con {get;set;}
	static Account_Plan__c ap {get;set;}
	
    static testMethod void testAccountPlan() {
        createAccountPlanData();
        
        Boolean result = CSP_AccountPlan.invokeMethod('RetrieveObjectives',inputMap,new Map<String,Object>(), new Map<String,Object>());
        result = CSP_AccountPlan.invokeMethod('RetrieveSWT',inputMap,new Map<String,Object>(), new Map<String,Object>());
        result = CSP_AccountPlan.invokeMethod('LoadSWT',inputMap,new Map<String,Object>(), new Map<String,Object>());
        result = CSP_AccountPlan.invokeMethod('ExtractActionPlan',inputMap,new Map<String,Object>(), new Map<String,Object>());
        
    }
    
    static testMethod void testAccountPlanAttack() {
        createAccountPlanAttackData();
        
        Boolean result = CSP_AccountPlan.invokeMethod('RetrieveActionPlan',inputPAMap,new Map<String,Object>(), new Map<String,Object>());
        result = CSP_AccountPlan.invokeMethod('RetrieveYear',inputPAMap,new Map<String,Object>(), new Map<String,Object>());
        result = CSP_AccountPlan.invokeMethod('SavePlanAttack',inputPAMap,new Map<String,Object>(), new Map<String,Object>());
        
    }
    
	static void createAccountPlanData() {
    	acct=ANA_UTIL01_TestMethods.createAccount(true);
		inputMap = new Map<String,Object>();
		
		ap = new Account_Plan__c(Account__c=acct.Id);
		insert ap;
				
		CustomerObjective__c cov1 = new CustomerObjective__c(Name='Other', Active__c=true);
		CustomerObjective__c cov2 = new CustomerObjective__c(Name='Implement CDH/Increase Enrollment', Active__c=true);
		CustomerObjective__c cov3 = new CustomerObjective__c(Name='Maintain appropriate balance between out-of-pocket costs & cost management', Active__c=true);
		CustomerObjective__c cov4 = new CustomerObjective__c(Name='Offer high quality cost effective clinical programs', Active__c=true);
		CustomerObjective__c cov5 = new CustomerObjective__c(Name='Deliver a world-class service experience', Active__c=true);
		CustomerObjective__c cov6 = new CustomerObjective__c(Name='Improve medical outcomes', Active__c=true);
		List<CustomerObjective__c> custObjList = new List<CustomerObjective__c> {cov1,cov2,cov3,cov4,cov5,cov6};
		insert custObjList;
		
		//Select Id, Name From SalesObservation__c		
		SalesObservation__c so1 = new SalesObservation__c(Name='Other',Active__c=true);
		SalesObservation__c so2 = new SalesObservation__c(Name='Account Team',Active__c=true);
		SalesObservation__c so3 = new SalesObservation__c(Name='Alignment with Customer Perspective',Active__c=true);
		SalesObservation__c so4 = new SalesObservation__c(Name='Anthem corporate priorities over Client needs',Active__c=true);
		SalesObservation__c so5 = new SalesObservation__c(Name='B2B',Active__c=true);
		SalesObservation__c so6 = new SalesObservation__c(Name='Clinical',Active__c=true);
		List<SalesObservation__c> slsObjList = new List<SalesObservation__c> {so1,so2,so3,so4,so5,so6};
		insert slsObjList;
		
						
		//Root
		inputMap.put('ContextId',acct.Id);
		inputMap.put('userId', UserInfo.getUserId());
		inputMap.put('userName', UserInfo.getUserName());
		inputMap.put('AccountId',acct.Id);
		inputMap.put('Name', acct.Name);
		inputMap.put('PlanDetailsId',ap.Id);
		inputMap.put('DRId_Account_Plan__c',ap.Id);
		inputMap.put('ClientObjectActive',true);
		inputMap.put('BenefitObjectiveType','Benefit Objective');
		
		//PlanDetails
		Map<String,Object> pdMap = new Map<String,Object>();
		pdMap.put('Id',ap.Id);
		pdMap.put('AccountId',acct.Id);
		pdMap.put('AccountName',acct.Name);
		pdMap.put('Name',ap.Name);
		inputMap.put('PlanDetails',pdMap);
		
		//ClientObjectives
		AccountObjective__c ao1 = new AccountObjective__c();
		ao1.Account__c = acct.Id;
		ao1.Account_Plan__c = ap.Id;
		ao1.Description__c = 'Total Rewards';
		ao1.Type__c = 'Total Rewards';
		ao1.Active__c = true;

		AccountObjective__c ao2 = new AccountObjective__c();
		ao2.Account__c = acct.Id;
		ao2.Account_Plan__c = ap.Id;
		ao2.Description__c = 'Client is intending to acquire new companies.';
		ao2.Type__c = 'Corporate';
		ao2.Active__c = true;

		AccountObjective__c ao3 = new AccountObjective__c();
		ao3.Account__c = acct.Id;
		ao3.Account_Plan__c = ap.Id;
		ao3.Description__c = 'Client plans to add 5000 new employees';
		ao3.Type__c = 'Workforce';
		ao3.Active__c = true;

		List<AccountObjective__c> acctObjList = new List<AccountObjective__c> {ao1,ao2,ao3};
		insert acctobjList;
        update acctobjList;
		
		List<Object> cobjList = new List<Object>();
		for(AccountObjective__c ao:acctObjList) {
			Map<String,Object> coObjMap = new Map<String,Object>(); 
			coObjMap.put('ClientObjectiveType', ao.Type__c);
			coObjMap.put('ClientObjectiveDescription', ao.Description__c);
			coObjMap.put('ClientObjectiveId', ao.Id);
			cobjList.add(coObjMap);
		}
		
		Map<String,Object> coMap = new Map<String,Object>();
		coMap.put('ClientObjective', cobjList);
		coMap.put('ClientObjectiveCount',3);
		coMap.put('ClientObjectiveMsgMax',true);
		inputMap.put('ClientObjectives',coMap);
		
		//Benefit Objectives
		
		
		AccountObjective__c bo1 = new AccountObjective__c();
		bo1.Account__c = acct.Id;
		bo1.Account_Plan__c = ap.Id;
		bo1.Description__c = 'Total Rewards';
		bo1.Type__c = 'Benefit Objective';
		bo1.Business_Objective__c = ao1.Id;
		bo1.Name = 'Offer high quality cost effective clinical programs';
		bo1.Objective__c = cov1.Id;
		bo1.External_Id__c = ap.Id + '_' + cov1.Id;
		bo1.Active__c = true;

		AccountObjective__c bo2 = new AccountObjective__c();
		bo2.Account__c = acct.Id;
		bo2.Account_Plan__c = ap.Id;
		bo2.Description__c = 'Client is intending to acquire new companies.';
		bo2.Type__c = 'Benefit Objective';
		bo2.Business_Objective__c = ao2.Id;
		bo2.Name = 'Match the right provider, right treatment at the right time';
		bo2.Objective__c = cov2.Id;
		bo2.External_Id__c = ap.Id + '_' + cov2.Id;
		bo2.Active__c = true;

		AccountObjective__c bo3 = new AccountObjective__c();
		bo3.Account__c = acct.Id;
		bo3.Account_Plan__c = ap.Id;
		bo3.Description__c = 'Client plans to add 5000 new employees';
		bo3.Type__c = 'Benefit Objective';
		bo3.Business_Objective__c = ao3.Id;
		bo3.Active__c = true;
		bo3.Name = 'Other';
		bo3.Other_Objective__c = 'Test Objective';		
		bo3.Objective__c = cov3.Id;
		bo3.External_Id__c = ap.Id + '_' + cov3.Id;
		List<AccountObjective__c> bnftObjList = new List<AccountObjective__c> {bo1,bo2,bo3};
		insert bnftObjList;
		
		
		List<Object> swtList = new List<Object>();
		for(AccountObjective__c aobj:bnftObjList) {
			Map<String,Object> aobjMap = new Map<String,Object>();
			List<Object> swtObjList = new List<Object>();
			for(SalesObservation__c so:slsObjList) {
				Map<String,Object> swtMap = new Map<String,Object>();
				swtMap.put('vlcRank','1');
				swtMap.put('OtherObservation','Test');
				swtMap.put('Evidence','Test');
				swtMap.put('Threat',false);
				swtMap.put('Weakness',true);
				swtMap.put('Strength',true);
				swtMap.put('Observation',so.Name);
				swtMap.put('ExternalId',ap.Id+ '_'+ aobj.Id + '_'+ so.Name);
				swtMap.put('ObjectiveId',aobj.Id);
				swtMap.put('PlanDetailsId',ap.Id);
				swtMap.put('AccountId',acct.Id);
				swtMap.put('Name','Test');
				swtObjList.add(swtMap);
			}
			aobjMap.put('value',swtObjList);
			aobjMap.put('name','Test');
			aobjMap.put('vlcSelected',true);
			swtList.add(aobjMap);
		}
		Map<String,Object> swtsiMap = new Map<String,Object>();
		swtsiMap.put('SWTSI',swtList);
		inputMap.put('SWT',swtsiMap);		
		
		//Action Plan
		List<Action_Plan__c> acctPlanList = new List<Action_Plan__c>();
		for(AccountObjective__c aobj:bnftObjList) {
			Action_Plan__c acctPlan = new Action_Plan__c();
			acctPlan.Benefit_Objective__c = aobj.Id;
			acctPlan.Analytics__c = 'Data Analytics';
			acctPlan.Consumer_Experience__c = 'Member Experience';
			acctPlan.Health_Activation__c = 'Clinical Programs';
			acctPlan.Provider_Optimization__c = 'Network Optimization';
			acctPlan.Account_Plan__c = ap.Id;
			acctPlan.Identified_Gap__c = 'Test';
			acctPlanList.add(acctPlan);
		}
		insert acctPlanList;
		
		List<Object> actPlanBlockList = new List<Object>();
		for(Action_Plan__c ap:acctPlanList) {
			Map<String,Object> actPlanMap = new Map<String,Object>();
            actPlanMap.put('ActionPlanObjectiveId',ap.Benefit_Objective__c);
            actPlanMap.put('ActionPlanOtherObjective','Test');
            actPlanMap.put('ActionPlanObjective',ap.Name);
            actPlanMap.put('ActionPlanAnalytics',ap.Analytics__c);
            actPlanMap.put('ActionPlanConsumerExperience',ap.Consumer_Experience__c);
            actPlanMap.put('ActionPlanProviderOptimization',ap.Provider_Optimization__c);
            actPlanMap.put('ActionPlanHealthActivation',ap.Health_Activation__c);
            actPlanMap.put('ActionPlanIdentifiedGap',ap.Identified_Gap__c);
			actPlanBlockList.add(actPlanMap);
		}	
		Map<String,Object> actPlanBlockMap = new Map<String,Object>();
		actPlanBlockMap.put('ActionPlanBlock',actPlanBlockList);
		inputMap.put('ActionPlan',actPlanBlockMap);	
				
	}    
	
	static void createAccountPlanAttackData() {
    	acct=ANA_UTIL01_TestMethods.createAccount(true);
    	
    	con =ANA_UTIL01_TestMethods.createContact(true,acct.Id);
    	
		inputPAMap = new Map<String,Object>();
		
		ap = new Account_Plan__c(Account__c=acct.Id);
		insert ap;
				
		CustomerObjective__c cov1 = new CustomerObjective__c(Name='Other', Active__c=true);
		CustomerObjective__c cov2 = new CustomerObjective__c(Name='Implement CDH/Increase Enrollment', Active__c=true);
		CustomerObjective__c cov3 = new CustomerObjective__c(Name='Maintain appropriate balance between out-of-pocket costs & cost management', Active__c=true);
		CustomerObjective__c cov4 = new CustomerObjective__c(Name='Offer high quality cost effective clinical programs', Active__c=true);
		CustomerObjective__c cov5 = new CustomerObjective__c(Name='Deliver a world-class service experience', Active__c=true);
		CustomerObjective__c cov6 = new CustomerObjective__c(Name='Improve medical outcomes', Active__c=true);
		List<CustomerObjective__c> custObjList = new List<CustomerObjective__c> {cov1,cov2,cov3,cov4,cov5,cov6};
		insert custObjList;
		
		//Select Id, Name From SalesObservation__c		
		SalesObservation__c so1 = new SalesObservation__c(Name='Other',Active__c=true);
		SalesObservation__c so2 = new SalesObservation__c(Name='Account Team',Active__c=true);
		SalesObservation__c so3 = new SalesObservation__c(Name='Alignment with Customer Perspective',Active__c=true);
		SalesObservation__c so4 = new SalesObservation__c(Name='Anthem corporate priorities over Client needs',Active__c=true);
		SalesObservation__c so5 = new SalesObservation__c(Name='B2B',Active__c=true);
		SalesObservation__c so6 = new SalesObservation__c(Name='Clinical',Active__c=true);
		List<SalesObservation__c> slsObjList = new List<SalesObservation__c> {so1,so2,so3,so4,so5,so6};
		insert slsObjList;
		
						
		//Root
		inputPAMap.put('ContextId',ap.Id);
		inputPAMap.put('userId', UserInfo.getUserId());
		inputPAMap.put('userName', UserInfo.getUserName());
		inputPAMap.put('AccountId',acct.Id);
		inputPAMap.put('Name', acct.Name);
		inputPAMap.put('PlanDetailsId',ap.Id);
		
		
		//ClientObjectives
		AccountObjective__c ao1 = new AccountObjective__c();
		ao1.Account__c = acct.Id;
		ao1.Account_Plan__c = ap.Id;
		ao1.Description__c = 'Total Rewards';
		ao1.Type__c = 'Total Rewards';
		ao1.Active__c = true;

		AccountObjective__c ao2 = new AccountObjective__c();
		ao2.Account__c = acct.Id;
		ao2.Account_Plan__c = ap.Id;
		ao2.Description__c = 'Client is intending to acquire new companies.';
		ao2.Type__c = 'Corporate';
		ao2.Active__c = true;

		AccountObjective__c ao3 = new AccountObjective__c();
		ao3.Account__c = acct.Id;
		ao3.Account_Plan__c = ap.Id;
		ao3.Description__c = 'Client plans to add 5000 new employees';
		ao3.Type__c = 'Workforce';
		ao3.Active__c = true;

		List<AccountObjective__c> acctObjList = new List<AccountObjective__c> {ao1,ao2,ao3};
		insert acctobjList;
		
		
		//Benefit Objectives
		AccountObjective__c bo1 = new AccountObjective__c();
		bo1.Account__c = acct.Id;
		bo1.Account_Plan__c = ap.Id;
		bo1.Description__c = 'Total Rewards';
		bo1.Type__c = 'Benefit Objective';
		bo1.Business_Objective__c = ao1.Id;
		bo1.Name = 'Offer high quality cost effective clinical programs';
		bo1.Objective__c = cov1.Id;
		bo1.External_Id__c = ap.Id + '_' + cov1.Id;
		bo1.Active__c = true;

		AccountObjective__c bo2 = new AccountObjective__c();
		bo2.Account__c = acct.Id;
		bo2.Account_Plan__c = ap.Id;
		bo2.Description__c = 'Client is intending to acquire new companies.';
		bo2.Type__c = 'Benefit Objective';
		bo2.Business_Objective__c = ao2.Id;
		bo2.Name = 'Match the right provider, right treatment at the right time';
		bo2.Objective__c = cov2.Id;
		bo2.External_Id__c = ap.Id + '_' + cov2.Id;
		bo2.Active__c = true;

		AccountObjective__c bo3 = new AccountObjective__c();
		bo3.Account__c = acct.Id;
		bo3.Account_Plan__c = ap.Id;
		bo3.Description__c = 'Client plans to add 5000 new employees';
		bo3.Type__c = 'Benefit Objective';
		bo3.Business_Objective__c = ao3.Id;
		bo3.Active__c = true;
		bo3.Name = 'Other';
		bo3.Other_Objective__c = 'Test Objective';		
		bo3.Objective__c = cov3.Id;
		bo3.External_Id__c = ap.Id + '_' + cov3.Id;
		List<AccountObjective__c> bnftObjList = new List<AccountObjective__c> {bo1,bo2,bo3};
		insert bnftObjList;
		
		//Action Plan
		List<Action_Plan__c> acctPlanList = new List<Action_Plan__c>();
		for(AccountObjective__c aobj:bnftObjList) {
			Action_Plan__c acctPlan = new Action_Plan__c();
			acctPlan.Benefit_Objective__c = aobj.Id;
			acctPlan.Analytics__c = 'Data Analytics';
			acctPlan.Consumer_Experience__c = 'Member Experience';
			acctPlan.Health_Activation__c = 'Clinical Programs';
			acctPlan.Provider_Optimization__c = 'Network Optimization';
			acctPlan.Account_Plan__c = ap.Id;
			acctPlan.Identified_Gap__c = 'Test';
			acctPlanList.add(acctPlan);
		}
		insert acctPlanList;
		
		//SelectActionPlan
		List<Object> sapList = new List<Object>();
		for(Action_Plan__c aobj:acctPlanList) {
			Map<String,Object> apSIMap = new Map<String,Object>();
			apSIMap.put('BenefitObjectiveId',aobj.Benefit_Objective__c);
			apSIMap.put('IdentifiedGap','What are those gap');
			apSIMap.put('ActionPlanId',aobj.Id);
			apSIMap.put('AccountId',acct.Id);
			apSIMap.put('BenefitObjective','Test');
			apSIMap.put('Category','Analytics');
			apSIMap.put('Name',aobj.Analytics__c);
			sapList.add(apSIMap);
		}
		Map<String,Object> sapMap = new Map<String,Object>();		
		sapMap.put('ActionPlanSI',sapList);
		inputPAMap.put('SelectActionPlan',sapMap);
				
		//Contact Who1A-Block
		Map<String,Object> whoMap = new Map<String,Object>();
		whoMap.put('ContactId',con.Id);
		inputPAMap.put('Who1A-Block',whoMap);		
		inputPAMap.put('Who1B-Block',whoMap);		
		inputPAMap.put('Who1C-Block',whoMap);		
		inputPAMap.put('Who1D-Block',whoMap);		
		inputPAMap.put('Who1E-Block',whoMap);		

		//RAYear
		inputPAMap.put('RAYear1',System.today().year());
		inputPAMap.put('RAYear2',System.today().addYears(1).year());
		inputPAMap.put('RAYear3',System.today().addYears(2).year());
		inputPAMap.put('RAYear4',System.today().addYears(3).year());

		//PlanOfAttack
		Map<String,Object> poaMap = new Map<String,Object>();
		poaMap.put('BenefitObjectiveTx','Test');
		poaMap.put('CategoryTx','Analytics');
		poaMap.put('ActionPlanTx','Data Analytics');
		poaMap.put('IdentifiedGapTx','What are those gap');
		
		Set<String> paSet = new Set<String> {'A','B','C','D','E'};		
		for(Integer i=1; i<=4; i++) {
			poaMap.put('Year'+i,System.today().addYears(i-1).year());
			poaMap.put('Year'+i+'FM',System.today().addYears(i-1).year());
			for(String s:paSet) {
				poaMap.put('ByWhen'+i+s+i,System.today().addYears(i-1).year() + '-1-1');
				poaMap.put('ExecutionDate'+i+s+i,System.today().addYears(i-1).year() + '-1-1');
				poaMap.put('Resources'+i+s+i,'Network');
				poaMap.put('OtherResource'+i+s+i,'Test');
				poaMap.put('Action'+i+s+i,'Test');
				
				Map<String,Object> whoConMap = new Map<String,Object>();
				whoConMap.put('Who'+i+s,con.Name);
				poaMap.put('Who'+i+s+'-Block',whoConMap);				
			}			
		}
		inputPAMap.put('PlanOfAttack',poaMap);
	}    	
}
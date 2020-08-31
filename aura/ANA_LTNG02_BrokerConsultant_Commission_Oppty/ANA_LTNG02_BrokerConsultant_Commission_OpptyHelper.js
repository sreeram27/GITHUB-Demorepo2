({
	helperMethod : function() {		
	},
    callServer : function(component, event, helper) {  
      
       //get Related Consultant Values
        this.getBCOptions(component, component.get("v.oppId"));
        
        //get Opportunity Lookup defualt value
        var OppParam = {
            objectName:'Opportunity',
            fld_API_Text: 'Name',
            fld_API_Val:'Id',
            lim:'1',
            fld_API_Search:'Id',
            searchText: component.get("v.oppId"),
            searchSpecific : ''}; // '0014B00000KN5IBQA1'
       this.getDefaultLookup(component,OppParam,'Opportunity');
       
	},    
    getDefaultLookup: function(component,param,type) {		   
            var action = component.get('c.searchDB');
            action.setStorable();
            
            action.setParams({
                objectName : param.objectName,
                fld_API_Text : param.fld_API_Text,
                fld_API_Val : param.fld_API_Val,
                lim : param.lim, 
                fld_API_Search : param.fld_API_Search,
                searchText : param.searchText,
                searchByType : 'SearchById',
                searchSpecific : param.searchSpecific,
                oppId : component.get("v.oppId")
            });
    
            action.setCallback(this,function(a){
                this.handleResponse(a,component,type);
            });
            
            console.log('Server call made');
            $A.enqueueAction(action); 
	},
    getBCOptions: function(component,oppId) {	
        debugger;
            var action = component.get('c.createSelectOptions');
            action.setStorable();            
            action.setParams({
                oppId : oppId                
            });    
            action.setCallback(this,function(a){
                this.handleResponse(a,component,'BCOptions');
            });
            
            console.log('Server BCcall made');
            $A.enqueueAction(action); 
	},
	showWarningMessage: function(component, event, helper) {	
       debugger;
            var dccurrentBrokerageCommission = component.find("spercentId").get("v.value");
			console.log('dccurrentBrokerageCommission: '+ dccurrentBrokerageCommission);
			var action = component.get("c.getBrokerageCommissionSplitTotal");
			action.setParams({  oppId : oppId , dccurrentBrokerageCommission : dccurrentBrokerageCommission});
			action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                console.log('From server: ' + response.getReturnValue());
				component.set("v.showWarning", response.getReturnValue());
				console.log('showWarning: ' + component.get("v.showWarning"));
            }
			else{
				console.log('Unknown error: '+ state);
            }
        });
            $A.enqueueAction(action); 
	},
    saveBrokerandConsult : function(component, event, helper) {
            debugger;
            var action = component.get('c.saveBRRecord');
        	action.setStorable();
            var acc = component.get('v.selAccItem');
        	var br = component.get('v.selBConsultantItem');
        	console.log('BrId:'+component.get("v.selectedBR"));
        	console.log('acc:'+component.get("v.selBConsultantItem"));
            action.setParams({
                oppId : acc.val,
                BrId : br.val,
                newBandConsuComm : component.get("v.newBandConsuComm")      
                
            });    		
            action.setCallback(this,function(a){
                this.handleResponse(a,component,'SaveBC');
                component.set("v.selectstatus", false);
            });
            $A.enqueueAction(action);
		},
     setFundingType: function(component) {
         
         	//get Broker and Consultant Lookup defualt value
			var BrkParam = {
			objectName:'Brokerage_and_Consultant1__c',
			fld_API_Text: 'Name',
			fld_API_Val:'Id',
			lim:'1',
			fld_API_Search:'Id',
			searchText: component.get("v.selectedBR"),
            searchSpecific : 'BrokerConsult'}; // component.get("v.accId") 'a4x4B00000003JIQAY'
			this.getDefaultLookup(component,BrkParam,'BrokerConsultant');         
         
			//get PickList Vaues
			var reObj,fundingtype,paymentMethod,AppliestoOnly,LineOfBusiness;
			var action = component.get('c.getPickListValues');
             
			action.setStorable(); 
			action.setCallback(this,function(a){
			reObj = JSON.parse(a.getReturnValue());
                    
            /****************************Filtering Values ****************************/ 
			fundingtype 	 = reObj.filter(function(r){return r.type == "FundingType"});
			paymentMethod	 = reObj.filter(function(r){return r.type == "PaymentMethod"});
			LineOfBusiness = reObj.filter(function(r){return r.type == "LineOfBusiness"}); 
			AppliestoOnly	 = reObj.filter(function(r){return r.type == "appliyOnly"});   
			fundingtype.unshift({label:'None',type:'None',value:'None'});
			paymentMethod.unshift({label:'None',type:'None',value:'None'});    
                    
            /***************************Setting picklist Values *******************/ 
			component.find("fundingType").set("v.options", fundingtype);
			component.find("paymentMethod").set("v.options", paymentMethod);
			component.find("LineOfBusiness").set("v.options", LineOfBusiness);
			component.find("AppliestoOnly").set("v.options", AppliestoOnly);
        });        
        console.log('Server BCcall made');
        $A.enqueueAction(action); 
	},
    handleResponse : function (res,component,type){  
        debugger;
        if (res.getState() === 'SUCCESS') {            
            var retObj;            
            if(type != 'SaveBC'){
                retObj = JSON.parse(res.getReturnValue());
                console.log("Displaying retObj" + res.getReturnValue() + 'Type: '+type)
                if(retObj.length > 0){            
                    if(type == 'Opportunity'){                    
                        component.set("v.selAccItem",retObj[0]);
                    }                	
                    else if(type  == 'BrokerConsultant'){
                        component.set("v.selBConsultantItem",retObj[0]);
                    } 
                    else if(type == 'BCOptions'){
                        console.log('Entered BCOptions');
                        component.find("selectConsultant").set("v.options", retObj);
                        component.set("v.consultantValues",retObj);
                    }
                    /*else if(type == 'fundingType'){
                        console.log('AllPickLists:'+JSON.stringify(retObj));
                        //component.find("fundingType").set("v.options", retObj);
                	}*/
                }
                else{
                     if(type == 'BCOptions') {                            
                            component.find("selectConsultant").set("v.errors", [{message:"Brokerage and Consultant is required to create Broker/Consultant Commission" }]);
                           	var t1 = component.find("ButtonNext").getElement();
                            $A.util.addClass(t1,"slds-hide");  	                      
                           // t1.set("v.disabled",true);
                        }
                }
            }
            if(type  == 'SaveBC' && res.getReturnValue() != ''){
				var retMessage = res.getReturnValue();
                if(retMessage.length == 18){   
                    
                	//window.location.href = '/'+res.getReturnValue();
                   // window.location.href = fullurl;
                   window.parent.location = '/one/one.app#/sObject/' + res.getReturnValue();
                }
                else{					
					if(retMessage.indexOf('Commission_Percentage__c') !== -1 && retMessage.indexOf('value outside of valid range') !== -1)
                    {
						alert('Broker/Consultant Commision creation failed. \'Commission Percentage\' field value outside of valid range.');
					}
					else if(retMessage.indexOf('Brokerage_Commission_Split__c') !== -1 && retMessage.indexOf('value outside of valid range') !== -1)
                    {
						alert('Broker/Consultant Commision creation failed. \'Brokerage Commission Split %\' field value outside of valid range.');
					}
					else if(retMessage.indexOf('Sub_Groups_Contract_Codes_Package_Code__c') !== -1 && retMessage.indexOf('Please input additional information') !== -1)
                    {
						alert('Broker/Consultant Commision creation failed. Please input additional information when \'Sub-Groups/ Contract Codes/ Package Code\' only applies to a portion of the Group #s');
					}
					else if(retMessage.indexOf('Consultant__c') !== -1 && retMessage.indexOf('Please select an Active Consultant') !== -1)
                    {
						alert('Broker/Consultant Commision creation failed. Please select an Active Brokerage/Consultant from the specified Brokerage Account');
					}
					else if(retMessage.indexOf('Account__c') !== -1 && retMessage.indexOf('Invalid Account selection') !== -1)
                    {
						alert('Broker/Consultant Commision creation failed. Invalid Account selection');
					}
					else if(retMessage.indexOf('Account__c') !== -1 && retMessage.indexOf('Invalid Account selection') !== -1)
                    {
						alert('Broker/Consultant Commision creation failed. Selected Brokerage/Consultant is incorrect');
					}
					else if(retMessage.indexOf('FIELD_INTEGRITY_EXCEPTION') !== -1)
                    {
						alert('Broker/Consultant Commision creation failed. Invalid Account selection');
					}
					else if(retMessage.indexOf('INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY') !== -1)
                    {
						alert('Broker/Consultant Commision creation failed. Insufficient access rights on cross-reference field values');
					}
                    else if(retMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION') !== -1)
                    {
						alert('Broker/Consultant Commision record creation failed.Field Custom Validation encountered. You have answered No to Applies to only a portion of group #?. Please review your response.');
					}
					else{
						alert('Broker/Consultant Commision creation failed.');
						//window.location.href = '/'+component.get('v.accId');
                         window.parent.location = '/one/one.app#/sObject/' + component.get("v.accId");
					}					
                    $A.util.addClass(component.find("ShowingspinON").getElement(),"slds-hide");
       			    $A.util.removeClass(component.find("ShowingspinOff").getElement(),"slds-hide");
                }
            }
        }
        else if (res.getState() === 'ERROR'){
           
            var errors = res.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    alert(errors[0].message);
                }
            } 
        }
    },
    saveRecordBR: function(component, event, helper)
    {
					var fundingType    = 	component.find("fundingType"); 
					var Lofb		   = 	component.find("LineOfBusiness");
					var fundingTypeval = 	fundingType.get("v.value");
					var Lofbvalue	   = 	Lofb.get("v.value");
					var paymentMethod  = 	component.find("paymentMethod");
					var paymethodval   = 	paymentMethod.get("v.value");
					var commstartDate  = 	component.find("commstartDate");
					var commendDate    =    component.find("enddate");
					var commstartval   = 	commstartDate.get("v.value"); 
					var commendval     = 	commendDate.get("v.value");
					var Account_lookup = 	component.find("Opportunity_lookup");
					var Accountval     = 	Account_lookup.get("v.selItem");
					var broker_lookup  =  	component.find("broker_lookup");
					var brokerval      =  	broker_lookup.get("v.selItem");
					var GroupNo   	   =	component.find("GroupNumbers");
					var Groupval       = 	GroupNo.get("v.value");
              
        
                    if(Accountval === null )
                        component.set("v.selectAccount", true);  
                    else
                        component.set("v.selectAccount", false);  
                    
                    
                    if(brokerval === null )
                        component.set("v.selectBroker", true);  
                    else
                        component.set("v.selectBroker", false);  
                    
      				 if(Lofbvalue === "None" )
                        Lofb.set("v.errors", [{message:"Please Select Line of Business value " }]);
                    else
                        Lofb.set("v.errors", null);
        
        
                      if(fundingTypeval === "None" )
                        fundingType.set("v.errors", [{message:"Please Select Funding Type " }]);
                    else
                        fundingType.set("v.errors", null);
        
        
                    if(paymethodval === "None"  )
                        paymentMethod.set("v.errors", [{message:"Please Select Payment Method " }]);
                    else
                        paymentMethod.set("v.errors", null);
                     
                    if(Groupval === "" || Groupval == null)
                    	component.set("v.selectGroupNumber", true);  
                    else
                        component.set("v.selectGroupNumber", false);
                    
                    if(commstartval === "" )
                        commstartDate.set("v.errors", [{message:"Please Enter Commision Start Date " }]);
                    else if (Date.parse(commstartval))   
                        commstartDate.set("v.errors", null);
                     else
                        commstartDate.set("v.errors", [{message:"Please Enter Commision Start Date " }]);
					
					
					if (Date.parse(commendval) || commendval === "")  
					    commendDate.set("v.errors", null)
					else
					    commendDate.set("v.errors", [{message:"Please Enter Date in correct format " }]);
					
					
					
                    
        		 if( Accountval != null   && brokerval != null && fundingTypeval != "None" && Lofbvalue !="None" && paymethodval != "None" && commstartval != "" && Groupval != "" )
                    if(Date.parse(commstartval)  && (Date.parse(commendval) || commendval === "" ))
                    {
                     var t1 = component.find("ShowingspinON").getElement();
                     console.log(t1);   
       				 var t2 = component.find("ShowingspinOff").getElement();
                     console.log(t2);   
                     $A.util.removeClass(t1,"slds-hide");
       			     $A.util.addClass(t2,"slds-hide");

                     console.log("spinner activated") 
                     this.saveBrokerandConsult(component,event, helper); 
                      
                    }   
        		     		
                    else 
                        console.log('Error');
    
	},
    initCallServer: function(component, event, helper)
    {
        //var selValue = {val:"0014B00000ONIvyQAH",text:"Acclaris",objName:"Account"}; 
        component.set("v.selectBR", true);
		 console.log('oppId:'+component.get("v.oppId"));
       	 var t1 = component.find("ShowingspinON").getElement();        
       	 $A.util.addClass(t1,"slds-hide");         
        
        if(component.get("v.oppId") != '' && component.get("v.oppId")!= null)
        	helper.callServer(component, event, helper);   
        
    },
    toggleHelper : function(component,event) {
    var toggleText = component.find("tooltip");
    $A.util.toggleClass(toggleText, "toggle");
   }
});
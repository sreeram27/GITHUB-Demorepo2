global class BMSQuotingServiceSalesForce {
    
    webservice SendQuoteReq SendQuoteReq;
    webservice SendQuoteResp SendQuoteResp;
    webservice User User;
    webservice GroupDetails GroupDetails;
    webservice SalesReps SalesReps;
    webservice ZipInfo ZipInfo;
    webservice Members Members;
    webservice Brokers Brokers;
    webservice Benefits Benefits; 
    webservice MedicalFactors MedicalFactors;
    webservice Medical Medical;
    webservice Rate Rate;
    webservice Edition Edition;
    webservice DentalRating DentalRating;
    webservice DentalProduct DentalProduct;
    webservice MedicalProduct MedicalProduct;
    webservice Dental Dental;
    webservice FormulaRates FormulaRates;
    webservice Adjustment Adjustment;
    webservice Presets Presets;
    webservice Option Option;
    webservice BenefitRider BenefitRider;
        
    webservice static SendQuoteResp SendQuote(SendQuoteReq SendQuoteReq) {
        BMSQuotingServiceSalesForceSupporting bmsQuote = new BMSQuotingServiceSalesForceSupporting();
        SendQuoteResp SendQuoteResp =  bmsQuote.SendQuote(SendQuoteReq);
        return SendQuoteResp;  
    }
    global class SendQuoteReq { 
        webservice User User;
    }
    global class SendQuoteResp {
        webservice String ResponseCode;
        webservice String Details;
    }
        global class User {
        webservice GroupDetails GroupDetails;   
    }
    
    global class GroupDetails {
        webservice SalesReps[] SalesReps;
        webservice ZipInfo ZipInfo;
        webservice Members Members;
        webservice Brokers[] Brokers;
        webservice Benefits[] Benefits;
        webservice Presets Presets;
        webservice String name;
        webservice String address;
        webservice String assocID;
        webservice String effectiveDate;
        webservice String pid;
        webservice String parentPid;
        webservice String firstYearDental;
        webservice String vaGroupNumber;
        webservice String accountCode;
        webservice String city;
        webservice String state;
        webservice String countyCode;
        webservice String zip;
        webservice String groupContact;
        webservice String groupMarket;
        webservice String rateAs;
        webservice String sicCode;
        webservice String eMailAddress;
        webservice String wgsCaseNumber;
    }
    
        global class SalesReps {
        webservice String SalesRep;
        webservice String SalesRepID;
        webservice String SalesRepName;
    }
        global class ZipInfo {
        webservice String state;
    }
        global class Members {
        webservice String retireeLives;
        webservice String femaleEmpCovLives;
        webservice String maleEmpCovLives;
        webservice String femaleFamilyCovLives;
        webservice String maleChildCovLives;
        webservice String healthLives;
        webservice String activeLives;
        webservice String femaleChildCovLives;
        webservice String maleSpouseCovLives;
        webservice String maleFamilyCovLives;
        webservice String cobraLives;
        webservice String femaleSpouseCovLives;
        webservice String totalLives;
        webservice String totalMembership;
        webservice String totalMembershipDental;
        webservice String totalMembershipVision;
        webservice String femaleEmpCovLivesDental;
        webservice String maleEmpCovLivesDental;
        webservice String femaleFamilyCovLivesDental;
        webservice String maleChildCovLivesDental;
        webservice String femaleChildCovLivesDental;
        webservice String maleSpouseCovLivesDental;
        webservice String maleFamilyCovLivesDental;
        webservice String femaleSpouseCovLivesDental;
        webservice String averageHealthAge;
        webservice String averageDentalAge;
        webservice String averageVisionAge;
        webservice String censusType;
        webservice String dentalLives;
        webservice String employeeContractCount;
        webservice String employeeChildContractCount;
        webservice String employeeSpouseContractCount;
        webservice String familyContractCount;
        webservice String employeeContractDentalCount;
        webservice String employeeSpouseContractDentalCount;
        webservice String employeeChildContractDentalCount;
        webservice String familyContractDentalCount;
        webservice String familyChildrenContractDentalCount;
        webservice String employeeChildrenContractCount;
        webservice String dentalOutOfStateLives;
        webservice String marketSegment;
        webservice String employeeChildrenContractDentalCount;
        webservice String dentalCensusType;
    }
    
        global class Brokers {
        webservice String brokerID;
        webservice String address1;
        webservice String city;
        webservice String eMail;
        webservice String faxNumber;
        webservice String brokerName;
        webservice String phone;
        webservice String state;
        webservice String zip;
    }

    global class Benefits {
        webservice Rate[] Rates;
        webservice MedicalFactors MedicalFactors;
        webservice Medical Medical;
        webservice Dental Dental;
        webservice DentalRating DentalRating;
        webservice String type_x;
        webservice String allProduct;
        webservice String selected;
        webservice String stdess;
        webservice String amebaRating;
    }
    global class Rate {
        webservice String ageMin;
        webservice String ageMax;
        webservice String sex;
        webservice String coverage;
        webservice String rate;
    }
    global class MedicalFactors {
        webservice FormulaRates FormulaRates;
    }
    
        global class Medical {
        webservice Edition Edition;
        webservice String selected;
    }
    global class Edition {
        webservice MedicalProduct MedicalProduct;
        webservice String editionID;
        webservice String editionDesc;
        webservice String selected;
    }
  global class MedicalProduct {
        webservice Option Option;
        webservice String description;
        webservice String selected;
        webservice String abbreviation;
        webservice String ratePlan;
    }

    global class Dental {
        webservice DentalProduct DentalProduct;
    }
    
       global class DentalRating {
        webservice String TotalMonthlyPremiumValue;
    }
       global class Presets {
        webservice Adjustment[] Adjustment;
        webservice String salesDiscountValue;
    }  

    
    global class Adjustment {
        webservice String product;
        webservice String type_x;
        webservice String factor;
    }

    global class Option {
        webservice BenefitRider[] BenefitRider;
        webservice String description;
        webservice String benefitCode;
        webservice String selected;
        webservice String pcpVisit;
        webservice String specialistVisit;
        webservice String inpatientCoins;
        webservice String inpatientCopay;
        webservice String outpatientCoins;
        webservice String annualOOP;
        webservice String hraAllocation;
        webservice String rewards;
        webservice String pharmacy;
        webservice String outpatientCopay;
    }
    global class BenefitRider {
        webservice String description;
        webservice String selected;
        webservice String rate;
        webservice String planType;
        webservice String riderCode;
    }
  
    global class FormulaRates {
        webservice String premium;
    }
        global class DentalProduct {
        webservice String productID;
        webservice String description;
        webservice String selected;
        webservice String voluntary;
        webservice String productName;
        webservice String network;
        webservice String calYearBenMax;
        webservice String annualDeduct;
        webservice String diagPrevent;
        webservice String minorRestore;
        webservice String primaryServices;
        webservice String majorRestore;
        webservice String ortho;
        webservice String orthoMax;
        webservice String vaIndex;
        webservice String warning;
    }
}
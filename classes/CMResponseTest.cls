/*
 * @author : Legato Health Technologies LLP
 * @Date   : 27 - November - 2019
 * @Description : Test Class for CMStatusUpdateService
 * 
 */ 
@IsTest
public class CMResponseTest {
    
    static testMethod void testParse() {
        String json = '{'+
            '  \"eventMetaData\": {'+
            '    \"userId\": \"af53352\",'+
            '    \"sourceSystemId\": \"CM\",'+
            '    \"trackingId\": \"1212\",'+
            '    \"eventType\": \"Add\",'+
            '    \"masterId\": \"12345\",'+
            '    \"subTrackingId\": \"12345\"'+
            '  },'+
            '  \"responseMsg\": ['+
            '    {'+
            '      \"globalCustomerId\": \"98981234\",'+
            '      \"accountID\": \"77777777\",'+
            '      \"statusCode\": \"SUCCESS\",'+
            '      \"statusMsg\": \"Customer Installed-Preview Ready-or Maintaince Completed\",'+
            '      \"systemID\": \"CM\",'+
            '      \"responseDetails\": {'+
            '        \"listOfErrorCodes\": ['+
            '          {'+
            '            \"category\": \"\",'+
            '            \"errorCode\": \"\",'+
            '            \"bindingField\": \"\",'+
            '            \"entityName\": \"\",'+
            '            \"errorMessage\": \"\"'+
            '          }'+
            '        ],'+
            '        \"accountInfo\": {'+
            '          \"parentInfo\": {'+
            '            \"ids\": ['+
            '              {'+
            '                \"sourceSystem\": \"CM\",'+
            '                \"name\": \"globalCustomerId\",'+
            '                \"value\": \"\"'+
            '              },'+
            '              {'+
            '                \"sourceSystem\": \"WGS\",'+
            '                \"name\": \"linkId\",'+
            '                \"value\": \"\"'+
            '              },'+
            '              {'+
            '                \"sourceSystem\": \"SFDCCOM2\",'+
            '                \"name\": \"accountID\",'+
            '                \"value\": \"0011900000ktHtKAAU\"'+
            '              }'+
            '            ],'+
            '            \"demographic\": {'+
            '              \"organizationName\": {'+
            '                \"name\": \"Kaleidoscope Animations Inc.\",'+
            '                \"dbaName\": \"Kaleidoscope Animations Inc.\"'+
            '              }'+
            '            },'+
            '            \"status\": {'+
            '              \"timeline\": ['+
            '                {'+
            '                  \"status\": \"A\",'+
            '                  \"effectiveDate\": \"2020-01-01\",'+
            '                  \"endDate\": \"9999-12-31\",'+
            '                  \"reasons\": ['+
            '                    {'+
            '                      \"code\": \"\",'+
            '                      \"description\": \"\"'+
            '                    }'+
            '                  ]'+
            '                }'+
            '              ]'+
            '            },'+
            '            \"policyData\": ['+
            '              {'+
            '                \"number\": \"string\",'+
            '                \"name\": \"string\",'+
            '                \"sourceSystem\": \"string\",'+
            '                \"startDate\": \"9999-12-31\",'+
            '                \"endDate\": \"9999-12-31\",'+
            '                \"renewalDate\": \"9999-12-31\",'+
            '                \"policyStatus\": \"string\",'+
            '                \"effectiveDate\": \"9999-12-31\",'+
            '                \"characteristicsLists\": ['+
            '                  {'+
            '                    \"type\": \"StateOfIssue_Code\",'+
            '                    \"value\": \"StateOfIssue_CodeValue\",'+
            '                    \"effectiveDate\": \"9999-12-31\"'+
            '                  }'+
            '                ]'+
            '              }'+
            '            ],'+
            '            \"plans\": ['+
            '              {'+
            '                \"number\": \"string\",'+
            '                \"coverageType\": \"string\",'+
            '                \"startDate\": \"string\",'+
            '                \"endDate\": \"string\",'+
            '                \"effectiveDate\": \"string\"'+
            '              }'+
            '            ]'+
            '          },'+
            '          \"customerInfo\": {'+
            '            \"customers\": ['+
            '              {'+
            '                \"ids\": ['+
            '                  {'+
            '                    \"sourceSystem\": \"CM\",'+
            '                    \"name\": \"customerId\",'+
            '                    \"value\": 11'+
            '                  },'+
            '                  {'+
            '                    \"sourceSystem\": \"WGS\",'+
            '                    \"name\": \"caseId\",'+
            '                    \"value\": 12'+
            '                  },'+
            '                  {'+
            '                    \"sourceSystem\": \"compass\",'+
            '                    \"name\": \"schemeId\",'+
            '                    \"value\": 13'+
            '                  },'+
            '                  {'+
            '                    \"sourceSystem\": \"CM\",'+
            '                    \"name\": \"globalCustomerId\",'+
            '                    \"value\": 14'+
            '                  },'+
            '                  {'+
            '                    \"sourceSystem\": \"SFDC Com2\",'+
            '                    \"name\": \"accountId\",'+
            '                    \"value\": \"0011900000ktHtKAAU\"'+
            '                  }'+
            '                ],'+
            '                \"demographic\": {'+
            '                  \"organizationName\": {'+
            '                    \"name\": \"Kaleidoscope Animations Inc.\",'+
            '                    \"dbaName\": \"Kaleidoscope Animations Inc.\"'+
            '                  }'+
            '                },'+
            '                \"status\": {'+
            '                  \"timeline\": ['+
            '                    {'+
            '                      \"status\": \"A\",'+
            '                      \"effectiveDate\": \"2020-01-01\",'+
            '                      \"endDate\": \"9999-12-31\",'+
            '                      \"reasons\": ['+
            '                        {'+
            '                          \"code\": \"\",'+
            '                          \"description\": \"\"'+
            '                        }'+
            '                      ]'+
            '                    }'+
            '                  ]'+
            '                },'+
            '                \"subGroups\": ['+
            '                  {'+
            '                    \"TargetSystem\": \"\",'+
            '                    \"TargetSystemId\": \"\",'+
            '                    \"groupNumber\": \"\",'+
            '                    \"sfgroupNumber\": \"\",'+
            '                    \"groupName\": \"\",'+
            '                    \"employmentCategoryCode\": \"\",'+
            '                    \"employmentClass\": \"\",'+
            '                    \"contractCode\": \"\",'+
            '                    \"productType\": \"\",'+
            '                    \"productNumber\": \"\",'+
            '                    \"memberProductCode\": \"\",'+
            '                    \"groupSuffixId\": \"\"'+
            '                  }'+
            '                ]'+
            '              }'+
            '            ]'+
            '          },'+
            '          \"accountBillGroups\": ['+
            '            {'+
            '              \"ids\": ['+
            '                {'+
            '                  \"sourceSystem\": \"SFDC Com2\",'+
            '                  \"name\": \"billGroupId\",'+
            '                  \"value\": \"CMBG001\"'+
            '                },'+
            '                {'+
            '                  \"sourceSystem\": \"CM\",'+
            '                  \"name\": \"globalCustomerId\",'+
            '                  \"value\": \"CMBG001\"'+
            '                },'+
            '                {'+
            '                  \"sourceSystem\": \"SF\",'+
            '                  \"name\": \"billGroupId\",'+
            '                  \"value\": \"\"'+
            '                }'+
            '              ],'+
            '              \"demographic\": {'+
            '                \"organizationName\": {'+
            '                  \"name\": \"BILL-000058\",'+
            '                  \"dbaName\": \"\"'+
            '                }'+
            '              },'+
            '              \"billConfig\": {'+
            '                \"billArrangements\": ['+
            '                  {'+
            '                    \"customerId\": \"Any\",'+
            '                    \"productType\": \"Medical\",'+
            '                    \"contractCode\": \"Any\",'+
            '                    \"employmentCategory\": \"Active\",'+
            '                    \"employmentClass\": \"Any\"'+
            '                  },'+
            '                  {'+
            '                    \"customerId\": \"Any\",'+
            '                    \"productType\": \"Dental\",'+
            '                    \"contractCode\": \"Any\",'+
            '                    \"employmentCategory\": \"cobra\",'+
            '                    \"employmentClass\": \"Executive\"'+
            '                  },'+
            '                  {'+
            '                    \"customerId\": \"Any\",'+
            '                    \"productType\": \"Life\",'+
            '                    \"contractCode\": \"Any\",'+
            '                    \"employmentCategory\": \"Active\",'+
            '                    \"employmentClass\": \"Hourly\"'+
            '                  },'+
            '                  {'+
            '                    \"customerId\": \"Any\",'+
            '                    \"productType\": \"Any\",'+
            '                    \"contractCode\": \"V1056\",'+
            '                    \"employmentCategory\": \"Any\",'+
            '                    \"employmentClass\": \"Any\"'+
            '                  }'+
            '                ],'+
            '                \"billLevelParameters\": ['+
            '                  {'+
            '                    \"sourceSystem\": \"WGS\",'+
            '                    \"sequence\": \"1\",'+
            '                    \"billLevel1\": \"LD10001\",'+
            '                    \"billLevel2\": \"M001\",'+
            '                    \"billLevel3\": \"Any\",'+
            '                    \"billLevel4\": \"Any\",'+
            '                    \"billGroupId\": \"Any\",'+
            '                    \"effectiveDate\": \"9999-12-31\",'+
            '                    \"expirationDate\": \"9999-12-31\",'+
            '                    \"contractCD\": \"\",'+
            '                    \"productName\": \"\",'+
            '                    \"productType\": \"\"'+
            '                  },'+
            '                  {'+
            '                    \"sourceSystem\": \"compass\",'+
            '                    \"sequence\": \"2\",'+
            '                    \"billLevel1\": \"CM10000001\",'+
            '                    \"billLevel2\": \"1001-01-ACV35-02\",'+
            '                    \"billLevel3\": \"\",'+
            '                    \"billLevel4\": \"\",'+
            '                    \"billGroupId\": \"\",'+
            '                    \"effectiveDate\": \"2019-11-05\",'+
            '                    \"expirationDate\": \"9999-12-31\",'+
            '                    \"contractCD\": \"\",'+
            '                    \"productName\": \"\",'+
            '                    \"productType\": \"\"'+
            '                  }'+
            '                ],'+
            '                \"billDates\": {'+
            '                  \"paidToDate\": \"9999-12-31\",'+
            '                  \"billToDate\": \"9999-12-31\"'+
            '                }'+
            '              }'+
            '            }'+
            '          ]'+
            '        }'+
            '      }'+
            '    }'+
            '  ]'+
            '}';
        CMResponse r = CMResponse.parse(json);
        System.assert(r != null);
        
        
    }
}
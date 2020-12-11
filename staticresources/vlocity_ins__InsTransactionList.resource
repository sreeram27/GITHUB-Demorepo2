(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var partsLength=parts.length-1;var thisScript=parts[partsLength--];if(thisScript===""){thisScript=parts[partsLength--]}if(scriptName.indexOf("__")!=-1){while(thisScript.indexOf("__")==-1&&partsLength>=0){thisScript=parts[partsLength];partsLength--}}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){
angular.module('insTransactionList', ['vlocity', 'forceng',
    'vlocity-omni-form'
    ]).config(['remoteActionsProvider', function(remoteActionsProvider) {
        'use strict';
        remoteActionsProvider.setRemoteActions(window.remoteActions || {});
    }]).config(['$compileProvider', function ($compileProvider) {
        $compileProvider.debugInfoEnabled(true);
    }]).run(['$rootScope', function($rootScope) {
        'use strict';
        $rootScope.nsPrefix = fileNsPrefix();
        $rootScope.isLoaded = false;
        $rootScope.setLoaded = function(boolean) {
            $rootScope.isLoaded = boolean;
        };
        $rootScope.notification = {
            message: '',
            type: '',
            active: false
        };
    }]).filter('sldsStaticResourceURL', ['$rootScope', function($rootScope) {
        'use strict';
        return function(sldsURL) {
            return $rootScope.staticResourceURL.slds + sldsURL;
        };
    }]);

// Directives
require('./modules/insTransactionList/directive/InsTransactionList.js');

// Templates
require('./modules/insTransactionList/templates/templates.js');



},{"./modules/insTransactionList/directive/InsTransactionList.js":2,"./modules/insTransactionList/templates/templates.js":3}],2:[function(require,module,exports){
(function() {
    'use strict';
    angular.module('insTransactionList')
        .component('insTransactionList', {
            templateUrl: 'ins-transaction-list-template.tpl.html',
            require: {
                ngModelCtrl: 'ngModel'
            },
            bindings: {
                records: '@?', 
                objType: '@?'
            },
            controllerAs: 'vloc',
            controller: InsTransactionListController
        });

    InsTransactionListController.$inject = ['$scope', '$rootScope', '$q', '$window', '$timeout', 'remoteActions'];

    function InsTransactionListController($scope, $rootScope, $q, $window, $timeout, remoteActions) {
       
        var vloc = this,
            defaultConfig = {
            };

        vloc.$onInit = doInit;
        $scope.transactionOutput = {}; 
        $scope.transactionInput = {};
        $scope.showOmniForm = false;
        $scope.$watchCollection('transactionOutput', function(newval, oldval) {
            // submit or cancel clicked
            if(newval.vlcOmniFormStatus === 'submitting' || newval.vlcOmniFormStatus === 'cancelling'){
                console.log('submitting', 'cancelling');
             $rootScope.isLoaded = false;
            }
            // remote action completed
            if(newval.vlcOmniFormStatus === 'submit' || newval.vlcOmniFormStatus === 'cancel'){
                console.log('submit', 'cancel');
                //if submit:
                delete $scope.omniInput;
                $rootScope.isLoaded = true;
                remoteActions.getAssetTransaction(vloc.id).then(function(data) {
                      console.log(data);
                        $scope.result = [];
                        $scope.balance = 0;
                        var temp = {};

                        for(var key in data.assetTransactions){
                            var tempDate = new Date(data.assetTransactions[key][$rootScope.nsPrefix + 'postdate__c']);
                            var tempDateFormatted = (tempDate.getUTCMonth() + 1) + '/' + tempDate.getUTCDate() + '/' + tempDate.getUTCFullYear();
                            data.assetTransactions[key][$rootScope.nsPrefix + 'postdate__c'] = tempDateFormatted;
                          $scope.result.push(data.assetTransactions[key]);

                         var transactionTypes = data.assetTransactions[key][$rootScope.nsPrefix + 'type__c'];

                           if(!temp[transactionTypes]){
                               temp[transactionTypes] = transactionTypes;
                          }
                            if(data.assetTransactions[key][$rootScope.nsPrefix + 'amount__c']){
                                $scope.balance += data.assetTransactions[key][$rootScope.nsPrefix + 'amount__c'];
                            }
                       }
                      $scope.transactionTypes = Object.keys(temp);
                        $scope.filterTransactionTypes =  $scope.transactionTypes[0];
                       $scope.unfilteredResults = $scope.result;
                       $scope.transactionTypes.push('All');
                   });
            }
        });


                var urlParam = function(name){
                    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
                    if (results === null){
                       return null;
                    }
                    else{
                       return decodeURI(results[1]) || 0;
                    }
                };

       
        $scope.filterResults = function(dateRangeStart, dateRangeEnd, transactionType){
            $scope.result = [];
            console.log($scope.unfilteredResults);
            for(var i = 0; i < $scope.unfilteredResults.length; i++){
                var returnObj = true;
                var date = new Date($scope.unfilteredResults[i][$rootScope.nsPrefix + 'postdate__c']);
                var type = $scope.unfilteredResults[i][$rootScope.nsPrefix + 'type__c'];
                console.log(date >= dateRangeStart);
                console.log(date <= dateRangeEnd);
                if(dateRangeStart){
                    if(date >= dateRangeStart){
                       returnObj = true;
                    } else {
                        returnObj = false;
                    }
                }
                if(dateRangeEnd && returnObj){
                    if(date <= dateRangeEnd){
                       returnObj = true;
                    } else {
                        returnObj = false;
                    }
                }
                if(transactionType && returnObj){
                    if(transactionType === 'All'){
                        returnObj = true;
                    } else {
                        if(type === transactionType || (!type && transactionType === 'None')){
                            returnObj = true;
                        } 
                        else {
                            returnObj = false;
                        }
                    }
                }
                if(returnObj){
                    $scope.result.push($scope.unfilteredResults[i]);           
                }
            }
            $scope.balance  = 0;
            for(var i = 0; i < $scope.result.length; i++){
                if($scope.result[i][$rootScope.nsPrefix + 'amount__c']){
                    $scope.balance += $scope.result[i][$rootScope.nsPrefix + 'amount__c'];
                }
            }
        };

        $scope.cloneIpResult = function(){
            if(vloc.integrationProcedure){
                var inputMap = {
                    type: $scope.transactionDropdown.value
                }
                var options = {}; 
                var output = {};
                console.log(inputMap);
                remoteActions.invokeIntegrationProcedureWithInput(vloc.integrationProcedure, inputMap, options).then(function(data) {
                console.log('data', data);
                $scope.IPResult = data.IPResult; 
                 $scope.omniFormParams = {
                    extraInput : {
                        objectId : vloc.id
                    }
                };
                console.log("$scope.omniFormParams",$scope.omniFormParams);
                 $scope.omniInput = angular.copy($scope.IPResult.OmniInput);
                });
            }
        }

        function doInit(){
            if(!vloc.id){
                vloc.id = urlParam('id');
                vloc.integrationProcedure = urlParam('integrationProcedure');
            }
            if(!vloc.records){
                if(remoteActions){
                    remoteActions.getAssetTransaction(vloc.id).then(function(data) {
                        console.log(data);
                        $scope.result = [];
                        var temp = {};
                        $scope.balance = 0;
                        for(var key in data.assetTransactions){
                            $scope.result.push(data.assetTransactions[key]);
                            var tempDate = new Date(data.assetTransactions[key][$rootScope.nsPrefix + 'postdate__c']);
                            var tempDateFormatted = (tempDate.getUTCMonth() + 1) + '/' + tempDate.getUTCDate() + '/' + tempDate.getUTCFullYear();
                            data.assetTransactions[key][$rootScope.nsPrefix + 'postdate__c'] = tempDateFormatted;
                            var transactionTypes = data.assetTransactions[key][$rootScope.nsPrefix + 'type__c'];
                              if(!transactionTypes){
                                    transactionTypes = 'None'; 
                                }
                          if(!temp[transactionTypes]){

                               temp[transactionTypes] = transactionTypes;

                            }
                            if(data.assetTransactions[key][$rootScope.nsPrefix + 'amount__c']){
                                $scope.balance += data.assetTransactions[key][$rootScope.nsPrefix + 'amount__c'];
                            }
                        }
                        $scope.transactionTypes = Object.keys(temp);
                        $scope.filterTransactionTypes =  $scope.transactionTypes[0];
                        $scope.unfilteredResults = $scope.result;
                        $scope.transactionTypes.push('All');
                    });
                    remoteActions.getTransactionTypes(vloc.id).then(function(data) {
                           console.log(data);
                           $scope.ipTypes = data;
                           $scope.transactionDropdown = $scope.ipTypes[0];
                           console.log('auto pick', $scope.transactionDropdown);
                    });

                }
            }
        }
    }

})();
},{}],3:[function(require,module,exports){
angular.module("insTransactionList").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("ins-transaction-list-template.tpl.html",'<div class="vloc-transaction-container">\n   <div class="vloc-ins-transactions-dropdown slds-p-around_small slds-size_1-of-1 slds-grid slds-wrap">\n      <div class="slds-size_1-of-2 slds-p-right_small">\n         <select ng-options="item as item.label for item in ipTypes" ng-model="transactionDropdown"  class="vloc-transaction-options slds-select slds-m-right_xx-small" id="select-01" ng-change="changeDropdown($index)">\n         </select>\n      </div>\n      <div class="slds-size_1-of-2 slds-grid slds-wrap">\n         <div class="vloc-add-circle" ng-if="!omniInput">\n            <slds-button-svg-icon sprite="\'utility\'" icon="\'add\'" size="\'medium\'" ng-click="showOmniForm = true; cloneIpResult()"></slds-button-svg-icon>\n         </div>\n         <div class="vloc-add-circle" ng-if="omniInput">\n            <slds-button-svg-icon ng-click="$root.showOmniForm = false" sprite="\'utility\'" icon="\'close\'" size="\'medium\'"></slds-button-svg-icon>\n         </div>\n         <div class="slds-float_right slds-p-left_small vloc-filter" ng-class="{\'vloc-tab\' : $root.showFilter}">\n            <slds-button-svg-icon sprite="\'utility\'" extra-classes="vloc-icon-tab" ng-click="$root.showFilter = !$root.showFilter" icon="\'filterList\'" size="\'large\'" ng-click="filter"></slds-button-svg-icon>\n         </div>\n      </div>\n   </div>\n   <div ng-if="$root.showFilter" ng-hide="!$root.showFilter" class="vloc-filter-box slds-p-horizontal_small slds-p-bottom_small slds-size_1-of-1 slds-box slds-grid slds-wrap slds-m-horizontal_xx-small slds-m-bottom_small">\n      <div class="slds-size_1-of-1 slds-p-right_x-small">\n         <div class="slds-size_1-of-1">Transaction Date Range</div>\n         <div class="slds-size_1-of-1 slds-grid slds-grid_wrap">\n            <input class="slds-input slds-m-bottom_xx-small slds-m-right_small" slds-date-picker ng-model="filterDateRangeStart">\n            <input class="slds-input slds-m-bottom_xx-small" slds-date-picker ng-model="filterDateRangeEnd">\n         </div>\n      </div>\n      <div class="slds-size_1-of-2">\n         <div class="slds-size_1-of-1">Transaction Type</div>\n         <select ng-options="cat as cat for cat in transactionTypes" ng-model="filterTransactionTypes"  class="slds-select slds-m-right_xx-small" id="select-02">\n         </select> \n      </div>\n      <div class="slds-size_1-of-1 slds-grid slds-p-top_small">\n         <button class="slds-button slds-link" ng-click="$root.showFilter = false; filterDateRangeStart = \'\'; filterDateRangeEnd = \'\'; filterTransactionTypes = null; filterResults(\'\', \'\', null);">Cancel</button>\n         <span class="vloc-filter-submit"><button class="slds-button slds-button_brand" ng-click="filterResults(filterDateRangeStart, filterDateRangeEnd, filterTransactionTypes);">Submit</button></span>\n      </div>\n   </div>\n   <div class="vlc-omni-form via-slds via-omni vlc-omni-form">\n      <vlc-omni-form omni-input="omniInput" submit-params="omniFormParams" mode="\'console\'" class="slds-grid slds-grid_vertical" id=\'{{omniInput.OmniDef.sOmniScriptId}}\' output="transactionOutput">\n      </vlc-omni-form>\n      <div ng-if="noActiveIP" class="slds-padding-top_small slds-text-align_center">\n         Your integration procedure is not active\n      </div>\n   </div>\n   <div class="slds-grid slds-wrap slds-size_1-of-1 slds-border_bottom slds-p-vertical_x-small">\n      <!--Date Column Only Require 1/6 of the row-->\n      <div class="slds-size_1-of-6 slds-m-right_small">\n         Post\n      </div>\n      <div class="slds-size_1-of-3 slds-m-right_small">\n         Type\n      </div>\n      <div class="slds-size_1-of-3">\n         Amount\n      </div>\n   </div>\n   <div class="slds-p-vertical_x-small" ng-repeat="obj in result | filter: $root.searchWord">\n      <div class="slds-grid slds-wrap slds-size_1-of-1">\n         <!--Date Column Only Require 1/6 of the row-->\n         <div class="slds-size_1-of-6 slds-m-right_small">\n            {{obj[$root.nsPrefix + \'postdate__c\'] | date}}\n         </div>\n         <div class="slds-size_1-of-3 slds-m-right_small">\n            {{obj[$root.nsPrefix + \'type__c\']}}\n         </div>\n         <div class="slds-size_1-of-3">\n            {{obj[$root.nsPrefix + \'amount__c\'] | currency}}\n         </div>\n      </div>\n   </div>\n   <div class="slds-p-around_small slds-border_top slds-border_bottom vloc-balance-bottom slds-grid slds-wrap">\n      <div class="vloc-balance-font">Balance:</div>\n      <div class="vloc-balance-font vloc-balance-total">{{balance | currency}}</div>\n   </div>\n</div>\n<style type="text/css">\n   .vloc-add-circle{\n   background-color: #005fb2;\n   border-radius: 1rem;\n   height: 1.5rem;\n   width: 1.5rem;\n   color: white;\n   margin-top: 0.4rem;\n   padding-left: .3rem;\n   padding-top: .05rem;\n   }\n   .vloc-add-circle:hover{\n   cursor: pointer;\n   }\n   .vloc-filter{\n   color: #005fb2;\n   right: 2rem;\n   position: absolute;\n   top: 1rem;\n   border-radius: 1rem;\n   height: 4rem;\n   padding-right: .75rem;\n   padding-top: .5rem;\n   top: .5rem;\n   outline: none;\n   }\n   .vloc-filter.vloc-tab{\n   background-color: #005fb2;\n   color: white;\n   z-index: 0;\n   }\n   .vloc-filter-box{\n   background-color: white;\n   z-index: 100;\n   position: relative;\n   }\n   .vloc-filter::active{\n   outline: none;\n   }\n   .vloc-check{\n   color: #04844b;\n   right: 2rem;\n   position: absolute;\n   }\n   .vloc-filter:hover{\n   cursor: pointer;\n   }\n   .vloc-icon-tab{\n   z-index: 100;\n   }\n   .vloc-balance-bottom{\n   background: #e3e5ed;\n   }\n   .vloc-hide-dropdown{\n   display: none;\n   }\n   .vloc-filter-submit{\n   position: relative;\n   left: 71%;\n   }\n   .vloc-balance-total{\n   right: 2rem;\n   position: absolute;\n   }\n   .vloc-balance-font{\n   color: #5876a3;\n   text-transform: uppercase;\n   letter-spacing: .0625rem;\n   }\n</style>')}]);
},{}]},{},[1]);

})();
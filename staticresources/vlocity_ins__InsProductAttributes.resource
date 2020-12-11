(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var partsLength=parts.length-1;var thisScript=parts[partsLength--];if(thisScript===""){thisScript=parts[partsLength--]}if(scriptName.indexOf("__")!=-1){while(thisScript.indexOf("__")==-1&&partsLength>=0){thisScript=parts[partsLength];partsLength--}}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){
angular.module('insProductAttributes', ['vlocity', 'CardFramework', 'sldsangular', 'forceng',
    'ngSanitize', 'cfp.hotkeys', 'insValidationHandler', 'insRules'
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

// Controllers
require('./modules/insProductAttributes/controller/InsProductAttributesController.js');
require('./modules/insProductAttributes/controller/InsProductAttributesConfigController.js');
require('./modules/insProductAttributes/controller/InsProductAttributesRowController.js');

// Factories
require('./modules/insProductAttributes/factory/InsProductAttributesService.js');
require('./modules/insProductAttributes/factory/NotificationHandler.js');
require('./modules/insProductAttributes/factory/InsQuoteModalService.js');

// Directives
require('./modules/insProductAttributes/directive/HideNotification.js');
require('./modules/insProductAttributes/directive/InsFocus.js');

// Templates
require('./modules/insProductAttributes/templates/templates.js');



},{"./modules/insProductAttributes/controller/InsProductAttributesConfigController.js":2,"./modules/insProductAttributes/controller/InsProductAttributesController.js":3,"./modules/insProductAttributes/controller/InsProductAttributesRowController.js":4,"./modules/insProductAttributes/directive/HideNotification.js":5,"./modules/insProductAttributes/directive/InsFocus.js":6,"./modules/insProductAttributes/factory/InsProductAttributesService.js":7,"./modules/insProductAttributes/factory/InsQuoteModalService.js":8,"./modules/insProductAttributes/factory/NotificationHandler.js":9,"./modules/insProductAttributes/templates/templates.js":10}],2:[function(require,module,exports){
angular.module('insProductAttributes').controller('InsProductAttributesConfigController',
    ['$scope', '$rootScope', '$timeout', 'InsQuoteModalService', function(
    $scope, $rootScope, $timeout, InsQuoteModalService) {
    'use strict';

    $scope.adjustmentUnits = [
        'Percentage', 
        'Currency'
    ];

    $scope.adjustmentComments = [
        'Required', 
        'Optional', 
        'Not Used'
    ];

    $scope.configurableTypeListStandard = [
        'Currency', 
        'Percent',
        'Text',
        'Number',
        'Checkbox',
        'Datetime',
        'Date',
        'Adjustment'
    ];

    $scope.rulesOptions = {
        ruleTypes: [
            'Hide',
            'Message',
            'Set Value'
        ],
        messageTypes: [{
            code: 'INFO',
            label: 'Information'
        }, {
            code: 'WARN',
            label: 'Warning'
        }, {
            code: 'ERROR',
            label: 'Error'
        }, {
            code: 'RECOMMENDATION',
            label: 'Recommendation'
        }]
    };

     $scope.runtime = {
        isAvailable : true,
        id : null, 
        displayText : null, 
        value : null, 
        isDefault : false
    };
    $scope.configurableTypeListCustomizable = $scope.configurableTypeListStandard.concat(['Picklist', 'Multi Picklist']);

    $scope.configurableTypeDict = {
            Currency: {
                type : 'number',
                valueType: 'currency',
                subType : true ,
                displayType :[
                    'Dropdown',
                    'Single Value'
                ]
            },
            Percent : {
                type: 'number',
                valueType: 'percent',
                subType :true,
                displayType:[
                    'Single Value',
                    'Slider'
                ] 
            },
            Adjustment : {
                type: 'number',
                valueType: 'percent',
                subType :true,
                displayType:[
                    'Single Value',
                    'Slider',
                    'Equalizer'
                ] 
            },
            Text: {
                type: 'text',
                valueType: 'text',
                subType: true,
                displayType:[
                    'Text',
                    'Text Area'
                ]
            },
            Number : {
                type:'number',
                valueType: 'number',
                subType: true,
                displayType:[
                    'Single Value',
                    'Slider'
                ] 
            },
            Checkbox: {
                type: 'checkbox',
                valueType: 'checkbox',
                subType : false, 
            },
            Datetime : {
                type:'datetime-local',
                valueType: 'datetime',
                subType : false 
            },
            Date: {
                type:'date',
                valueType: 'date',
            },
            Picklist : {
                label:'Picklist',
                type: null,
                valueType: 'picklist',
                subType: true,
                displayType:[
                    'Radiobutton',
                    'Dropdown'
                ]
            },
            'Multi Picklist' :{ 
                type: null,
                valueType: 'picklist',
                subType :true,
                displayType:[
                    'Checkbox',
                    'Dropdown'
                ]
            },
            Dropdown :{
                type: null, 
                valueType : 'picklist'
            },
            Radiobutton : {
                type: 'radio',
                valueType: 'picklist'
            }
        };
        $scope.minMaxDataTypeList = ['Currency', 'Percent','Number', 'Text'];

        $scope.setDataType = function(field){
            $rootScope.config.attr.valueType = $scope.configurableTypeDict[$rootScope.config.attr[field.name]].valueType; 
            if($rootScope.config.attr.valueType === 'date' || $rootScope.config.attr.valueType === 'datetime-local'){
                if(typeof($rootScope.config.attr[$scope.nsPrefix + 'Value__c'] !== 'date') || typeof($rootScope.config.attr[$scope.nsPrefix + 'Value__c'] !== 'datetime-local') ) {
                    $rootScope.config.attr[$scope.nsPrefix + 'Value__c'] = null;
                }
            }
            if($rootScope.config.attr[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Date' || 
                $rootScope.config.attr[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Datetime'){
                 $rootScope.config.attr[$rootScope.nsPrefix + 'Value__c'] = null;
                    $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'] = {};
            }
            if($rootScope.config.attr[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Adjustment'){
                $rootScope.config.attr[$rootScope.nsPrefix + 'IsConfigurable__c'] = true;
            }
            $rootScope.config.attr.inputDisplayType = $scope.configurableTypeDict[$rootScope.config.attr[field.name]].type;
            var dataType =  $rootScope.config.attr[$rootScope.nsPrefix + 'ValueDataType__c'];
            if(!$scope.configurableTypeDict[dataType].subType) {
                $rootScope.config.attr[$rootScope.nsPrefix + 'UIDisplayType__c'] = null;
            }
            if($rootScope.config.attr[$rootScope.nsPrefix + 'IsConfigurable__c'] &&  $scope.configurableTypeDict[dataType].displayType){
                $rootScope.config.attr[$rootScope.nsPrefix + 'UIDisplayType__c'] =  $scope.configurableTypeDict[dataType].displayType[0];
                var displayType =  $rootScope.config.attr[$rootScope.nsPrefix + 'UIDisplayType__c'];
                if(displayType === 'Slider' || displayType === 'Equalizer') {
                    if(displayType === 'Equalizer'){
                          $rootScope.config.attr[$scope.nsPrefix + 'Value__c'] = 0;
                    }
                    $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'] = {};
                } else {
                    if(!Array.isArray($rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'])){
                        $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'] = [];
                    }
                }
                
            }
        };

        $scope.updateOptionsReadOnly = function(){
            if($rootScope.config.attr[$rootScope.nsPrefix + 'IsReadOnly__c']){
                for(var i = 0; i < $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'].length; i++){
                    if(!$rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i].isDefault){
                        $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i].isAvailable = false;
                    } else {
                         $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i].isAvailable = true;
                    }
                }
            }
        };

        $scope.setDisplayType = function(){
            var displayType = $rootScope.config.attr[$rootScope.nsPrefix + 'UIDisplayType__c'];
            var dataType =  $rootScope.config.attr[$rootScope.nsPrefix + 'k17__ValueDataType__c'];
            if(displayType === 'Slider' || displayType === 'Equalizer') {
                if(displayType === 'Equalizer'){
                    $rootScope.config.attr[$scope.nsPrefix + 'Value__c'] = 0;
                }
                $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'] = {};
            } else {
                if(!Array.isArray($rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'])){
                    $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'] = [];
                }
            }
        };

        $scope.showRules = function(index){
            for(var i = 0; i < $rootScope.config.attr[$rootScope.nsPrefix + 'ValidValuesData__c'].length; i++){
                $rootScope.config.attr[$rootScope.nsPrefix + 'ValidValuesData__c'][i].showRules = index === i;
            }
        };

        $scope.addRunTimeValue = function() {
            if($scope.runtime.value || $scope.runtime.displayText){
                if(!$rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'] || $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'].length === 0) {
                    $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'] = [];
                    if($rootScope.config.attr[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Picklist' || $rootScope.config.attr[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Currency'){
                        $scope.runtime.isDefault = true;
                    }
                }
                 $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'].push($scope.runtime);
                 $scope.runtime = {
                    isAvailable : true, 
                    value : '',
                    isDefault : false
                 };
                 if( $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'].length === 1){
                    if($rootScope.config.attr[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Picklist' || $rootScope.config.attr[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Currency'){
                        $rootScope.config.attr[$scope.nsPrefix + 'Value__c'] =  $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][0].value;
                    } else {
                         // no defaut value for multipicklist 
                         $rootScope.config.attr[$scope.nsPrefix + 'Value__c'] = []; 
                    }
                }
            }
        };

        $scope.initOptionRules = function(option){
            if(!option.rules){
                option.rules = [];
            } else if(typeof(option.rules) === 'string'){
                option.rules = JSON.parse(option.rules);
            }
            console.log(option.rules);
        };

        $scope.deleteRunTimeValue = function(option){
            var i = $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'].indexOf(option);
            if( $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i].isDefault && ($rootScope.config.attr[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Picklist' || $rootScope.config.attr[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Currency')){
                if(i > 0){
                $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i - 1].isDefault = true;
                $rootScope.config.attr[$scope.nsPrefix + 'Value__c'] =    $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i - 1].value;
                } else {
                    if($rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i + 1]){
                        $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i + 1].isDefault = true;
                        $rootScope.config.attr[$scope.nsPrefix + 'Value__c'] =    $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i + 1].value;
                    }
             }
            }  else if($rootScope.config.attr[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Multi PickList'){
                var k = $rootScope.config.attr[$scope.nsPrefix + 'Value__c'].indexOf(option.value);
                $rootScope.config.attr[$scope.nsPrefix + 'Value__c'].splice(k, 1);
            }
            if (i > -1) {
                $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'].splice(i, 1);
            }
        };

        $scope.setMultiPicklist = function(option){
            if(option.isDefault){
                if(!$rootScope.config.attr[$scope.nsPrefix + 'Value__c']){
                    $rootScope.config.attr[$scope.nsPrefix + 'Value__c'] = [];
                } else if(typeof($rootScope.config.attr[$scope.nsPrefix + 'Value__c']) !== 'object'){
                  $rootScope.config.attr[$scope.nsPrefix + 'Value__c'] = [];
                }
                $rootScope.config.attr[$scope.nsPrefix + 'Value__c'].push(option.value);
            } else {
                var k = $rootScope.config.attr[$scope.nsPrefix + 'Value__c'].indexOf(option.value);
                $rootScope.config.attr[$scope.nsPrefix + 'Value__c'].splice(k, 1);
                if($rootScope.config.attr[$rootScope.nsPrefix + 'IsReadOnly__c']){
                   option.isAvailable = false;
                }
            }
        };


        $scope.setMultiPicklistCoverage = function(option){
            if(option.isDefault){
                if(!$rootScope.config.attr[$scope.nsPrefix + 'Value__c']){
                    $rootScope.config.attr[$scope.nsPrefix + 'Value__c'] = [];
                } else if(typeof($rootScope.config.attr[$scope.nsPrefix + 'Value__c']) !== 'object'){
                  $rootScope.config.attr[$scope.nsPrefix + 'Value__c'] = [];
                }
                $rootScope.config.attr[$scope.nsPrefix + 'Value__c'].push(option.value);
            } else {
                var k = $rootScope.config.attr[$scope.nsPrefix + 'Value__c'].indexOf(option.value);
                $rootScope.config.attr[$scope.nsPrefix + 'Value__c'].splice(k, 1);
            }
        };

        $scope.setDefaultOptionCoverage = function(index){
            for(var i = 0; i < $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'].length; i++){
                $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i].isDefault = false;
                if($rootScope.config.attr[$rootScope.nsPrefix + 'IsReadOnly__c']){
                    $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i].isAvailable = false;
                }
                if(i === index && ($rootScope.config.attr[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Picklist' || $rootScope.config.attr[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Currency')) {
                    $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i].isDefault = true;
                    $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i].isAvailable = true;
                    $rootScope.config.attr[$scope.nsPrefix + 'Value__c'] =  $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i].value;
                }
            }
        };

         $scope.setDefaultOption = function(index){
            for(var i = 0; i < $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'].length; i++){
                $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i].isDefault = false;
                if(i === index && ($rootScope.config.attr[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Picklist' || $rootScope.config.attr[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Currency')) {
                    $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i].isDefault = true;
                    $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i].isAvailable = true;
                    $rootScope.config.attr[$scope.nsPrefix + 'Value__c'] =  $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'][i].value;
                }
            }
        };



        $scope.toNumber = function(n){
            $rootScope.config.attr[$scope.nsPrefix + 'Value__c'] = parseInt(n);
        };

}]);
},{}],3:[function(require,module,exports){
angular.module('insProductAttributes').controller('InsProductAttributesController', 
    ['$scope', '$rootScope', '$timeout', 'InsProductAttributesService', 'NotificationHandler', 'InsQuoteModalService', function(
    $scope, $rootScope, $timeout, InsProductAttributesService, NotificationHandler, InsQuoteModalService) {
    'use strict';
    $scope.vlocAttrs = {};
    $rootScope.config = {
        show : true, 
        attr : null
    };
    $rootScope.rowFields =  [
            {
                displayLabel: "[" + $rootScope.nsPrefix + "CategoryName__c]",
                label: "Category",
                name: "[" + $rootScope.nsPrefix + "CategoryName__c]",
                type: "string"
            },
             {
                displayLabel: "[" + $rootScope.nsPrefix + "AttributeUniqueCode__c]",
                label: "Code",
                name: "[" + $rootScope.nsPrefix + "AttributeUniqueCode__c]",
                type: "string"
            },
            {
                displayLabel: "['Name']",
                editing: false,
                label: "Label",
                name: "['Name']",
                type: "string"
            },
            {
                displayLabel: "[" + $rootScope.nsPrefix + "ValueDataType__c]",
                label: "Control",
                name: "[" + $rootScope.nsPrefix + "ValueDataType__c]",
                type: "string"
            },
            {
                displayLabel: "[" + $rootScope.nsPrefix + "Value__c]",
                editing: false,
                label: "Value",
                name: "[" + $rootScope.nsPrefix + "Value__c]",
                type: $rootScope.nsPrefix + "ValueDataType__c"
            },
            {
                displayLabel: "[" + $rootScope.nsPrefix + "IsRatingAttribute__c]",
                label: "Rating",
                name: "[" + $rootScope.nsPrefix + "IsRatingAttribute__c]",
                type: "boolean"
            }
    ];

    $scope.setOrderTerm = function(orderTerm) {
        if ($scope.orderTerm !== orderTerm) {
            $scope.orderAsc = true;
            $scope.orderTerm = orderTerm;
        } else {
            $scope.orderAsc = !$scope.orderAsc;
        }
    };

    $scope.vlocAttrs.card = [];
    $rootScope.notification.active = false;
    $scope.notificationHandler = new NotificationHandler();
    
    $scope.vlocAttrs.initData = function(productId, length){
        $scope.productId = productId;
        $scope.vlocAttrs.length = length;
    };

    $scope.vlocAttrs.setOrder = function(field){
        $scope.vlocAttrs.order = field;
        field = field.slice(2, field.length - 2);
        $scope.vlocAttrs.orderBy  = field;
    };
    InsProductAttributesService.getCategories($scope);


    $scope.vlocAttrs.getCategoryAttributes = function(category){
        if(!category.attrs || category.attrs.length < 1) {
            var inputMap = {
                categoryCode : category.categoryCode, 
                productId : $scope.productId 
            };
            InsProductAttributesService.getCategoryAttributes($scope, inputMap, category); 
        }
        $rootScope.isLoaded = true;
    };

    $scope.rulesOptions = {
        ruleTypes: [
            'Hide',
            'Message',
            'Set Value'
        ],
        messageTypes: [{
            code: 'INFO',
            label: 'Information'
        }, {
            code: 'WARN',
            label: 'Warning'
        }, {
            code: 'ERROR',
            label: 'Error'
        }, {
            code: 'RECOMMENDATION',
            label: 'Recommendation'
        }]
    };

    $scope.vlocAttrs.newAttr = function(attr, category){
        $rootScope.config.attr = {};
        $rootScope.config.attr.Name = attr.attributeName;
        $rootScope.config.attr[$rootScope.nsPrefix + 'AttributeName__c'] = attr.attributeName;
        $rootScope.config.attr[$rootScope.nsPrefix + 'CategoryCode__c'] = attr.categoryCode;
        $rootScope.config.attr[$rootScope.nsPrefix + 'AttributeId__c'] = attr.attributeId;
        $rootScope.config.attr[$rootScope.nsPrefix + 'AttributeUniqueCode__c'] = attr.attributeCode;   
        $rootScope.config.attr[$rootScope.nsPrefix + 'AttributeGroupType__c'] = attr.attributeGroupType;
        $rootScope.config.attr[$rootScope.nsPrefix + 'AttributeCategoryId__c'] = category.categoryId; 
        $rootScope.config.attr[$rootScope.nsPrefix + 'CategoryName__c'] = category.categoryName;
        $rootScope.config.attr[$rootScope.nsPrefix + 'ObjectId__c'] = $scope.productId;
        $rootScope.config.attr[$rootScope.nsPrefix + 'IsRequired__c'] = false; 
        $rootScope.config.attr[$rootScope.nsPrefix + 'IsReadOnly__c'] = false; 
        $rootScope.config.attr[$rootScope.nsPrefix + 'IsRatingAttribute__c'] = false;
        $rootScope.config.attr[$rootScope.nsPrefix + 'IsActiveAssignment__c'] = true;
        $rootScope.config.attr[$rootScope.nsPrefix + 'IsConfigurable__c'] = false;
        $rootScope.config.attr[$rootScope.nsPrefix + 'AttributeDisplayNameOverride__c'] =  attr.attributeName;
        $rootScope.config.attr[$scope.nsPrefix + 'ValidValuesData__c'] = [];
        $rootScope.config.attr[$rootScope.nsPrefix + 'IsHidden__c'] = attr.isDefaultHidden;
        if(attr.displaySequence){
            $rootScope.config.attr[$rootScope.nsPrefix + 'AttributeDisplaySequence__c'] = attr.displaySequence.toString();
        }
        $rootScope.config.attr[$scope.nsPrefix + 'RatingType__c'] = '';
        if($scope.vlocAttrs.productRecordType === 'InsuredItemSpec' || 
            $scope.vlocAttrs.productRecordType === 'ClaimInjurySpec' ||
            $scope.vlocAttrs.productRecordType === 'ClaimProduct' || 
            $scope.vlocAttrs.productRecordType === 'ClaimPropertySpec'  ) {
            $rootScope.config.attr[$rootScope.nsPrefix + 'IsConfigurable__c'] = true;
        }
        if ($rootScope.productRecordType === 'RatingFactSpec') {
            $rootScope.config.attr[$rootScope.nsPrefix + 'RatingType__c'] = 'Input';
        }
    };

    $scope.vlocAttrs.saveAttrs = function(){
        let attrName = $rootScope.config.attr.Name;
        $rootScope.config.attr[$rootScope.nsPrefix + 'AttributeDisplayNameOverride__c'] = attrName;
        let input =  Object.assign({},  $rootScope.config.attr);
        $rootScope.config.attr.ruleError = false;
        delete input.valueType;
        delete input.inputDisplayType;
        let type = typeof(input[$scope.nsPrefix + 'ValidValuesData__c']);
        let saveRules = angular.copy($rootScope.config.attr.rules);
        if(saveRules){
            console.log('ruleValidation', saveRules);
            for(let i = 0; i < saveRules.length; i++){
                if(saveRules[i] && saveRules[i].validation){
                    if(!saveRules[i].validation.messageText || !saveRules[i].validation.messageType || 
                        !saveRules[i].validation.ruleType ||  !saveRules[i].validation.valueExpression){
                        $rootScope.config.attr.ruleError = true;
                    }
                }
            }
            let saveRulesStr = JSON.stringify(saveRules);
            input[$scope.nsPrefix + 'RuleData__c'] = saveRulesStr;
            input[$scope.nsPrefix + 'HasRule__c'] = true; 
        }
        if(!input[$scope.nsPrefix + 'IsRatingAttribute__c']){
             input[$scope.nsPrefix + 'RatingType__c'] = null;
             input[$scope.nsPrefix + 'RatingInput__c'] = null; 
             input[$scope.nsPrefix + 'RatingOutput__c'] = null;
        }
        if(input[$scope.nsPrefix + 'RatingType__c'] === 'Output'){
             input[$scope.nsPrefix + 'RatingInput__c'] = null; 
         } 
        if(input[$scope.nsPrefix + 'RatingType__c'] === 'Input'){
             input[$scope.nsPrefix + 'RatingOutput__c'] = null;
        }
        if(input[$scope.nsPrefix + 'ValueDataType__c'] === 'Adjustment' && !input[$scope.nsPrefix + 'AttributeAdjustmentUnits__c']){
            $rootScope.notification.type = 'error'; 
            $rootScope.notification.message = "Adjustment attribute must have adjustment units"; 
            $rootScope.notification.active = true;
        }
        if(input[$scope.nsPrefix + 'ValueDataType__c'] === 'Adjustment'){
            input[$scope.nsPrefix + 'IsConfigurable__c'] = true;
        }
        if(input[$scope.nsPrefix + 'ValueDataType__c'] !== 'Percent' && input[$scope.nsPrefix + 'ValueDataType__c'] !== 'Adjustment' && input[$scope.nsPrefix + 'ValueDataType__c'] !== 'Number' && input[$scope.nsPrefix + 'ValueDataType__c'] !== 'Currency' && input[$scope.nsPrefix + 'ValueDataType__c'] !== 'Multi Picklist' && input[$scope.nsPrefix + 'ValueDataType__c'] !== 'Picklist'){
            input[$scope.nsPrefix + 'ValidValuesData__c'] = [];
        } 
        if(input[$scope.nsPrefix + 'UIDisplayType__c']  === 'Single Value'){
            input[$scope.nsPrefix + 'ValidValuesData__c'] = [];
        }
        if(!input[$scope.nsPrefix + 'ValueDataType__c']){
            $rootScope.notification.type = 'error'; 
            $rootScope.notification.message = "Attribute must have data type assignment"; 
            $rootScope.notification.active = true;
        }  else if(input[$scope.nsPrefix + 'ValueDataType__c'] && !$rootScope.notification.active) {
            if(input[$scope.nsPrefix + 'ValidValuesData__c'] && type !== 'string') {
                if(input[$scope.nsPrefix + 'ValueDataType__c'] === 'Multi Picklist'){
                    input[$scope.nsPrefix + 'Value__c'] = [];
                    for(var option in input[$scope.nsPrefix + 'ValidValuesData__c']){
                        if(input[$scope.nsPrefix + 'ValidValuesData__c'][option].isDefault){
                        input[$scope.nsPrefix + 'Value__c'].push(input[$scope.nsPrefix + 'ValidValuesData__c'][option].value);
                        }
                    }
                }
                if(input[$scope.nsPrefix + 'ValueDataType__c'] !== 'Multi Picklist'){
                    for(var option in input[$scope.nsPrefix + 'ValidValuesData__c']){
                        if(input[$scope.nsPrefix + 'ValidValuesData__c'][option].isDefault){
                            input[$scope.nsPrefix + 'Value__c'] = input[$scope.nsPrefix + 'ValidValuesData__c'][option].value;
                        }
                    }
                }
                if(input[$scope.nsPrefix + 'ValidValuesData__c'] && input[$scope.nsPrefix + 'ValidValuesData__c'].length === 0 ){
                    delete input[$scope.nsPrefix + 'ValidValuesData__c'];
                } else {
                    if(input[$scope.nsPrefix + 'ValidValuesData__c'] && input[$scope.nsPrefix + 'ValidValuesData__c'].step){
                         if(input[$scope.nsPrefix + 'ValidValuesData__c'].step <= input[$scope.nsPrefix + 'ValidValuesData__c'].max && input[$scope.nsPrefix + 'ValidValuesData__c'].step > 0){
                            var r = input[$scope.nsPrefix + 'ValidValuesData__c'].max % input[$scope.nsPrefix + 'ValidValuesData__c'].step;
                            if(r !== 0 && input[$scope.nsPrefix + 'ValidValuesData__c'].step <= input[$scope.nsPrefix + 'ValidValuesData__c'].max){
                                while(r !== 0){
                                    input[$scope.nsPrefix + 'ValidValuesData__c'].step += 1;
                                    console.log(input[$scope.nsPrefix + 'ValidValuesData__c'].step);
                                    r = input[$scope.nsPrefix + 'ValidValuesData__c'].max % input[$scope.nsPrefix + 'ValidValuesData__c'].step;
                                    console.log(r);
                                }
                            }   
                        } else {
                           input[$scope.nsPrefix + 'ValidValuesData__c'].step = input[$scope.nsPrefix + 'ValidValuesData__c'].max;
                        }

                        input[$scope.nsPrefix + 'ValidValuesData__c'].min =  input[$scope.nsPrefix + 'ValidValuesData__c'].max * (-1);
                        input[$scope.nsPrefix + 'Value__c'] = 0;
                    }
                    input[$scope.nsPrefix + 'ValidValuesData__c'] =  JSON.stringify(input[$scope.nsPrefix + 'ValidValuesData__c']);
                }
            }
            type = typeof(input[$scope.nsPrefix + 'Value__c']);
            if(type && type !== 'string') {
                if(input[$rootScope.nsPrefix + 'ValueDataType__c'] !== 'Date' &&
                    input[$rootScope.nsPrefix + 'ValueDataType__c'] !== 'Datetime'){
                    input[$scope.nsPrefix + 'Value__c'] =  JSON.stringify(input[$scope.nsPrefix + 'Value__c']);
                } 
            }

            var inputMap = {
                productAttribute : JSON.stringify(input)
            };
            if(!$rootScope.config.attr.ruleError){
                if(!$rootScope.config.attr.Id){
                    inputMap.productRecordType = $rootScope.productRecordType;
                    InsProductAttributesService.createProductAttribute($scope, inputMap, attrName); 
                } else {
                    inputMap.productRecordType = $rootScope.productRecordType;
                    InsProductAttributesService.updateProductAttributes($scope, inputMap, attrName); 
                }
            } else {
                var error = {
                    data : {
                        message: 'Unable to Update. Fix Error in Rules For Product Attribute.'
                    }
                };
                $scope.notificationHandler.handleError(error);
            }
        }
    };


    $scope.vlocAttrs.deleteAttr = function(){
        var input = $rootScope.config.attr; 
        delete input.valueType;
        delete input.inputDisplayType;
        var inputMap = {
            productAttribute : JSON.stringify($rootScope.config.attr),
            productRecordType : $rootScope.productRecordType
        };
        InsProductAttributesService.deleteProductAttributes($scope, inputMap); 
    };

    $scope.vlocAttrs.processFieldSet = function(fieldSet){
        $rootScope.config.fieldSet = {};
        if(fieldSet){
            for(var i = 0; i  < fieldSet.length; i++){
                   $rootScope.config.fieldSet[fieldSet[i].fieldName]= fieldSet[i];
            }
        }
        $rootScope.isLoaded = true;
    };

    //If there isn't a card specified for record type, use 'Default';
    $scope.vlocAttrs.showCard = function(cards, recordType){
        var values = {};
        for(var i = 0; i < cards.length; i++){
             if(!values[cards[i].sessionVars[0].val]){
                values[cards[i].sessionVars[0].val] = [cards[i]];
             } else {
                values[cards[i].sessionVars[0].val].push(cards[i]);
             }
             
        }
        if(values[recordType]){
            $scope.vlocAttrs.cards = values[recordType];
        } else {
            $scope.vlocAttrs.cards = values.Default;
            recordType = 'Default';
        }
        $scope.vlocAttrs.productRecordType  = recordType;
    };

    $scope.vlocAttrs.showRules = function(){
        if(!$rootScope.config.attr.rules){
            $rootScope.config.attr.rules = [];
        }
        var records = {
            record : $rootScope.config.attr, 
            rules : $rootScope.config.attr.rules, 
            rulesOptions : $scope.rulesOptions
        };
        var originalRulesCopy = angular.copy($rootScope.config.attr.rules);
         InsQuoteModalService.launchModal(
            $scope,
            'ins-product-attributes-rules-modal',
             records,
            '',
            'vloc-quote-modal',
            function() {
                if (($rootScope.config.attr.rules && originalRulesCopy && $rootScope.config.attr.rules.length > originalRulesCopy.length) || !angular.equals($rootScope.config.attr.rules, originalRulesCopy)) {
                    $scope.vlocAttrs.saveAttrs();
                }
            }
        );
    };

}]);
},{}],4:[function(require,module,exports){
angular.module('insProductAttributes').controller('InsProductAttributesRowController',
    ['$scope', '$rootScope', '$timeout', function(
    $scope, $rootScope, $timeout) {
    'use strict';
        $scope.row = {};

        $scope.vlocValueRow = function(dataType){
            return dataType.toLowerCase();
        };

        $scope.getIndex = function(i){
            return parseInt(i) + 1;
        };

        $scope.setRowData = function(obj, index){
            $scope.row = obj;
            if($scope.row[$rootScope.nsPrefix + 'ValidValuesData__c']){
               var parsed = JSON.parse($scope.row[$rootScope.nsPrefix + 'ValidValuesData__c']);
               $scope.row[$rootScope.nsPrefix + 'ValidValuesData__c'] = parsed;
            }
            if($scope.row[$rootScope.nsPrefix + 'ValueDataType__c']){
                $scope.row.valueType = $scope.row[$rootScope.nsPrefix + 'ValueDataType__c'].toLowerCase();
            }
            if($scope.row[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Multi Picklist'){
                $scope.row[$rootScope.nsPrefix + 'Value__c'] = JSON.parse($scope.row[$rootScope.nsPrefix + 'Value__c']);
            }
            if($scope.row[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Checkbox'){
                $scope.row[$rootScope.nsPrefix + 'Value__c'] = $scope.row[$rootScope.nsPrefix + 'Value__c'] === 'true';
            }
            if($scope.row[$rootScope.nsPrefix + 'RuleData__c']){
             $scope.row.rules = JSON.parse($scope.row[$rootScope.nsPrefix + 'RuleData__c']);
            }
            if(!$rootScope.config.attr && index === '0'){
                $rootScope.config.attr =  Object.assign({},  $scope.row);
            } 
            $rootScope.isLoaded = true;
        };
        
        $scope.setAttr = function(row, index){
            if (row[$rootScope.nsPrefix + 'Value__c'] && row[$rootScope.nsPrefix + 'ValueDataType__c'] === 'Number') {
                row[$rootScope.nsPrefix + 'Value__c'] = parseFloat(row[$rootScope.nsPrefix + 'Value__c']);
            }
            $rootScope.config.attr =  Object.assign({}, row);
            row.selected = true;
            $rootScope.index = index;
            if($rootScope.config.attr[$rootScope.nsPrefix + 'RuleData__c']){
              $rootScope.config.attr.rules = JSON.parse($rootScope.config.attr[$rootScope.nsPrefix + 'RuleData__c']);
            }
        };

        $scope.convertType = function(row, key){
            var t = key.substring(2, key.length - 2);
            row[key] = row[t];
        };
}]);
},{}],5:[function(require,module,exports){
angular.module('insProductAttributes').directive('hideNotification', function($rootScope, $timeout) {
    'use strict';
    return {
        restrict: 'A',
        link: function() {
            $rootScope.$watch('notification.message', function(newValue) {
                // Only fire on notification with message. Notifications without a message
                // will be when it closes
                if (newValue !== '') {
                    $timeout(function() {
                        // After 3 seconds, closes notification on mousedown of anywhere in the
                        // document except the notification itself (X closes though):
                        $('body').on('touchstart mousedown', function(e) {
                            e.preventDefault();
                            // Clear out notification
                            $timeout(function() {
                                $rootScope.notification.message = '';
                            }, 500);
                            $rootScope.notification.active = false;
                            // Have to apply rootScope
                            $rootScope.$apply();
                            // Unbind mousedown event from whole document
                            $(this).off('touchstart mousedown');
                        });
                    }, 2000);
                }
            });
        }
    };
});

},{}],6:[function(require,module,exports){
angular.module('insProductAttributes').directive('insFocus', ['$timeout', function($timeout) {
    'use strict';
    return {
        restrict: 'A',
        link: function(scope, element, attrs, ctrl) {
            element.click(function() {
                $timeout(function() {
                    $('#' + attrs.insFocus).focus();
                }, 0);
            });
        }
    };
}]);

},{}],7:[function(require,module,exports){
angular.module('insProductAttributes').factory('InsProductAttributesService', 
['$rootScope', '$http',  '$q', 'dataSourceService', 'dataService', 'InsValidationHandlerService',
    function($rootScope, $http, $q, dataSourceService, dataService, InsValidationHandlerService) {
    'use strict';
    var REMOTE_CLASS = 'InsuranceProductAdminHandler';
    var DUAL_DATASOURCE_NAME = 'Dual';
    var insideOrg = false;
    var errorContainer = {};

    var  refreshList = function() {
        var message = {
            event: 'reload'
        };
        $rootScope.$broadcast('vlocity.layout.ins-product-attributes-container.events', message);
        $rootScope.isLoaded = true;
    };

    return{
        getCategories: function(scope){
            $rootScope.isLoaded = false;
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'getCategories';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    scope.vlocAttrs.categories = data.categories;
                    deferred.resolve(data);
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    InsValidationHandlerService.throwError(error);
                    $rootScope.isLoaded = true;
                });
            return  deferred.promise;
        },
        getCategoryAttributes: function(scope, inputMap, category){
            $rootScope.isLoaded = false;
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'getCategoryAttributes';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.inputMap = inputMap;
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    for(var i = 0; i < data.attributes.length; i++){
                        data.attributes[i].show = true;
                    }
                    category.attrs = data.attributes;
                    deferred.resolve(data);
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    InsValidationHandlerService.throwError(error);
                    $rootScope.isLoaded = true;
                });
            return  deferred.promise;
        }, createProductAttribute : function(scope, inputMap, attrName){
            $rootScope.isLoaded = false;
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'saveProductAttribute';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.inputMap = inputMap;
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    $rootScope.config.attr.Id = data.Id;
                    $rootScope.config.attr[$rootScope.nsPrefix + 'AttributeDisplayName__c'] = data.displayName;
                    var message = 'Added ' + attrName + ' Successfully';
                    //Hide from attr list: 
                    for(var i = 0; i < scope.vlocAttrs.categories.length; i++){
                        var cat = scope.vlocAttrs.categories[i];
                        var catid = $rootScope.config.attr[$rootScope.nsPrefix + 'AttributeCategoryId__c'];
                        if(cat.categoryId === catid){   
                            for(var j = 0; j < cat.attrs.length; j++){
                                var attr = cat.attrs[j];
                                var attrid = $rootScope.config.attr[$rootScope.nsPrefix +  'AttributeId__c'];
                                if(attr.attributeId ===  attrid){
                                     attr.show = false;
                                }
                            }
                        }
                    }
                    scope.notificationHandler.handleSuccess(message);
                    scope.notificationHandler.hide();
                    refreshList();
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
            return  deferred.promise;
        }, updateProductAttributes : function(scope, inputMap, attrName){
            $rootScope.isLoaded = false;
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'updateProductAttribute';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.inputMap = inputMap;
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    var message = 'Updated ' + attrName + ' Successfully';
                    scope.notificationHandler.handleSuccess(message);
                    scope.notificationHandler.hide();
                    refreshList();
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
            return  deferred.promise;
        },deleteProductAttributes : function(scope, inputMap){
            $rootScope.isLoaded = false;
            var effectiveDate = null;
            var deferred = $q.defer();
            var nsPrefix = fileNsPrefix().replace('__', '');
            var datasource = {};
            datasource.type = 'Dual';
            datasource.value = {};
            datasource.value.remoteNSPrefix = nsPrefix;
            datasource.value.remoteClass = 'InsuranceProductAdminHandler';
            datasource.value.remoteMethod = 'deleteProductAttribute';
            datasource.value.apexRemoteResultVar = 'result.records';
            datasource.value.methodType = 'GET';
            datasource.value.inputMap = inputMap;
            datasource.value.apexRestResultVar = 'result.records';
            console.log('datasource', datasource);
            // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
            // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
            dataSourceService.getData(datasource, scope, null).then(
                function(data) {
                    console.log(data);
                    deferred.resolve(data);
                    $rootScope.index = 0;
                    $rootScope.config.show = false;
                    refreshList();
                    var message = 'Deleted Product Attribute Successfully';
                    scope.notificationHandler.handleSuccess(message);
                    scope.notificationHandler.hide();
                    //Show Attribute In List
                    for(var i = 0; i < scope.vlocAttrs.categories.length; i++){
                        var cat = scope.vlocAttrs.categories[i];
                        var catid = $rootScope.config.attr[$rootScope.nsPrefix + 'AttributeCategoryId__c'];
                        if(cat.categoryId === catid && cat.attrs){   
                            for(var j = 0; j < cat.attrs.length; j++){
                                var attr = cat.attrs[j];
                                var attrid = $rootScope.config.attr[$rootScope.nsPrefix +  'AttributeId__c'];
                                if(attr.attributeId ===  attrid){
                                     attr.show = true;
                                }
                            }
                        }
                    }
                    $rootScope.isLoaded = true;
                }, function(error) {
                    console.error(error);
                    deferred.reject(error);
                    scope.notificationHandler.handleError(error);
                    scope.notificationHandler.hide();
                    $rootScope.isLoaded = true;
                });
            return  deferred.promise;
        }
    };
}]);
},{}],8:[function(require,module,exports){
angular.module('insProductAttributes').factory('InsQuoteModalService',
['$rootScope', '$sldsModal', '$timeout', 'InsProductAttributesService',
function($rootScope, $sldsModal, $timeout, InsProductAttributesService) {
    'use strict';
    
     var scrollTop = function(){
        if ('parentIFrame' in window) {
            window.parentIFrame.scrollTo(0);
        } else {
            $('body').scrollTop(0);
        }
    };

    return {
        launchModal: function(scope, layout, records, ctrl, customClass, onHide) {
            var modalScope = scope.$new();
            var insModal;
            scrollTop();
            modalScope.vlocQuote = scope.vlocQuote;
            modalScope.isLayoutLoaded = false;
            modalScope.layout = layout;
            modalScope.records = records;
            modalScope.ctrl = ctrl;
            modalScope.title = 'Attribute Rules';
            modalScope.customClass = customClass;
            insModal = $sldsModal({
                scope: modalScope,
                templateUrl: 'modals/ins-quote-modal.tpl.html',
                show: true,
                vlocSlide: true,
                onHide: onHide
            });
            // generate click on the modal to get insDropdownHandler directive to work:
            // $timeout(function() {
            //     angular.element('.slds-modal__content').click();
            // }, 500);
        },
        hideModal : function(){
            angular.element('.slds-modal__close').click();
        }
    };
}]);

},{}],9:[function(require,module,exports){
angular.module('insProductAttributes').factory('NotificationHandler', 
    ['$rootScope', '$timeout', function($rootScope, $timeout){
    'use strict';

    var NotificationHandler = function() {
        this.initialize = function() {
        };

        this.handleError = function(error) {
            $rootScope.notification.message = error.data.message || error.data.error;
            $rootScope.notification.type = 'error';
            $rootScope.notification.active = true;
        };


        this.handleSuccess = function(message) {
            console.log('message', message);
            $rootScope.notification.message = message;
            $rootScope.notification.type = 'success';
            $rootScope.notification.active = true;
        };

        this.hide = function(){
            $timeout(function() {
                $rootScope.notification.active = false;
            }, 3000);
        };

        this.initialize();
    };
    return (NotificationHandler);
}]);
},{}],10:[function(require,module,exports){
angular.module("insProductAttributes").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("modals/ins-quote-modal.tpl.html",'<div class="slds-modal slds-fade-in-open slds-modal_medium vloc-modal vloc-modal-slds-slide-up {{vlocSlideCustomClass}}" ng-init="isModalLoaded = !isModalLoaded">\n    <div class="slds-modal__container vloc-modal-container {{vlocSlideCustomClass}}-container">\n        <button class="slds-button slds-button_icon-inverse slds-modal__close vloc-align-{{vlocSlideMobileClose}}" ng-click="$slideHide()" ng-if="!vlocSlideHeader">\n            <slds-button-svg-icon sprite="\'action\'" icon="\'close\'" size="\'large\'"></slds-button-svg-icon>\n            <span class="slds-assistive-text">Close</span>\n        </button>\n        <header class="slds-modal__header slds-is-relative" ng-show="vlocSlideHeader">\n            <button class="slds-button slds-button_icon-inverse slds-modal__close vloc-align-{{vlocSlideMobileClose}}" ng-click="$slideHide()">\n                <slds-button-svg-icon sprite="\'action\'" icon="\'close\'" size="\'large\'"></slds-button-svg-icon>\n                <span class="slds-assistive-text">Close</span>\n            </button>\n            <h2 ng-show="title" class="slds-text-heading_medium slds-hyphenate" ng-bind="title"></h2>\n        </header>\n        <div class="slds-modal__content slds-p-around_medium vloc-modal-content slds-is-relative">\n            <vloc-layout layout-name="{{layout}}" class="{{layout}}" is-loaded="isLayoutLoaded" records="records" ctrl="{{ctrl}}"></vloc-layout>\n        </div>\n        <footer class="slds-modal__footer slds-float_right slds-p-right_large" ng-if="records.modalType === \'Edit\'">\n        <button class="slds-button slds-button_brand" ng-if="!records.Id" ng-click="importedScope.vlocQuote.addNewClass(records, vlocQuote)">Save</button>\n        <button class="slds-button slds-button_brand" ng-if="records.Id" ng-click="importedScope.vlocQuote.updateClass(records, vlocQuote)">Update</button>\n        <button class="slds-button slds-button_neutral" ng-click="$slideHide()">Cancel</button>\n        </footer>\n    </div>\n</div>\n<style type="text/css">\n    .vlocity.via-slds .vloc-modal.slds-modal {\n        top: -100%;\n        margin-bottom: 45px;\n        height: auto;\n        transition: top 500ms ease-in;\n        max-height: 700px;\n    }\n\n    .vlocity.via-slds\n    .vloc-modal.slds-modal\n    .slds-modal__header {\n        border-radius: 0;\n    }\n\n    .vlocity.via-slds\n    .vloc-modal.slds-modal\n    .slds-modal__footer {\n        border-radius: 0;\n    }\n\n    .vlocity.via-slds .vloc-modal.slds-modal .slds-spinner_container {\n        opacity: 0;\n        visibility: hidden;\n        transition: visibility 0ms linear 1250ms,\n                    opacity 500ms ease-in 750ms;\n    }\n\n    .vlocity.via-slds .vloc-modal.slds-modal .slds-spinner_container.vloc-show-loader {\n        opacity: 1;\n        visibility: visible;\n        transition: visibility 0ms linear 0ms,\n                    opacity 500ms ease-in 0ms;\n    }\n\n    .vlocity.via-slds .vloc-modal.slds-modal .slds-global-header_container {\n        opacity: 0;\n        transition: opacity 200ms ease-in 200ms;\n    }\n\n    .vlocity.via-slds .vloc-modal.slds-modal.vloc-modal-shown {\n        top: 45px;\n    }\n\n    .vlocity.via-slds\n    .vloc-modal.slds-modal.vloc-modal-shown\n    .slds-global-header_container {\n        opacity: 1;\n    }\n\n    .vlocity.via-slds\n    .vloc-modal.slds-modal\n    .vloc-edit-insured-item-modal {\n        position: absolute;\n    }\n\n    .vlocity.via-slds\n    .vloc-modal.slds-modal\n    .vloc-modal-container {\n        height: auto;\n        width: 70%;\n        min-width: 70%;\n        max-width: 70%;\n        padding: 0;\n        margin: 0;\n        position: absolute;\n        top: 17rem;\n        left: 50%;\n        transform: translateY(-50%) translateX(-50%);\n    }\n\n    .vlocity.via-slds\n    .vloc-modal.slds-modal\n    .vloc-modal-container\n    .vloc-modal-content {\n        min-height: 30rem;\n        max-height: 0;\n        border-radius: 0;\n        width: 100%;\n    }\n\n    @media screen and (max-width: 600px) {\n        .vlocity.via-slds .vloc-modal.slds-modal {\n            height: calc(100% - 20px); /* leaving room for iPhone notification bar */\n        }\n\n        .vlocity.via-slds.platform-android .vloc-modal.slds-modal {\n            height: 100%; /* Android doesn\'t need the 20px of room like iPhone */\n        }\n\n        .vlocity.via-slds\n        .vloc-modal.slds-modal\n        .slds-modal__header {\n            border-radius: 0;\n        }\n\n        .vlocity.via-slds\n        .vloc-modal.slds-modal\n        .slds-modal__close {\n            top: 0.5rem;\n            left: auto;\n            right: auto;\n            z-index: 999;\n            color: #00396B;\n        }\n\n        .vlocity.via-slds\n        .vloc-modal.slds-modal\n        .slds-modal__close.vloc-align-left {\n            left: 0.5rem;\n        }\n\n        .vlocity.via-slds\n        .vloc-modal.slds-modal\n        .slds-modal__close.vloc-align-right {\n            right: 0.5rem;\n        }\n\n        .vlocity.via-slds\n        .vloc-modal.slds-modal\n        .vloc-modal-container {\n            width: 100%;\n            min-width: 100%;\n            height: 100%;\n            top: 0;\n            left: 0;\n            transform: none;\n            bottom: 0;\n            transition: bottom 250ms ease-in;\n        }\n\n        .vlocity.via-slds\n        .vloc-modal.slds-modal\n        .vloc-modal-container\n        .vloc-modal-content {\n            height: 100%;\n            min-height: auto;\n            max-height: 100%;\n        }\n\n        .vlocity.via-slds\n        .vloc-modal.slds-modal\n        .slds-modal__footer {\n            border-radius: 0;\n        }\n    }\n</style>')}]);
},{}]},{},[1]);

})();
public with sharing class Drag_Drop_Wrapper {
	@AuraEnabled public string Name;
	@AuraEnabled public string Id;
	@AuraEnabled public boolean isSelected;	
	@AuraEnabled public String AccountNumber;
	@AuraEnabled public string Industry;

	public Drag_Drop_Wrapper(String name, string id, String accountNumber, string industry) {
		this.Name = name;
		this.id = id;		
		this.AccountNumber = accountNumber;
		this.Industry = industry;
		isSelected = false;
	}
}

/*
<aura:component controller="ObjectRecordsPaginationInLightning" implements="force:appHostable,flexipage:availableForAllPageTypes">
    <aura:attribute name="objectList" type="List" />
    <aura:attribute name="objectName" type="String" />
    <aura:attribute name="selectedFields" type="List" />
    <aura:attribute name="nonSelectedFields" type="List" />
    <aura:attribute name="values" type="List" />
    <aura:handler name="init" action="{!c.doInit}" value="{!this}" />
    
    <lightning:card title="">
        <lightning:layout>
            <lightning:layoutItem size="9" flexibility="auto" padding="horizontal-medium">
                <lightning:select label="Select any object" required="true" value="{!v.objectName}" onchange="{!c.getFieldList}">
                    <aura:iteration items="{!v.objectList}" var="obj" >
                        <option value="{!obj.value}" text="{!obj.label}"></option>
                    </aura:iteration>        
                </lightning:select>
            </lightning:layoutItem>
        </lightning:layout>
        <lightning:layout>
        <aura:if isTrue="{!not(empty(v.objectName))}">
                <lightning:layoutItem size="6" flexibility="auto" padding="horizontal-medium">
                    <!--<lightning:select label="Select any field" required="true">
                    <aura:iteration items="{!v.fields}" var="fld" >
                        <option value="{!fld.apiName}" text="{!fld.label}"></option>
                    </aura:iteration>        
                </lightning:select> -->
                    <lightning:dualListbox name="multipleOptions"  
                                           label= "Select Fields : " 
                                           sourceLabel="Available" 
                                           selectedLabel="Selected" 
                                           options="{!v.nonSelectedFields}" 
                                           value="{!v.values}" 
                                           requiredOptions="{!v.selectedFields}" 
                                           onchange="{! c.handleChange }"/>
                    
                </lightning:layoutItem>
            </aura:if>
        </lightning:layout>
    </lightning:card>
</aura:component>












---------- js controller
({

doInit : function(component, event, helper) {
helper.getAllObjectListHelper(component, event);
},

getFieldList : function(component, event, helper){
        console.log('method called in controller');
helper.getFieldsHelper(component, event);
},
    handleChange: function (cmp, event) {
    }
})

helper

({
getAllObjectListHelper : function(component, event) {
var action = component.get('c.getObjectList');
action.setCallback(this, function(response){
var state = response.getState();
console.log('state : ' + state);

if(state == 'SUCCESS'){
                var objList = [];
                objList.push({
                    value : '',
                    label : ' -- None --'
                });
                for(var obj in response.getReturnValue()) {
                    objList.push(response.getReturnValue()[obj]);
                }
component.set('v.objectList',objList);
}
else{
console.log('response error : ' + JSON.stringify(response.getError()));
}
})
$A.enqueueAction(action);
},

getFieldsHelper : function(component, event){
        console.log(' objectName : '+component.get('v.objectName'));
var objectName = component.get('v.objectName');
this.getFields(component, event, objectName);	
},

getFields : function(component, event, objectName){
var action = component.get('c.getFilds');
action.setParams({"objectName" :  objectName});
action.setCallback(this, function(response){
var state = response.getState();
if(state === 'SUCCESS'){
                console.log('resonse of fields : '+JSON.stringify(response.getReturnValue()));
var nonselectedfields = [];
                var selectedfields = [];
                for(var obj in response.getReturnValue()) {
                    if(response.getReturnValue()[obj].isRequired) {
                      //  selectedfields.push(response.getReturnValue()[obj]); 
                      selectedfields.push(response.getReturnValue()[obj].value); 
                    }
                    //} else {
                        nonselectedfields.push(response.getReturnValue()[obj]); 
                    //}                  
                }
                component.set('v.nonSelectedFields',nonselectedfields);
                component.set('v.selectedFields',selectedfields);
                console.log('-- selectedFields -- '+JSON.stringify(component.get("v.selectedFields")));
                console.log('-- nonSelectedfields -- '+JSON.stringify(component.get("v.nonSelectedFields")));
}
});
        $A.enqueueAction(action);
}	
})

apex

public with sharing class ObjectRecordsPaginationInLightning {
    
    public static List<LightningRecordsPaginationWrapper> objectWrapper = new List<LightningRecordsPaginationWrapper>();
    public static Map<string,Schema.SObjectField> mpConField = new Map<String, Schema.SObjectField>();
    
    public ObjectRecordsPaginationInLightning() {
        
    }
    
    @AuraEnabled
    public static List<LightningRecordsPaginationWrapper> getObjectList(){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        list<schema.SobjectType> lst=schemaMap.values();
        
        for(schema.SobjectType sObj : lst){
            if(sObj.getDescribe().isAccessible() && sObj.getDescribe().isDeletable() && sObj.getDescribe().isQueryable() && sObj.getDescribe().isUndeletable() && sObj.getDescribe().isUpdateable() && sObj.getDescribe().iscreateable() && sObj.getDescribe().issearchable()){
                    objectWrapper.add(new LightningRecordsPaginationWrapper(sObj.getDescribe().getLabel(), sObj.getDescribe().getName()));                                        
            }
        }
        system.debug(objectWrapper);
        return objectWrapper;
    }
    
    @AuraEnabled
    public static List<LightningRecordsPaginationWrapper> getFilds(String objectName){
        System.debug(objectName);
        List<LightningRecordsPaginationWrapper> fieldsList = new List<LightningRecordsPaginationWrapper>();
        LightningRecordsPaginationWrapper wrapperObject;
        Schema.DescribeSObjectResult desribeResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
        Map<String,Schema.SObjectField> fieldsMap = desribeResult.fields.getMap();
        for(Schema.SObjectField obj:fieldsMap.values()) {
            Schema.DescribeFieldResult describefields =  obj.getDescribe();
            
            if(describefields.isCreateable() && describefields.isAccessible() && describefields.isUpdateable()) {
                wrapperObject = new LightningRecordsPaginationWrapper(describefields.getLabel(),describefields.getName());
                if(! describefields.isNillable()) {
                    wrapperObject.isRequired = true;
                } else {
                    wrapperObject.isRequired = false;
                }
                fieldsList.add(wrapperObject);
            }  
        }
        System.debug(fieldsList);
        return fieldsList;
    }
}


*/
declare module "@salesforce/apex/LightningObjectConfiguration.getSobjectList" {
  export default function getSobjectList(): Promise<any>;
}
declare module "@salesforce/apex/LightningObjectConfiguration.getFields" {
  export default function getFields(param: {selectedObj: any}): Promise<any>;
}
declare module "@salesforce/apex/LightningObjectConfiguration.saveRecordInObject" {
  export default function saveRecordInObject(param: {obj: any, lstOfFields: any, recName: any, column: any}): Promise<any>;
}
declare module "@salesforce/apex/LightningObjectConfiguration.getObjectRecords" {
  export default function getObjectRecords(): Promise<any>;
}

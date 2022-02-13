declare module "@salesforce/apex/GoogleDriveIntegrationInLightning.getAuthCode" {
  export default function getAuthCode(): Promise<any>;
}
declare module "@salesforce/apex/GoogleDriveIntegrationInLightning.getAccessToken" {
  export default function getAccessToken(param: {code: any}): Promise<any>;
}
declare module "@salesforce/apex/GoogleDriveIntegrationInLightning.saveChunk" {
  export default function saveChunk(param: {filename: any, base64Data: any, filetype: any, fId: any, accessToken: any}): Promise<any>;
}
declare module "@salesforce/apex/GoogleDriveIntegrationInLightning.getFileNames" {
  export default function getFileNames(param: {accessToken: any, fId: any}): Promise<any>;
}
declare module "@salesforce/apex/GoogleDriveIntegrationInLightning.deleteFolder1" {
  export default function deleteFolder1(param: {recId: any, access_Token: any}): Promise<any>;
}
declare module "@salesforce/apex/GoogleDriveIntegrationInLightning.downloadFile1" {
  export default function downloadFile1(param: {recId: any, accessToken: any}): Promise<any>;
}

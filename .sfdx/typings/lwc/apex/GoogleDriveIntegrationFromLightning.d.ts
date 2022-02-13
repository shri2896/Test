declare module "@salesforce/apex/GoogleDriveIntegrationFromLightning.createAuthURL" {
  export default function createAuthURL(): Promise<any>;
}
declare module "@salesforce/apex/GoogleDriveIntegrationFromLightning.getAccessToken" {
  export default function getAccessToken(param: {code: any}): Promise<any>;
}
declare module "@salesforce/apex/GoogleDriveIntegrationFromLightning.uploadFile" {
  export default function uploadFile(param: {attachmentId: any, accessToken: any}): Promise<any>;
}

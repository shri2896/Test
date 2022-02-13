declare module "@salesforce/apex/Question_AnswerController.getLanguageList" {
  export default function getLanguageList(): Promise<any>;
}
declare module "@salesforce/apex/Question_AnswerController.getQuestionList" {
  export default function getQuestionList(param: {languageId: any}): Promise<any>;
}
declare module "@salesforce/apex/Question_AnswerController.getLanguageName" {
  export default function getLanguageName(param: {languageId: any}): Promise<any>;
}
declare module "@salesforce/apex/Question_AnswerController.userRecord" {
  export default function userRecord(param: {fName: any, lName: any, email: any}): Promise<any>;
}
declare module "@salesforce/apex/Question_AnswerController.getInstructions" {
  export default function getInstructions(param: {language: any}): Promise<any>;
}

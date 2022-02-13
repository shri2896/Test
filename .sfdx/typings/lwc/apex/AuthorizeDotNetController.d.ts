declare module "@salesforce/apex/AuthorizeDotNetController.getRecordsController" {
  export default function getRecordsController(): Promise<any>;
}
declare module "@salesforce/apex/AuthorizeDotNetController.paymentGateWay" {
  export default function paymentGateWay(param: {cardNumber: any, cvv: any, mobile: any, amount: any, shipAddress: any, shipCity: any, shipcountry: any, firstName: any, lastName: any, Email: any, Phone: any, cart: any, exprDate: any}): Promise<any>;
}
declare module "@salesforce/apex/AuthorizeDotNetController.eCheckPayment" {
  export default function eCheckPayment(param: {nameOnAccount: any, routing: any, accountNumber: any, checkNumber: any, product: any, country: any, address: any, city: any, firstName: any, totalAmount: any}): Promise<any>;
}

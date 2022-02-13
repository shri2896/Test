declare module "@salesforce/apex/ExpensesController.getExpenses" {
  export default function getExpenses(): Promise<any>;
}
declare module "@salesforce/apex/ExpensesController.saveExpenses" {
  export default function saveExpenses(param: {expense: any}): Promise<any>;
}

import { LightningElement, wire, track } from 'lwc';
import getAccountList from '@salesforce/apex/AccountController.getAccountList';

export default class AccountLimit extends LightningElement {
    @track numberOfAccounts = 10; 
    accounts;
    error;

    
    @wire(getAccountList, { recordLimit: '$numberOfAccounts' })
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accounts = undefined;
        }
    }

    handleNumberChange(event) {
        const value = event.target.value;
        // Only update if the user entered a valid positive number
        if (value && value > 0) {
            this.numberOfAccounts = parseInt(value, 10);
        }
    }
    
}
import { LightningElement, wire, track } from 'lwc';
import getAccountListRating from '@salesforce/apex/AccountController.getAccountListRating';

export default class AccountFilter extends LightningElement {
    @track selectedRating = 'All';
    @track accounts;
    error;

    get filterOptions() {
        return [
            { label: 'All Accounts', value: 'All' },
            { label: 'Hot Accounts', value: 'Hot' },
            { label: 'Warm Accounts', value: 'Warm' },
            { label: 'Cold Accounts', value: 'Cold' }
        ];
    }

    @wire(getAccountListRating, { filter: '$selectedRating' })
    wiredAccounts({ error, data }) {
        if (data) {
            
            this.accounts = data.map(account => {
                return {
                    ...account,
                    Name: account.Name ? account.Name : 'Not Specified',
                    Industry: account.Industry ? account.Industry : 'Not Specified',
                    Phone: account.Phone ? account.Phone : 'Not Specified',
                    Rating: account.Rating ? account.Rating : 'Not Specified'
                };
            });
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accounts = undefined;
        }
    }

   
    handleRatingChange(event) {
        this.selectedRating = event.detail.value;
    }
}
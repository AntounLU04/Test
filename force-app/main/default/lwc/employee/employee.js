import { LightningElement, track } from 'lwc';
import { LightningAlert } from 'lightning/alert';

export default class EmployeeManager extends LightningElement {
    employeeName = '';
    employeeAge = '';
    employeeEmail = '';

    @track employeeList = [];

    
    columns = [
        { label: 'Name', fieldName: 'name', type: 'text' },
        { label: 'Age', fieldName: 'age', type: 'number', cellAttributes: { alignment: 'left' } },
        { label: 'Email', fieldName: 'email', type: 'email' },
        {
            type: 'button-icon',
            typeAttributes: {
                iconName: 'utility:delete',
                name: 'delete',
                title: 'Delete',
                variant: 'border-filled',
                alternativeText: 'Delete',
                disabled: false
            },
            // Keeps the button compact on the right side
            initialWidth: 50 
        }
    ];

    get hasEmployees() {
        return this.employeeList.length > 0;
    }

    handleNameChange(event) {
        this.employeeName = event.target.value;
    }

    handleAgeChange(event) {
        this.employeeAge = event.target.value;
    }

    handleEmailChange(event) {
        this.employeeEmail = event.target.value;
    }

    async handleAddEmployee() {
        if (!this.employeeName.trim()) {
            await LightningAlert.open({
                message: 'Please enter an Employee Name before adding.',
                theme: 'error',
                label: 'Required Field Missing',
            });
            return;
        }

        const newEmployee = {
            id: Date.now().toString(), 
            name: this.employeeName,
            age: this.employeeAge ? parseInt(this.employeeAge, 10) : '',
            email: this.employeeEmail
        };

        this.employeeList = [...this.employeeList, newEmployee];

        this.employeeName = '';
        this.employeeAge = '';
        this.employeeEmail = '';
    }

    // Handles row actions (like clicking the delete button)
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'delete') {
            this.deleteEmployee(row.id);
        }
    }

    // Filters the array to remove the item with the matching ID
    deleteEmployee(rowId) {
        this.employeeList = this.employeeList.filter(employee => employee.id !== rowId);
    }
}
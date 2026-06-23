import { LightningElement, track } from 'lwc';
import { LightningAlert } from 'lightning/alert';

export default class EmployeeManager extends LightningElement {
    // Form Input Properties
    employeeName = '';
    employeeAge = '';
    employeeEmail = '';

    // Reactive list to store employees
    @track employeeList = [];

    // Datatable Columns Configuration
    columns = [
        { label: 'Name', fieldName: 'name', type: 'text' },
        { label: 'Age', fieldName: 'age', type: 'number', cellAttributes: { alignment: 'left' } },
        { label: 'Email', fieldName: 'email', type: 'email' }
    ];

    // Getter to check if list has records
    get hasEmployees() {
        return this.employeeList.length > 0;
    }

    // Input Handlers
    handleNameChange(event) {
        this.employeeName = event.target.value;
    }

    handleAgeChange(event) {
        this.employeeAge = event.target.value;
    }

    handleEmailChange(event) {
        this.employeeEmail = event.target.value;
    }

    // Add Button Click Handler
    async handleAddEmployee() {
        // Basic Validation: Ensure Name is populated
        if (!this.employeeName.trim()) {
            await LightningAlert.open({
                message: 'Please enter an Employee Name before adding.',
                theme: 'error',
                label: 'Required Field Missing',
            });
            return;
        }

        // Create a new employee object with a unique ID
        const newEmployee = {
            id: Date.now().toString(), // Generates a unique key for the datatable row
            name: this.employeeName,
            age: this.employeeAge ? parseInt(this.employeeAge, 10) : '',
            email: this.employeeEmail
        };

        // Append to the array using the spread operator to trigger reactivity
        this.employeeList = [...this.employeeList, newEmployee];

        // Clear the form fields for the next entry
        this.employeeName = '';
        this.employeeAge = '';
        this.employeeEmail = '';
    }
}
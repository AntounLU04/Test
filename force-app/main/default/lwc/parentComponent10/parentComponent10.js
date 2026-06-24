import { LightningElement } from 'lwc';

export default class ParentComponent10 extends LightningElement {
    parentText = '';

    handleInputChange(event) {
        this.parentText = event.target.value;
    }

    status = 'Waiting...';

    handleGreet() {
        this.status = 'Hello received!';
    }
    
}
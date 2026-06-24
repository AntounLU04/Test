import { LightningElement } from 'lwc';
import { api } from 'lwc';

export default class ChildComponent10 extends LightningElement {

    @api greeting;
    @api receivedText = '';

    handleClick() {
        
        this.dispatchEvent(new CustomEvent('greet'));
    }
}
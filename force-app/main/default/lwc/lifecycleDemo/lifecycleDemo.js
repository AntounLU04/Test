import { LightningElement } from 'lwc';

export default class LifecycleDemo extends LightningElement {
    // Properties initialized directly without constructor requirements
    counter = 0;
    isVisible = false;

    // --- LIFECYCLE HOOKS ---
    
    constructor() {
        super(); 
        console.log('--- Lifecycle Hook: constructor() executed ---');
    }

    connectedCallback() {
        console.log('--- Lifecycle Hook: connectedCallback() executed ---');
    }

    renderedCallback() {
        console.log('--- Lifecycle Hook: renderedCallback() executed ---');
    }


    handleIncrement() {
        this.counter += 1;
    }

    handleToggle() {
        this.isVisible = !this.isVisible;
    }
}
import { LightningElement } from 'lwc';

export default class LifecycleDemo extends LightningElement {
   
    counter = 0;
    isVisible = false;

  
    
    constructor() {
        super(); 
        console.log('--- Lifecycle Hook: constructor() executed ---');
        console.log(`Counter: ${this.counter} | IsVisible: ${this.isVisible}`);
    }

    connectedCallback() {
        console.log('--- Lifecycle Hook: connectedCallback() executed ---');
        console.log(`Counter: ${this.counter} | IsVisible: ${this.isVisible}`);
    }

    renderedCallback() {
        console.log('--- Lifecycle Hook: renderedCallback() executed ---');
        console.log(`Counter: ${this.counter} | IsVisible: ${this.isVisible}`);
    }


    handleIncrement() {
        this.counter += 1;
    }

    handleToggle() {
        this.isVisible = !this.isVisible;
    }
}
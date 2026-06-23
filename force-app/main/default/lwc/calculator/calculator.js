import { LightningElement, track } from 'lwc';

export default class Calculator extends LightningElement {
    @track currentInput = '0';
    @track expression = '';
    
    shouldResetInput = false;

    handleNumber(event) {
        const number = event.target.dataset.value;

        if (this.currentInput === '0' || this.shouldResetInput) {
            this.currentInput = number;
            this.shouldResetInput = false;
        } else {
            this.currentInput += number;
        }
    }

    handleOperator(event) {
        const operator = event.target.dataset.value;
        
        // If there's an ongoing calculation, append to it
        if (this.expression && !this.shouldResetInput) {
            this.expression += ` ${this.currentInput} ${operator}`;
        } else {
            this.expression = `${this.currentInput} ${operator}`;
        }
        
        this.shouldResetInput = true;
    }

    handleCalculate() {
        if (!this.expression || this.shouldResetInput) {
            return;
        }

        const fullExpression = `${this.expression} ${this.currentInput}`;
        
        try {
            // Using Function constructor as a safer alternative to eval() for basic math expressions
            const result = new Function(`return ${fullExpression}`)();
            
            this.expression = `${fullExpression} =`;
            this.currentInput = String(result);
            this.shouldResetInput = true;
        } catch (error) {
            this.currentInput = 'Error';
            this.expression = '';
            this.shouldResetInput = true;
        }
    }

    handleClear() {
        this.currentInput = '0';
        this.expression = '';
        this.shouldResetInput = false;
    }
}
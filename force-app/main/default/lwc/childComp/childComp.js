import { LightningElement, api } from 'lwc';

export default class ChildComp extends LightningElement {
    @api childId;
    @api childName;
    @api isSelected = false;

    
    @api
    updateSelectionStatus(status) {
        this.isSelected = status;
    }

    get buttonLabel() {
        return this.isSelected ? 'Deselect' : 'Select';
    }

    get buttonVariant() {
        return this.isSelected ? 'destructive' : 'success';
    }

    handleToggle() {
       
        this.isSelected = !this.isSelected;

        
        const toggleEvent = new CustomEvent('childtoggle', {
            detail: { 
                childId: this.childId, 
                isSelected: this.isSelected 
            },
            bubbles: true,
            composed: true
        });
        
        this.dispatchEvent(toggleEvent);
    }
}
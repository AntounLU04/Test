import { LightningElement } from 'lwc';

export default class ParentComp extends LightningElement {
    child1Selected = true;   
    child2Selected = false;

    get childOneStatus() {
        return this.child1Selected ? 'Selected' : 'Deselected';
    }

    get childTwoStatus() {
        return this.child2Selected ? 'Selected' : 'Deselected';
    }

    handleChildToggle(event) {
        const { childId, isSelected } = event.detail;

        if (childId === 'child1') {
            this.child1Selected = isSelected;
        } else if (childId === 'child2') {
            this.child2Selected = isSelected;
        }

        const targetChild = this.template.querySelector(`c-child-comp[data-id="${childId}"]`);
        if (targetChild) {
            targetChild.updateSelectionStatus(isSelected);
        }
    }
}
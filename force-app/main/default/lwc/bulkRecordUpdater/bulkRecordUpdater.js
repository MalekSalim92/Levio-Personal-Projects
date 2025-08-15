import { LightningElement,wire,api } from 'lwc';
import getAllSalesforceObjects from '@salesforce/apex/BulkRecordUpdaterController.getAllSalesforceObjects';
import getAllFields from '@salesforce/apex/BulkRecordUpdaterController.getAllFields';

export default class BulkRecordUpdater extends LightningElement {

    salesforceObjectOptions = []
    objectFieldsOptions = []
    selectedObject
    selectedField
    error 
    isLoading = true
 
    get isUpdateDisabled(){
        return !this.selectedObject || !this.selectedField
    }
    @wire(getAllSalesforceObjects)
    wiredObject({data,error}){
        if(data){
            this.salesforceObjectOptions = data.map(obj => ({
                label: obj.Label,
                value: obj.QualifiedApiName
            }))
        }
        if(error){
            console.error(error)
        }
        this.isLoading = false

    }

    handleChangeObject(event){
        this.isLoading = true
        this.selectedObject = event.detail.value
        console.log(this.selectedObject)

        this.fetchObjectFields()
    }
    handleSelectFields(event){
        this.selectedField = event.detail.value
        console.log(this.selectedField)
    }

    async fetchObjectFields(){
        if(!this.selectedObject) return;
        try{
            const fields = await getAllFields({objName : this.selectedObject})
            this.objectFieldsOptions = fields.map(field =>({
                label: field.Label,
                value: field.QualifiedApiName
            }))
            console.log(JSON.stringify(this.objectFieldsOptions))
            this.error = undefined;
        }
        catch (error){
            this.objectFieldsOptions = [];
            this.error = error;
        }
        finally{
            this.isLoading = false
        }

    }

    handleClear(){
        this.selectedObject = null;
        this.selectedField = null
    }
}
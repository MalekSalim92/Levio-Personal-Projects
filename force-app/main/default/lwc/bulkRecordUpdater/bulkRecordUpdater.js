import { LightningElement,wire,api } from 'lwc';
import getAllSalesforceObjects from '@salesforce/apex/BulkRecordUpdaterController.getAllSalesforceObjects';

export default class BulkRecordUpdater extends LightningElement {

    salesforceObjectOptions = []

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
    }

    handleChangeObject(event){

    }

    handleClear(){

    }
    handleUpdate(){

    }
}
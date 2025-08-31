import { LightningElement,wire } from 'lwc';
import fetchMetadataItems from '@salesforce/apex/WhereUsedMetadataService.fetchMetadataItems';


export default class WhereUsedLwc extends LightningElement {
    selectedMetadata;
      metadataOptions = [
        { label: "Custom Object" , value : "CustomObject"},
        { label: "Custom Field" , value : "CustomField"},
        { label: "Flow" , value : "Flow"},
        { label: "Apex Class" , value : "ApexClass"},
        { label: "Apex Trigger" , value : "ApexTrigger"},
        { label: "LWC" , value : "LightningComponentBundle"}
        ]
      metadataColumns = [
        { label: "Name" , value : "Name"},
        { label: "Api version" , value : "ApiVersion"}
         ]
    
    connectedCallback(){
        console.log("Component Loaded")
    }
    
        
    handleSelectMetadata(event){
        console.log(event.detail.value);
        this.selectedMetadata = event.detail.value;
    }

    @wire(fetchMetadataItems , {metadataType : '$selectedMetadata'})
    metadataItems;


}
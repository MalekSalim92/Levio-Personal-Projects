import { LightningElement, wire } from 'lwc';
import fetchMetadataItems from '@salesforce/apex/WhereUsedMetadataService.fetchMetadataItems';
import getDependencies from '@salesforce/apex/WhereUsedMetadataService.getDependencies'
export default class WhereUsedLwc extends LightningElement {
    selectedMetadata = 'ApexClass';
    selectedItem = ''
    metadataItems = []; // Raw data from Apex
    displayedItems = []; // Filtered and paginated data for display
    searchTerm = '';
    currentPage = 1;
    pageSize = 10;
    totalItems = 0;
    clickedId
    dependencies = []
    metadataOptions = [ 
        { label: "Custom Object", value: "CustomObject", icon: "utility:open_folder" },
        { label: "Custom Field", value: "CustomField", icon: "utility:file" },
        { label: "Flow", value: "FlowDefinition", icon: "utility:flow" },
        { label: "Apex Class", value: "ApexClass", icon: "utility:apex" },
        { label: "Apex Trigger", value: "ApexTrigger", icon: "utility:connected_apps" },
        { label: "LWC", value: "LightningComponentBundle", icon: "utility:component_customization" }
    ];

    metadataColumns = [
        { label: "Name", fieldName: "developerName", type: "text" },
        { type: 'action', typeAttributes: { rowActions: [{ label: 'Select', name: 'select_item' }] } }
    ];

    connectedCallback() {
        console.log("Component Loaded");
    }

    handleSelectMetadata(event) {
        console.log('Previous:', this.selectedMetadata);
        this.selectedMetadata = event.detail.name;
        console.log('New:', this.selectedMetadata);
        // Reset search and pagination when changing metadata type
        this.searchTerm = '';
        this.currentPage = 1;
    }

    @wire(fetchMetadataItems, { metadataType: '$selectedMetadata' })
    wiredMetadataItems({ data, error }) {
        if (data) {
            console.log('Wire data received:', JSON.stringify(data));
            this.metadataItems = data; // Store raw data
            this.totalItems = data.length;
            this.updateDisplayedItems();
        }
        if (error) {
            console.error('Wire error:', error);
            this.metadataItems = [];
            this.displayedItems = [];
            this.totalItems = 0;
        }
    }

    async getMetadataDependency(){

        const metadataDependency = await getDependencies({ metadataType : this.selectedMetadata})
        console.log('metadata dependency : ',metadataDependency);
        console.log('clickedId:', this.clickedId, 'type:', typeof this.clickedId);
        console.log('refId from data:', metadataDependency[0].refId, 'type:', typeof metadataDependency[0].refId);

        this.dependencies = metadataDependency.filter(item => item.refId == String(this.clickedId));
        console.log('metadata dependency 0: ',this.dependencies[0]);

       this.dependencies.forEach(item => {
            console.log(item.name, item.type);
        });
                                
    }

    handleClick(event) {
        this.clickedId = event.currentTarget.dataset.id;
        console.log('Clicked row ID:', this.clickedId);

        const clickedItem = this.metadataItems.find(item => item.id === this.clickedId);
        console.log('Clicked metadata item:', clickedItem);
        this.getMetadataDependency();
        // You can dispatch a custom event or navigate here
        // Example: this.dispatchEvent(new CustomEvent('itemselected', { detail: clickedItem }));
    }

    handleSearch(event) {
        console.log('Search value:', event.target.value);
        this.searchTerm = event.target.value.toLowerCase();
        this.currentPage = 1; // Reset to first page
        this.updateDisplayedItems();
    }

    updateDisplayedItems() {
        console.log('----- updateDisplayedItems -------');
        
        // Start with metadataItems directly
        let filtered = Array.isArray(this.metadataItems) ? [...this.metadataItems] : [];
        console.log('Raw items count:', filtered.length);

        // Apply search filter
        if (this.searchTerm) {
            filtered = filtered.filter(item => {
                return item.developerName && 
                       item.developerName.toLowerCase().includes(this.searchTerm);
            });
            console.log('Filtered items count:', filtered.length);
        }

        // Calculate pagination
        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;
        this.displayedItems = filtered.slice(start, end);
        
        console.log('Displayed items:', this.displayedItems.length);
        console.log('Page:', this.currentPage, 'Start:', start, 'End:', end);
    }

    // Pagination controls
    handleNextPage() {
        console.log('this.currentPage **** : ',this.currentPage)

        const totalFilteredItems = this.getFilteredItemsCount();
        const totalPages = Math.ceil(totalFilteredItems / this.pageSize);
        console.log('totalPages **** : ',totalPages)

        if (this.currentPage < totalPages) {
            this.currentPage++;
            this.updateDisplayedItems();
        }

         console.log('this.currentPage **** : ',this.currentPage)
    }

    handlePrevPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.updateDisplayedItems();
        }
    }

    // Helper method to get filtered items count
    getFilteredItemsCount() {
        if (!this.searchTerm) {
            console.log('ff');
            return this.metadataItems.length;
        }
        
        return this.metadataItems.filter(item => {
            return item.developerName && 
                   item.developerName.toLowerCase().includes(this.searchTerm);
        }).length;
    }

    // Getters for template
    get totalPages() {
        const totalFilteredItems = this.getFilteredItemsCount();
        return Math.ceil(totalFilteredItems / this.pageSize);
    }

    get disablePrevious() {
        return this.currentPage == 1;
    }

    get disableNext() {
        return this.currentPage == this.totalPages;
    }

    get showPagination() {
        return this.totalPages > 1;
    }

    get showNoResults() {
        return this.metadataItems.length > 0 && this.displayedItems.length === 0 && this.searchTerm;
    }

    get showNoData() {
        return this.metadataItems.length === 0;
    }
}
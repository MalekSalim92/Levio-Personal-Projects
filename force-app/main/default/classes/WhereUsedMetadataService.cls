public with sharing class WhereUsedMetadataService {
        
    @AuraEnabled
    public static List<MetadataItem> fetchMetadataItems(String metadataType) {
        List<MetadataItem> metadataItems = new List<MetadataItem>();
        
        try {
            switch on metadataType {
             
                when 'ApexClass' {
                    metadataItems = fetchApexClasses();
                }

                when else {
                    throw new AuraHandledException('Unsupported metadata type: ' + metadataType);
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching metadata: ' + e.getMessage());
        }

        return metadataItems;
    }


    private static List<MetadataItem> fetchApexClasses() {
        List<MetadataItem> items = new List<MetadataItem>();
        system.debug('classes here');
        List<ApexClass> apexClasses = [SELECT Id, Name, NamespacePrefix, ApiVersion 
                                      FROM ApexClass 
                                      ORDER BY Name];
                                      system.debug('Apex class : ' + apexClasses);
        for (ApexClass cls : apexClasses) {
            items.add(new MetadataItem(
                cls.Id,
                cls.Name,
                cls.Name, // ApexClass doesn't have MasterLabel
                cls.NamespacePrefix
            ));
        }
        
        return items;
    }

    
    // Wrapper class for metadata items
    public class MetadataItem {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String developerName { get; set; }
        @AuraEnabled public String masterLabel { get; set; }
        @AuraEnabled public String namespacePrefix { get; set; }
        
        public MetadataItem(String id, String developerName, String masterLabel, String namespacePrefix) {
            this.id = id;
            this.developerName = developerName;
            this.masterLabel = masterLabel;
            this.namespacePrefix = namespacePrefix;
        }
    }
}
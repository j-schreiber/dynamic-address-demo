public class DemoAddressController {

    public static final String PARAM_TEMPLATE_ID = 'templateId';
    public static final String PARAM_RECORD_ID = 'id';

    public static PdfTemplate__c Template {
        public get {
            if (Template == null && TemplateId != null) {
                Template = [SELECT Id,AddressFormatting__c,DateFormatting__c,Description__c,IsActive__c,LetterFormat__c,TaxDisplayOptions__c FROM PdfTemplate__c WHERE Id = :TemplateId];
            }
            return Template;
        }
        private set;
    }

    public static Quote QuoteRecord {
        public get {
            if (QuoteRecord == null) {
                QuoteRecord = [SELECT Id,CreatedDate,BillingStreet,BillingPostalCode,BillingCity,BillingCountryCode,BillingStateCode FROM Quote WHERE Id = :RecordId];
            }
            return QuoteRecord;
        }
        private set;
    }

    public static String TemplateId {
        public get {
            if (String.isNotBlank(ApexPages.currentPage().getParameters().get(PARAM_TEMPLATE_ID))) {
                TemplateId = ApexPages.currentPage().getParameters().get(PARAM_TEMPLATE_ID);
            }
            return TemplateId;
        }
        private set;
    }

    public static String RecordId {
        public get {
            if (String.isNotBlank(ApexPages.currentPage().getParameters().get(PARAM_RECORD_ID))) {
                RecordId = ApexPages.currentPage().getParameters().get(PARAM_RECORD_ID);
            }
            return RecordId;
        }
        private set;
    }

    public static Component.Apex.PageBlock DynamicAddress {
        public get {
            if (DynamicAddress == null && Template != null && String.isNotBlank(Template.AddressFormatting__c)) {
                DynamicAddress dynAddr = new DynamicAddress(Template.AddressFormatting__c);
                dynAddr.RecordVariableName = 'QuoteRecord';
                DynamicAddress = dynAddr.getAddressAsPageBlock();
            }
            return DynamicAddress;
        }
        private set;
    }

    public static String DateFormatting {
        public get {
            if (DateFormatting == null) {
                if (String.isNotBlank(Template.DateFormatting__c)) {
                    DateFormatting = '{0, date, '+ Template.DateFormatting__c +'}';
                } else {
                    DateFormatting = '{0, date, dd.MM.yyyy}';
                }
            }
            return DateFormatting;
        }
        private set;
    }

}

public with sharing class DynamicAddress {

    private final String ADDRESS_LINE_REGEXP = '(<\\s*p[^>]*>(.*?)<\\s*\\/\\s*p>)';
    private final String MERGE_FIELD_REGEXP = '(\\{![a-zA-Z_ ]+\\})';
    private final String FORMATTER_STRING;

    private System.Pattern MergeFieldPattern = Pattern.compile(MERGE_FIELD_REGEXP);
    private System.Pattern AddressLinePattern = Pattern.compile(ADDRESS_LINE_REGEXP);

    public String RecordVariableName {public get; public set;}

    public DynamicAddress(String formatterString) {
        this.FORMATTER_STRING = formatterString;
    }

    /**
     * @description
     * Returns the formatter string that was used to initialize this dynamic address and that
     * is analyzed to generate the dynamic address content block
     * 
     * @return                  The formatter string
     */
    public String getFormatterString() {
        return FORMATTER_STRING;
    }

    /**
     * @description
     * Analyzes the formatter string for any address lines and breaks up the address lines
     * in an ordered list
     * 
     * @return                  List of address lines
     */
    public List<String> getAddressLines() {
        List<String> addressLines = new List<String>();
        if (!FORMATTER_STRING.startsWith('<p>') || !FORMATTER_STRING.endsWith('</p>')) return addressLines;
        System.Matcher addressLineMatcher = AddressLinePattern.matcher(FORMATTER_STRING);
        do {
            if (addressLineMatcher.find()) {
                addressLines.add(addressLineMatcher.group(2));
            }
        } while (!addressLineMatcher.hitEnd());
        return addressLines;
    }

    /**
     * @description
     * Analyzes the input string and returns the visualforce outputField and outputText
     * components that correspond to the content of the input string
     * 
     * @param   addressLine         The address line to break up into visualforce components
     *
     * @return                      Ordered list of visualforce components
     */
    public List<ApexPages.Component> getVisualforceComponentsForAddressLine(String addressLine) {
        List<ApexPages.Component> cmps = new List<ApexPages.Component>();

        System.Matcher mergeFieldMatcher = MergeFieldPattern.matcher(addressLine);
        Integer previousMatchEnd = 0;
        do {
            if (mergeFieldMatcher.find()) {

                // add plain text content from before this match
                if (previousMatchEnd + 1 < addressLine.length() && mergeFieldMatcher.start() - 1 > 0) {
                    Component.Apex.OutputText rawText = new Component.Apex.OutputText();
                    rawText.value = addressLine.substring(previousMatchEnd, mergeFieldMatcher.start());
                    cmps.add(rawText);
                }

                Component.Apex.OutputField mergeField = new Component.Apex.OutputField();
                if (String.isNotBlank(this.RecordVariableName)) {
                    mergeField.expressions.value = mergeFieldMatcher.group().replace('{!', '{!' + this.RecordVariableName + '.');
                    System.debug(mergeField.expressions.value);
                } else {
                    mergeField.expressions.value = mergeFieldMatcher.group();
                }
                cmps.add(mergeField);
                previousMatchEnd = mergeFieldMatcher.end();
            }
        } while (!mergeFieldMatcher.hitEnd());

        // add plain text content from the end of the string
        if (previousMatchEnd < addressLine.length() && mergeFieldMatcher.hitEnd()) {
            Component.Apex.OutputText rawText = new Component.Apex.OutputText();
            rawText.value = addressLine.substring(previousMatchEnd);
            rawText.escape = false;
            cmps.add(rawText);
        }

        return cmps;
    }

    /**
     * @description
     * Generates a dynamic Visualforce PageBlock from the address line that translates all merge fields
     * to `apex:outputField` - components and any raw text to `apex:outputText` - components. Line breaks
     * are added as `<br>`.
     * 
     * @return                      PageBlock that is dynamically generated from the address formatting
     */
    public Component.Apex.PageBlock getAddressAsPageBlock() {
        Component.Apex.PageBlock addr = new Component.Apex.PageBlock();

        for (String addressLine : getAddressLines()) {
            addr.childComponents.addAll(getVisualforceComponentsForAddressLine(addressLine));
            Component.Apex.OutputText lineBreak = new Component.Apex.OutputText();
            lineBreak.escape = false;
            lineBreak.value = '<br>';
            addr.childComponents.add(lineBreak);

        }

        return addr;
    }
}

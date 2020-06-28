@isTest
public with sharing class DynamicAddress_Test {

    @isTest
    static void init_AddressFormattingRawString_NoError() {
        // ARRANGE
        DynamicAddress da = new DynamicAddress('Text without Lines');
        // ASSERT
        System.assertEquals('Text without Lines', da.getFormatterString(), 'getFormatterString()');
    }

    @isTest
    static void init_ValidAddressFormatting_NoError() {
        // ARRANGE
        DynamicAddress da = new DynamicAddress('<p>Text with single line</p>');
        // ASSERT
        System.assertEquals('<p>Text with single line</p>', da.getFormatterString(), 'getFormatterString()');
    }

    @isTest
    static void getAddressLines_NoParagraphsInFormattingString_ZeroLines() {
        // ARRANGE
        DynamicAddress da = new DynamicAddress('Text with single line');
        // ACT
        List<String> addrLines = da.getAddressLines();
        // ASSERT
        System.assertEquals(0, addrLines.size(), 'getAddressLines().size()');
    }

    @isTest
    static void getAddressLines_InvalidParagraphsInFormattingString_ZeroLines() {
        // ARRANGE
        DynamicAddress da = new DynamicAddress('<p>Text with single line</ul>');
        // ACT
        List<String> addrLines = da.getAddressLines();
        // ASSERT
        System.assertEquals(0, addrLines.size(), 'getAddressLines().size()');
    }

    @isTest
    static void getAddressLines_OneParagraphsInFormattingString_SingleLine() {
        // ARRANGE
        DynamicAddress da = new DynamicAddress('<p>Text with single line</p>');
        // ACT
        List<String> addrLines = da.getAddressLines();
        // ASSERT
        System.assertEquals(1, addrLines.size(), 'getAddressLines().size()');
        System.assertEquals('Text with single line', addrLines.get(0), 'getAddressLines().get(0)');
    }

    @isTest
    static void getAddressLines_MultipleParagraphsInFormattingString_MultipleLines() {
        // ARRANGE
        DynamicAddress da = new DynamicAddress('<p>Text with single line</p><p>{! MergeField }</p><p></p>');
        // ACT
        List<String> addrLines = da.getAddressLines();
        // ASSERT
        System.assertEquals(3, addrLines.size(), 'getAddressLines().size()');
        System.assertEquals('Text with single line', addrLines.get(0), 'getAddressLines().get(0)');
        System.assertEquals('{! MergeField }', addrLines.get(1), 'getAddressLines().get(1)');
        System.assertEquals('', addrLines.get(2), 'getAddressLines().get(2)');
    }

    @isTest
    static void getVisualforceComponentsForAddressLine_RawTextOnly_ApexOutputText() {
        // ARRANGE
        DynamicAddress da = new DynamicAddress('<p>Text with single line</p>');
        // ACT
        List<ApexPages.Component> cmps = da.getVisualforceComponentsForAddressLine('Text with single line');
        // ASSERT
        System.assertEquals(1, cmps.size(), 'size()');
        System.assertEquals(true, cmps[0] instanceof Component.Apex.OutputText, 'instance of [0]');
        System.assertEquals('Text with single line', ((Component.Apex.OutputText)cmps[0]).value, '[0].value');
    }

    @isTest
    static void getVisualforceComponentsForAddressLine_RawTextWithMergeField_ApexOutputTextAndField() {
        // ARRANGE
        DynamicAddress da = new DynamicAddress('<p>Raw Text: {!MergeField}</p>');
        // ACT
        List<ApexPages.Component> cmps = da.getVisualforceComponentsForAddressLine('Raw Text: {!MergeField}');
        // ASSERT
        System.assertEquals(2, cmps.size(), 'size()');
        System.assertEquals(true, cmps[0] instanceof Component.Apex.OutputText, 'instance of [0]');
        System.assertEquals('Raw Text: ', ((Component.Apex.OutputText)cmps[0]).value, '[0].value');
        System.assertEquals(true, cmps[1] instanceof Component.Apex.OutputField, 'instance of [1]');
        System.assertEquals('{!MergeField}', ((Component.Apex.OutputField)cmps[1]).expressions.value, '[1].expressions.value');
    }

    @isTest
    static void getVisualforceComponentsForAddressLine_SetRecordVariableAndMergeField_ApexOutputField() {
        // ARRANGE
        DynamicAddress da = new DynamicAddress('<p>{!MergeField}</p>');
        da.RecordVariableName = 'QuoteRecord';
        // ACT
        List<ApexPages.Component> cmps = da.getVisualforceComponentsForAddressLine('{!MergeField}');
        // ASSERT
        System.assertEquals(1, cmps.size(), 'size()');
        System.assertEquals(true, cmps[0] instanceof Component.Apex.OutputField, 'instance of [0]');
        System.assertEquals('{!QuoteRecord.MergeField}', ((Component.Apex.OutputField)cmps[0]).expressions.value, '[0].expressions.value');
    }

    @isTest
    static void getVisualforceComponentsForAddressLine_MergeFieldInBetweenText_ApexOutputTextsAndField() {
        // ARRANGE
        DynamicAddress da = new DynamicAddress('<p>D-{!MergeField}, Text</p>');
        // ACT
        List<ApexPages.Component> cmps = da.getVisualforceComponentsForAddressLine('D-{!MergeField}, Text');
        // ASSERT
        System.assertEquals(3, cmps.size(), 'size()');
        System.assertEquals(true, cmps[0] instanceof Component.Apex.OutputText, 'instance of [0]');
        System.assertEquals('D-', ((Component.Apex.OutputText)cmps[0]).value, '[0].value');
        System.assertEquals(true, cmps[1] instanceof Component.Apex.OutputField, 'instance of [1]');
        System.assertEquals('{!MergeField}', ((Component.Apex.OutputField)cmps[1]).expressions.value, '[1].expressions.value');
        System.assertEquals(true, cmps[2] instanceof Component.Apex.OutputText, 'instance of [2]');
        System.assertEquals(', Text', ((Component.Apex.OutputText)cmps[2]).value, '[2].value');
    }

    @isTest
    static void getAddressAsPageBlock_MergeFieldNoRecordVariable_RawMergeField() {
        // ARRANGE
        DynamicAddress da = new DynamicAddress('<p>Raw Text</p><p>{! MergeFieldOne }, {!MergeFieldTwo__c}</p>');

        // ACT
        Component.Apex.PageBlock dynAddr = da.getAddressAsPageBlock();

        // ASSERT
        System.assertEquals(2, da.getAddressLines().size(), 'getAddressLines().size()');
        System.assertEquals(6, dynAddr.childComponents.size(), 'childComponents().size()');
    }

}

/** This script expects at least the Standard Price Book to exist in the org. It must be run after at least
*   ony pricebook has been created by force:data:import or manually and after createPrices.apex has been run.
*
*   It adds line items for selected test quotes and opportunities
*/

Pricebook2 customPricebook = [SELECT Id,Name FROM Pricebook2 WHERE Name LIKE '%Colonial Forces%' AND IsActive = true LIMIT 1];

List<Quote> quotes = [SELECT Id,Name FROM Quote];
for (Quote q : quotes) {
    q.Pricebook2Id = customPricebook.Id;
}
update quotes;

List<QuoteLineItem> lineItems = new List<QuoteLineItem>();
for (Quote q : quotes) {
    for (PricebookEntry pbe : [SELECT Id,Product2Id,UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :customPricebook.Id]) {
        lineItems.add(
            new QuoteLineItem(
                QuoteId = q.Id,
                PricebookEntryId = pbe.Id,
                UnitPrice = pbe.UnitPrice,
                Discount = q.Name == 'Super Hangar With Platform (No Discounts)' ? 0 : Decimal.valueOf(Math.random() * 50),
                Quantity = Integer.valueOf(Math.random() * 9 + 1)
            )
        );
    }
}
insert lineItems;
/** This script expects at least the Standard Price Book to exist in the org. It must be run after at least
*   ony pricebook has been created by force:data:import or manually */

/** @Description    This map stores the standard prices for External Ids from Testdata */
Map<String, Decimal> StandardPrices = new Map<String, Decimal>{
    '001-0001' => 500.00,
    '001-0002' => 650.00,
    '001-0003' => 800.00,
    '002-0001' => 1200.00,
    '002-0002' => 1400.00,
    'A-0001' => 9900.00,
    'A-0002' => 14999.00,
    '003-0001' => 275.99,
    '001-007-000070' => 4528.57
};

/** @Description    This map stores the colonial forces prices by External Ids from Testdata */
Map<String, Decimal> ColonialForcesPrices = new Map<String, Decimal>{
    '001-0001' => 350.00,
    '001-0002' => 550.00,
    '001-0003' => 700.00,
    '002-0001' => 1000.00,
    '002-0002' => 1250.00,
    'A-0001' => 7500.00,
    'A-0002' => 13000.00,
    '003-0001' => 233.00,
    '001-007-000070' => 3700.00
};

Pricebook2 standardPricebook = [SELECT Id,Name FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

List<PriceBookEntry> newStandardPrices = new List<PriceBookEntry>();
for (Product2 prod : [SELECT Id,ExternalId FROM Product2 WHERE IsActive = true]) {
    newStandardPrices.add(new PriceBookEntry(
        Pricebook2Id = standardPricebook.Id,
        Product2Id = prod.Id,
        UnitPrice = StandardPrices.containsKey(prod.ExternalId) ? StandardPrices.get(prod.ExternalId) : 1000.00,
        IsActive = true
    ));
}
Database.insert(newStandardPrices, false);

Pricebook2 colonialForcesPb = [SELECT Id,Name FROM Pricebook2 WHERE Name LIKE '%Colonial Forces%' AND IsActive = true LIMIT 1];
List<PriceBookEntry> newColonialForces = new List<PriceBookEntry>();
for (Product2 prod : [SELECT Id,ExternalId FROM Product2 WHERE IsActive = true]) {
    newColonialForces.add(new PriceBookEntry(
        Pricebook2Id = colonialForcesPb.Id,
        Product2Id = prod.Id,
        UnitPrice = ColonialForcesPrices.containsKey(prod.ExternalId) ? ColonialForcesPrices.get(prod.ExternalId) : 1000.00,
        IsActive = true
    ));
}
Database.SaveResult[] srs = Database.insert(newColonialForces, false);
for (Database.SaveResult sr : srs) System.debug(sr);
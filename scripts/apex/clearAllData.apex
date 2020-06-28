delete [SELECT Id FROM Quote];
delete [SELECT Id FROM Opportunity];
delete [SELECT Id FROM Account];
delete [SELECT Id FROM Lead];

List<Product2> products = [SELECT Id FROM Product2];
for (Product2 prod : products) prod.IsActive = false;
update products;

List<Pricebook2> pricebooks = [SELECT Id FROM Pricebook2];
for (Pricebook2 pb : pricebooks) {
    pb.IsActive = false;
}
update pricebooks;
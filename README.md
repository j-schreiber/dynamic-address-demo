This is a demo implementation of my [dynamic address formatting parser](https://lietzau-consulting.de/2020/06/dynamic-address-visualforce-dynamic-component), that allows business users to flexibly configure individual address patterns.
The demo does not implement any error handling and is intended for a technical audience. You can preview the generated PDF by manually calling the visualforce page:
```
https://<your-scratch-org-domain>.com/apex/DemoAddressFormatter?id=<quoteRecordId>&templateId=<pdfTemplateRecordId>
```
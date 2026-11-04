# Frontend

The frontend uses React for migrated authentication screens and Vite to create browser-ready assets. A shared component-polish stylesheet applies consistent focus, hover, motion, and reduced-motion behavior across the existing application pages. PHP endpoints and application rules remain in the existing backend.

The login, registration, and super-administrator login pages are mounted from React entrypoints. The business dashboard applies the enterprise-wide color theme chosen by its administrator, and the super-administration console displays each company's activity type.

Before deploying the enterprise activity type and company theme settings, apply `backend/database/046_enterprise_activity_and_theme.sql` to the application database. Apply `backend/database/047_stock_risk_orders.sql` to enable saved multi-product forecast orders and `backend/database/048_stock_transfers.sql` if the installation does not already have the stock-transfer table. The stock-risk module must also be enabled for each enterprise in the super-administrator's module-access settings. The dashboard calculates MAD and CMM from valid sales and stock exits over 90 days. Pending stock transfers adjust the branch's forecast availability but are not treated as consumption. It flags expiry lots using existing FEFO lot data and compares editable order estimates with open branch cash balances when the user has treasury access. Forecast orders remain drafts until an authorized user transmits them to procurement; transmission creates pending procurement entries and does not change stock before receipt. Forecast orders can be exported to Excel-compatible `.xls` and PDF files.

Forecast orders transmitted to procurement are listed alongside regular pending procurements. Authorized procurement users can enter the actual received quantity, unit entry cost, and (for perishable products) lot expiration date before confirming receipt; stock and lot values are updated only after confirmation.

Company administrators can assign the separate `Gestion des risques de stock` role permission to users. The enterprise must also have the stock-risk module enabled; the risk role grants access to analysis, while creating or transmitting purchase orders still requires procurement rights.

Company administrators can select an enterprise default from the expanded theme palette in settings, including green, teal, blue, navy, purple, pink, red, orange, amber, black, and gray. Each user can also choose a personal interface color in their settings; it only changes that user's interface and can be reset to the company default. Apply `backend/database/049_user_interface_theme.sql` to add the per-user preference before deployment.

From this directory, install dependencies and build the assets:

```sh
npm install
npm run build
```

To rebuild assets automatically while editing, run `npm run watch`. Serve the application through the existing PHP/XAMPP setup so the current backend endpoints remain available.

The generated `build/` directory is required by migrated pages and should be regenerated after frontend changes; it is not committed to source control.

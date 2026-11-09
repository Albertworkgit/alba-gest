# Frontend

The frontend uses React for migrated authentication screens and Vite to create browser-ready assets. A shared component-polish stylesheet applies consistent focus, hover, motion, and reduced-motion behavior across the existing application pages. PHP endpoints and application rules remain in the existing backend.

The login, registration, and super-administrator login pages are mounted from React entrypoints. The business dashboard applies the enterprise-wide color theme chosen by its administrator, and the super-administration console displays each company's activity type.

Apply database migrations in order, including `backend/database/051_code_barre_produits.sql`, `backend/database/052_autorisation_qr_documents.sql`, and `backend/database/053_jeux_donnees.sql`, before deployment. Migration `050_quantites_fractionnaires.sql` adds fractional quantity tracking and decimal precision; `051` adds unique product barcodes; `052` adds company and branch QR authorization flags, disabled by default; `053` adds the global dataset library, immutable dataset versions, tenant import history, and branch-scoped imported references. Configure `APP_BASE_URL` in the PHP hosting environment to the public `front/index.html` URL; if omitted, QR invoice links use the current application URL. Set the value again when moving to another domain or installation path.

The `Gestion des jeux de données` area is available to stock-authorized company users; importing is restricted to the company administrator and writes only into that company's selected branch. Super-administrators maintain and publish the central datasets. Updates append a version rather than replacing prior versions, and repeat imports skip existing categories, units, products, suppliers, and branch-scoped references. The initial import/export format is UTF-8 CSV compatible with Excel (semicolon-delimited); use the downloadable template for its supported columns. Products require a reference and unit, and their currency must be configured in ALBA-GEST. Categories, units, products, and supplier templates map into the existing company catalog; services, brands, subcategories, product types, and other common items are stored as company/branch-owned reusable references because the current operational catalog has no corresponding tables.

Forecast orders transmitted to procurement are listed alongside regular pending procurements. Authorized procurement users can enter the actual received quantity, unit entry cost, and (for perishable products) lot expiration date before confirming receipt; stock and lot values are updated only after confirmation.

Company administrators can assign the separate `Gestion des risques de stock` role permission to users. The enterprise must also have the stock-risk module enabled; the risk role grants access to analysis, while creating or transmitting purchase orders still requires procurement rights.

Role permission options and displayed permission labels are limited to the modules enabled for the company by the super administrator. Hidden permissions already assigned to an existing role remain preserved when the role is edited.

Company administrators can select an enterprise default from the expanded theme palette in settings, including green, teal, blue, navy, purple, pink, red, orange, amber, black, and gray. Each user can also choose a personal interface color in their settings; it only changes that user's interface and can be reset to the company default. Apply `backend/database/049_user_interface_theme.sql` to add the per-user preference before deployment.

From this directory, install dependencies and build the assets:

```sh
npm install
npm run build
```

To rebuild assets automatically while editing, run `npm run watch`. Serve the application through the existing PHP/XAMPP setup so the current backend endpoints remain available.

The generated `build/` directory is required by migrated pages and should be regenerated after frontend changes; it is not committed to source control.

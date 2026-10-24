# Frontend

The frontend uses React for migrated authentication screens and Vite to create browser-ready assets. A shared component-polish stylesheet applies consistent focus, hover, motion, and reduced-motion behavior across the existing application pages. PHP endpoints and application rules remain in the existing backend.

The login, registration, and super-administrator login pages are mounted from React entrypoints and use the existing teal, sage, and coral brand palette. Their existing form handlers and supporting scripts are retained. The main business dashboard and super-administration console continue using their existing page structure.

From this directory, install dependencies and build the assets:

```sh
npm install
npm run build
```

To rebuild assets automatically while editing, run `npm run watch`. Serve the application through the existing PHP/XAMPP setup so the current backend endpoints remain available.

The generated `build/` directory is required by migrated pages and should be regenerated after frontend changes; it is not committed to source control.

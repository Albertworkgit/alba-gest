const views = {
  dashboard: {label:"Vue d'ensemble", kicker:"TABLEAU DE BORD", title:"Bonjour, <em>voici votre activité.</em>", description:"Indicateurs calculés depuis les données de votre entreprise.", action:"", html:`<div class="dashboard-grid"><article class="stat-card"><span class="stat-label">Produits actifs</span><div class="stat-value" id="dash-products">—</div></article><article class="stat-card"><span class="stat-label">Stock disponible par unité</span><div class="stat-value" id="dash-quantity">—</div></article><article class="stat-card"><span class="stat-label">Alertes de stock</span><div class="stat-value" id="dash-alerts">—</div></article><article class="stat-card"><span class="stat-label">Ventes enregistrées</span><div class="stat-value" id="dash-sales">—</div></article></div><section class="panel table-panel"><div class="panel-header"><div><h2>Stock sous le seuil minimum</h2></div></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Produit</th><th>Succursale</th><th>Quantité</th><th>Seuil</th></tr></thead><tbody id="dash-low-stock"><tr><td colspan="4">Chargement…</td></tr></tbody></table></div></section>`},
  stock: {label:"Stock", kicker:"GESTION DES ARTICLES", title:"Votre stock, <em>toujours maîtrisé.</em>", description:"Suivez les niveaux et les alertes de vos produits.", action:"+ Créer un produit", html:`<section class="panel"><div class="filter-bar"><input class="search-field" id="stock-search" placeholder="Rechercher un article ou une référence"><select class="select-field" id="stock-branch"><option value="">Toutes les succursales</option></select><button class="text-button" data-create-category>+ Créer une catégorie</button><button type="button" class="unit-admin-button" data-create-unit hidden aria-label="G&eacute;rer les unit&eacute;s de mesure"><span class="unit-admin-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none"><path d="M4 7.5 7.5 4l12.5 12.5-3.5 3.5L4 7.5Z"/><path d="m8 8 2-2m1 5 2-2m1 5 2-2m1 5 2-2"/></svg></span><span class="unit-admin-copy"><strong>G&eacute;rer les unit&eacute;s</strong><small>Unit&eacute;s et symboles</small></span><span class="unit-admin-arrow" aria-hidden="true">&#8250;</span></button><button class="text-button" data-toggle-categories>Gérer les catégories</button></div><div class="panel-header"><div><h2>Catalogue produits</h2><p class="panel-subtitle" id="stock-count">Chargement…</p></div></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Référence</th><th>Produit</th><th>Catégorie</th><th>Prix vente</th><th>Unité</th><th>Stock</th><th>Seuil</th><th>État</th><th>Actions</th></tr></thead><tbody id="stock-rows"><tr><td colspan="9">Chargement…</td></tr></tbody></table></div></section><section class="panel" id="category-admin-panel" hidden><div class="panel-header"><div><h2>Catégories de produits</h2><p class="panel-subtitle">Modifiez ou supprimez les catégories de votre entreprise.</p></div></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Catégorie</th><th>Description</th><th>Actions</th></tr></thead><tbody id="category-rows"></tbody></table></div></section>`},
  sales: {label:"Ventes", kicker:"ACTIVITÉ COMMERCIALE", title:"Vos <em>ventes.</em>", description:"Créez des factures multi-produits avec remise et suivi des lots.", action:"+ Nouvelle vente", html:`<section class="panel"><p class="panel-subtitle" id="sales-count">Chargement…</p><div style="overflow:auto"><table class="data-table"><thead><tr><th>Facture</th><th>Client</th><th>Succursale</th><th>Caissier</th><th>Date</th><th>Articles</th><th>Total</th><th>Payé</th><th>Statut</th><th>Actions</th></tr></thead><tbody id="sales-rows"><tr><td colspan="10">Chargement…</td></tr></tbody></table></div></section>`},
  cash: {label:"Caisse", kicker:"TRÉSORERIE", title:"Vos <em>caisses.</em>", description:"Ouvrez, suivez et clôturez les caisses de vos succursales.", action:"＋ Ouvrir une caisse", html:`<section class="panel"><div class="panel-header"><div><h2>Caisses</h2></div><div class="cash-manual-actions"><button type="button" class="cash-action-button cash-action-in" data-cash-movement-open="ENTREE"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 5v14m-7-7h14"/></svg><span>Entrée manuelle</span></button><button type="button" class="cash-action-button cash-action-out" data-cash-movement-open="SORTIE"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h14"/></svg><span>Sortie manuelle</span></button></div></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Caisse</th><th>Succursale</th><th>Monnaie / mode</th><th>Ouverture</th><th>Solde initial</th><th>Solde courant</th><th>Solde clôturé</th><th>Statut</th><th>Actions</th></tr></thead><tbody id="cash-rows"><tr><td colspan="9">Chargement…</td></tr></tbody></table></div></section><section class="panel table-panel"><div class="panel-header"><div><h2>Journal de caisse</h2><p class="panel-subtitle">Encaissements de vente, entrées et sorties</p></div></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Date</th><th>Caisse</th><th>Type</th><th>Mode</th><th>Motif</th><th>Référence</th><th>Montant</th></tr></thead><tbody id="cash-movement-rows"><tr><td colspan="7">Chargement…</td></tr></tbody></table></div></section><section class="panel"><div class="panel-header"><div><h2>Paiements Mobile Money et Banque</h2><p class="panel-subtitle">Règlements Mobile Money et banque enregistrés dans leurs caisses ouvertes.</p></div></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Date</th><th>Opération</th><th>Document</th><th>Succursale</th><th>Mode</th><th>Réf. transaction</th><th>Montant</th></tr></thead><tbody id="external-payment-rows"><tr><td colspan="7">Chargement…</td></tr></tbody></table></div></section>`},
  accounting: {label:"Comptabilité", kicker:"COMPTABILITÉ SYSCOHADA", title:"Vos <em>états financiers.</em>", description:"Consultez les états à partir des écritures comptables validées.", action:"", html:`<section class="panel"><div class="panel-header"><div><h2>Générer un état</h2><p class="panel-subtitle">Les montants sont toujours présentés par monnaie.</p></div><div><button type="button" class="primary-button" data-account-entry-open>Nouvelle écriture</button> <button type="button" class="text-button" data-account-create-open>Créer un compte</button></div></div><div class="filter-bar"><label>État<select id="accounting-report-type"><option value="bilan">Bilan</option><option value="resultat">Compte de résultat</option><option value="flux-tresorerie">Tableau de flux de trésorerie</option><option value="balance">Balance générale</option><option value="journal">Journal</option><option value="grand-livre">Grand livre</option><option value="annexes">États annexes</option></select></label><label>Du<input id="accounting-from" type="date" required></label><label>Au<input id="accounting-to" type="date" required></label><label>Monnaie<select id="accounting-currency" required></select></label><label id="accounting-account-filter" hidden>Compte<select id="accounting-account"><option value="">Sélectionner un compte</option></select></label><button type="button" class="primary-button" data-account-report-load>Générer</button><button type="button" class="text-button" data-account-report-print disabled>Imprimer le rapport choisi</button></div></section><section class="panel" id="accounting-report-panel"><div class="panel-header"><div><h2 id="accounting-report-title">État financier</h2><p class="panel-subtitle" id="accounting-report-meta">Sélectionnez une période, une monnaie et un état.</p></div></div><div id="accounting-report-result"><p class="empty-note">Aucun état généré.</p></div></section><section class="panel"><div class="panel-header"><div><h2>Journal comptable</h2><p class="panel-subtitle">Écritures validées sur la période et dans la monnaie choisies.</p></div></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Date</th><th>Journal</th><th>Référence</th><th>Libellé</th><th>Lignes</th><th>Total débit</th><th>Total crédit</th></tr></thead><tbody id="accounting-entry-rows"><tr><td colspan="7">Chargement…</td></tr></tbody></table></div></section><section class="panel"><div class="panel-header"><div><h2>Plan comptable</h2><p class="panel-subtitle">Comptes de l’entreprise; les comptes système ne peuvent pas être désactivés.</p></div></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Compte</th><th>Intitulé</th><th>Classe</th><th>Nature</th><th>Compte parent</th><th>Statut</th><th>Action</th></tr></thead><tbody id="accounting-account-rows"><tr><td colspan="7">Chargement…</td></tr></tbody></table></div></section>`},
  users: {label:"Utilisateurs et rôles", kicker:"GESTION DES ACCÈS", title:"Les bonnes personnes, <em>les bons accès.</em>", description:"Gérez les comptes utilisateurs et leurs droits d’accès.", action:"+ Ajouter un utilisateur", html:`<div class="view-layout"><section class="panel"><div class="panel-header"><div><h2>Utilisateurs</h2><p class="panel-subtitle">Comptes enregistrés dans votre entreprise</p></div></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Nom complet</th><th>Nom d’utilisateur</th><th>Adresse électronique</th><th>Rôle</th><th>Succursale</th><th>Statut</th><th>Actions</th></tr></thead><tbody id="user-rows"><tr><td colspan="7">Chargement des utilisateurs…</td></tr></tbody></table></div></section><aside class="panel"><h2>Rôles et autorisations</h2><div id="role-list"><p class="empty-note">Chargement des rôles…</p></div><button class="primary-button role-create-action" data-create-role style="width:100%;margin-top:17px"><span aria-hidden="true">+</span> Créer un rôle</button></aside></div>`},
  branches: {label:"Succursales", kicker:"ADMINISTRATION", title:"Vos <em>succursales.</em>", description:"Succursales enregistrées dans la base de données.", action:"+ Créer une succursale", html:`<section class="panel"><div style="overflow:auto"><table class="data-table"><thead><tr><th>Nom</th><th>Code</th><th>Succursale mère</th><th>Adresse</th><th>Téléphone</th><th>Actions</th></tr></thead><tbody id="branch-rows"><tr><td colspan="6">Chargement…</td></tr></tbody></table></div></section>`},
  clients: {label:"Clients", kicker:"RELATION CLIENT", title:"Vos <em>clients.</em>", description:"Clients enregistrés dans la base de données.", action:"", html:`<section class="panel"><div style="overflow:auto"><table class="data-table"><thead><tr><th>Nom</th><th>Adresse électronique</th><th>Téléphone</th><th>Adresse</th></tr></thead><tbody id="client-rows"><tr><td colspan="4">Chargement…</td></tr></tbody></table></div></section>`},
  requests: {label:"Demandes reçues", kicker:"ADMINISTRATION", title:"Demandes reçues", description:"Examinez et traitez les demandes transmises à votre entreprise.", action:"", html:`<section class="panel" data-accounting-cancellation-inbox hidden><div class="panel-header"><div><h2>Demandes d’annulation comptable</h2><p class="panel-subtitle">Une écriture reste active jusqu’à votre approbation.</p></div></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Date</th><th>Écriture</th><th>Demandeur</th><th>Motif</th><th>Décision</th></tr></thead><tbody id="accounting-cancellation-rows"><tr><td colspan="5">Chargement des demandes…</td></tr></tbody></table></div></section><section class="panel" data-cash-cancellation-inbox hidden><div class="panel-header"><div><h2>Demandes d’annulation de caisse</h2><p class="panel-subtitle">L’opération est compensée seulement après votre approbation.</p></div></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Date</th><th>Caisse</th><th>Opération</th><th>Demandeur</th><th>Motif</th><th>Décision</th></tr></thead><tbody id="cash-cancellation-rows"><tr><td colspan="6">Chargement des demandes…</td></tr></tbody></table></div></section><p class="empty-note" data-no-company-requests hidden>Aucune demande reçue.</p>`},
  "branch-dashboard": {label:"Vue de la succursale", kicker:"ESPACE SUCCURSALE", title:"Activité de la <em>succursale.</em>", description:"Indicateurs calculés à partir du stock.", action:"", html:`<div class="dashboard-grid"><article class="stat-card"><span class="stat-label">Produits en stock</span><div class="stat-value" id="branch-product-count">—</div></article><article class="stat-card"><span class="stat-label">Stock disponible par unité</span><div class="stat-value" id="branch-quantity">—</div></article><article class="stat-card"><span class="stat-label">Alertes de seuil</span><div class="stat-value" id="branch-alerts">—</div></article></div>`},
  settings: {label:"Paramètres", kicker:"CONFIGURATION", title:"Votre <em>entreprise.</em>", description:"Modifiez votre profil et votre mot de passe.", action:"", html:`<div class="view-layout"><section class="panel"><h2>Mon profil</h2><p class="panel-subtitle">Entreprise : <strong data-settings-company>—</strong> · Rôle : <strong data-settings-role>—</strong></p><form id="profile-form" class="entity-form" style="margin-top:18px"><label>Nom complet<input name="full_name" data-profile-full-name required></label><label>Nom utilisateur<input name="username" data-profile-username></label><label class="full">Adresse email<input name="email" type="email" data-profile-email required></label><div class="entity-modal-actions full"><button class="modal-submit">Enregistrer le profil</button></div></form></section><section class="panel" id="company-profile-panel" hidden><h2>Profil de l’entreprise</h2><p class="panel-subtitle">Ces informations et images apparaîtront sur les rapports et les bons de l’entreprise et de ses succursales.</p><form id="company-profile-form" class="entity-form company-profile-form" enctype="multipart/form-data"><label>Nom de l’entreprise<input name="name" data-company-name required maxlength="100"></label><label>Adresse électronique<input name="email" type="email" data-company-email maxlength="100"></label><label>Téléphone<input name="phone" data-company-phone maxlength="20"></label><label class="full">Adresse<textarea name="address" data-company-address></textarea></label><label>RCCM<input name="rccm" data-company-rccm maxlength="100"></label><label>Boîte postale (BP)<input name="boite_postale" data-company-bp maxlength="100"></label><div class="company-image-field"><label>Logo de l’entreprise<input type="file" name="logo" accept="image/*" data-company-logo-file><small>Format image accepté, 8 Mo maximum.</small></label><img class="company-image-preview" data-company-logo-preview alt="Logo de l’entreprise" hidden><label class="company-remove-image"><input type="checkbox" name="remove_logo" value="1"> Supprimer le logo actuel</label></div><div class="company-image-field"><label>Sceau / cachet<input type="file" name="cachet" accept="image/png" data-company-stamp-file><small>PNG uniquement, 8 Mo maximum.</small></label><img class="company-image-preview company-stamp-preview" data-company-stamp-preview alt="Cachet de l’entreprise" hidden><label class="company-remove-image"><input type="checkbox" name="remove_cachet" value="1"> Supprimer le cachet actuel</label></div><div class="entity-modal-actions full"><button class="modal-submit">Enregistrer le profil entreprise</button></div></form></section><section class="panel"><h2>Modifier mon mot de passe</h2><p class="panel-subtitle">Confirmez votre mot de passe actuel avant de choisir le nouveau.</p><form id="password-form" class="entity-form" style="margin-top:18px"><label class="full">Mot de passe actuel<input name="current_password" type="password" autocomplete="current-password" required></label><label>Nouveau mot de passe<input name="new_password" type="password" minlength="8" autocomplete="new-password" required></label><label>Confirmer le nouveau mot de passe<input name="confirm_password" type="password" minlength="8" autocomplete="new-password" required></label><div class="entity-modal-actions full"><button class="modal-submit">Modifier le mot de passe</button></div></form></section></div>`},
  procurement: {label:"Approvisionnements", kicker:"ACHATS", title:"Vos <em>approvisionnements.</em>", description:"Enregistrez les entrées et sorties de stock fournisseur.", action:"+ Nouvel approvisionnement", html:`<div class="dashboard-grid procurement-summary"><article class="stat-card"><span class="stat-label">Quantités entrées (validées)</span><div class="stat-value" id="purchase-total-in">0</div></article><article class="stat-card"><span class="stat-label">Quantités sorties (validées)</span><div class="stat-value" id="purchase-total-out">0</div></article><article class="stat-card"><span class="stat-label">Solde net</span><div class="stat-value" id="purchase-balance">0</div></article></div><section class="panel"><div class="panel-header"><div><h2>Approvisionnements enregistr&eacute;s</h2><p class="panel-subtitle">Entr&eacute;es et sorties de stock par p&eacute;riode</p></div><button type="button" class="movement-report-button" data-stock-movement-report>Fiche de stock</button></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Référence</th><th>Motif</th><th>Date</th><th>Quantité</th><th>Quantité sortie</th><th>Quantité entrée</th><th>Solde du lot</th><th>Total</th><th>Statut</th><th>Bon</th></tr></thead><tbody id="purchase-rows"><tr><td colspan="10">Chargement…</td></tr></tbody></table></div></section>`},
  "client-order": {label:"Portail client", kicker:"ESPACE CLIENT", title:"Portail client", description:"Les commandes clients ne sont pas définies dans le schéma actuel.", action:"", html:`<p class="empty-note">Aucune donnée n’est disponible pour ce module.</p>`}
};
let activeBranchId = '';
let branchOptions = [];
const branchScopedResources = new Set(['stocks', 'achats', 'caisses', 'ventes', 'fournisseurs']);
let procurementSummaryTimer = null;
let procurementSummaryRequest = 0;
function canSelectCompanyBranches(user = sessionUser) {
  if (!user) return false;
  if (!user.succursale_id || user.is_company_admin) return true;
  let permissions = user.permissions || [];
  if (typeof permissions === 'string') { try { permissions = JSON.parse(permissions); } catch { permissions = []; } }
  return permissions.includes('toutes_succursales');
}
const container = document.getElementById('view-container');
const title = document.getElementById('page-title');
const description = document.getElementById('page-description');
const kicker = document.getElementById('page-kicker');
const action = document.getElementById('primary-action');
const breadcrumb = document.getElementById('breadcrumb-label');
const toast = document.getElementById('toast');
const routes = {
  '/': 'dashboard',
  '/dashboard': 'dashboard',
  '/stock': 'stock',
  '/approvisionnements': 'procurement',
  '/ventes': 'sales',
  '/caisse': 'cash',
  '/comptabilite': 'accounting',
  '/admin/succursales': 'branches',
  '/admin/clients': 'clients',
  '/client/commande': 'client-order',
  '/admin/utilisateurs': 'users',
  '/succursale/demandes': 'requests',
  '/succursale': 'branch-dashboard',
  '/parametres': 'settings'
};
const viewRoutes = Object.fromEntries(Object.entries(routes).map(([route, view]) => [view, route]));
const themeButton = document.getElementById('theme-button');
const themePanel = document.getElementById('theme-panel');
const themeChoices = document.querySelectorAll('[data-theme-choice]');
const themeStorageKey = 'westock-theme';
let currentViewName = 'dashboard';
let sessionUser = null;

function applyTheme(choice) {
  const systemDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
  const isDark = choice === 'dark' || (choice === 'auto' && systemDark);
  document.documentElement.classList.toggle('dark-theme', isDark);
  themeChoices.forEach(option => option.classList.toggle('selected', option.dataset.themeChoice === choice));
}
function loadTheme() {
  const savedTheme = localStorage.getItem(themeStorageKey) || 'light';
  applyTheme(savedTheme);
}

function showToast(message = 'Action enregistrée') { toast.textContent = message; toast.classList.add('show'); setTimeout(() => toast.classList.remove('show'), 2200); }
function routeFromHash() {
  const hashRoute = window.location.hash.replace(/^#/, '') || '/';
  return routes[hashRoute] || 'dashboard';
}
function navigate(viewName, replace = false) {
  // Refuse aussi les URL directes vers une vue absente du menu de cet utilisateur.
  if (sessionUser) {
    const menuItem = [...document.querySelectorAll('.nav-item[data-view]')].find(item => item.dataset.view === viewName);
    if (menuItem?.hidden) {
      const firstAllowed = [...document.querySelectorAll('.nav-item[data-view]')].find(item => !item.hidden);
      viewName = firstAllowed?.dataset.view || 'settings';
      replace = true;
    }
  }
  const route = viewRoutes[viewName] || '/';
  const nextUrl = `#${route}`;
  if (replace) window.history.replaceState({view: viewName}, '', nextUrl);
  else if (window.location.hash !== nextUrl) window.location.hash = route;
  renderView(viewName);
}
function renderModuleNavigation() {
  const navigation = document.getElementById('module-section-nav');
  if (!navigation) return;
  navigation.replaceChildren();
  const panels = [...container.querySelectorAll('.panel')].filter(panel => {
    if (!panel.hidden) return true;
    if (currentViewName !== 'stock' || !panel.hasAttribute('data-stock-section-panel')) return false;
    const section = panel.dataset.stockSectionPanel;
    return section === 'products' || (section === 'categories' && hasAccess('voir_stock')) ||
      (section === 'suppliers' && hasAccess('voir_fournisseurs')) ||
      (section === 'procurement' && hasAccess('voir_approvisionnements'));
  });
  const items = panels.map((panel, index) => {
    const heading = panel.querySelector('.panel-header h2, h2, h3');
    if (!panel.id) panel.id = `module-section-${currentViewName}-${index + 1}`;
    return {panel, label:heading?.textContent.trim() || views[currentViewName]?.label || 'Section', id:panel.id};
  });
  if (!items.length) {
    const heading = document.querySelector('.page-heading');
    if (!heading) {
      navigation.hidden = true;
      return;
    }
    heading.id = `module-section-${currentViewName}-overview`;
    items.push({panel:heading, label:'Vue générale', id:heading.id});
  }
  navigation.setAttribute('aria-label', `Sections du module ${views[currentViewName]?.label || ''}`);
  navigation.innerHTML = `<span class="module-section-title">Dans ce module</span>${items.map(item => `<a href="#${encodeURIComponent(item.id)}">${escapeHtml(item.label)}</a>`).join('')}`;
  if (!navigation.dataset.bound) {
    navigation.dataset.bound = 'true';
    navigation.addEventListener('click', event => {
      const link = event.target.closest('a[href^="#"]');
      if (!link) return;
      const panel = document.getElementById(decodeURIComponent(link.hash.slice(1)));
      if (!panel) return;
      event.preventDefault();
      if (currentViewName === 'stock' && panel.dataset.stockSectionPanel) selectStockSection(panel.dataset.stockSectionPanel);
      panel.scrollIntoView({behavior:'smooth', block:'start'});
      panel.setAttribute('tabindex', '-1');
      panel.focus({preventScroll:true});
    });
  }
  navigation.hidden = false;
}
function renderView(viewName) {
  const view = views[viewName] || views.dashboard;
  currentViewName = viewName;
  document.querySelectorAll('.nav-item').forEach(item => item.classList.toggle('active', item.dataset.view === viewName));
  kicker.textContent = view.kicker; title.innerHTML = view.title; description.textContent = view.description; breadcrumb.textContent = view.label; action.innerHTML = view.action; action.hidden = !view.action || (viewName === 'stock' && !hasAccess('creer_produit')) || (viewName === 'procurement' && !hasAccess('creer_approvisionnements')) || (viewName === 'sales' && !hasAccess('creer_ventes')) || (viewName === 'cash' && !hasAccess('creer_caisse')) || (viewName === 'users' && !hasAccess('gerer_utilisateurs')) || (viewName === 'branches' && !hasAccess('*')); action.classList.toggle('user-create-action', viewName === 'users');
  container.innerHTML = view.html;
  if (viewName === 'accounting') renderAccountingDraftPanel(container);
  if (viewName === 'stock') configureStockWorkspace();
  configureReportToolbar(viewName);
  renderModuleNavigation();
  if (viewName === 'accounting') {
    const entryButton = container.querySelector('[data-account-entry-open]');
    const accountButton = container.querySelector('[data-account-create-open]');
    if (entryButton) entryButton.hidden = !hasAccess('creer_comptabilite');
    if (accountButton) accountButton.hidden = !hasAccess('modifier_comptabilite');
    const entriesTable = container.querySelector('#accounting-entry-rows')?.closest('table');
    if (entriesTable?.tHead?.rows[0]) {
      const actionHeader = document.createElement('th');
      actionHeader.textContent = 'Annulation';
      entriesTable.tHead.rows[0].append(actionHeader);
    }
  }
  if (viewName === 'requests') {
    const inbox = container.querySelector('[data-accounting-cancellation-inbox]');
    const cashInbox = container.querySelector('[data-cash-cancellation-inbox]');
    const emptyMessage = container.querySelector('[data-no-company-requests]');
    const isCompanyAdmin = Boolean(sessionUser?.is_company_admin);
    if (inbox) inbox.hidden = !isCompanyAdmin;
    if (cashInbox) cashInbox.hidden = !isCompanyAdmin;
    if (emptyMessage) emptyMessage.hidden = isCompanyAdmin;
    if (isCompanyAdmin) {
      loadEntryCancellationRequests();
      loadCashMovementCancellationRequests();
    }
  }
  const categoryButton = container.querySelector('[data-create-category]');
  if (categoryButton) categoryButton.hidden = !hasAccess('modifier_stock');
  const categoryManagementButton = container.querySelector('[data-toggle-categories]');
  if (categoryManagementButton) categoryManagementButton.hidden = !hasAccess('modifier_stock');
  const unitManagementButton = container.querySelector('[data-create-unit]');
  if (unitManagementButton) unitManagementButton.hidden = !sessionUser?.is_company_admin;
  container.querySelectorAll('[data-stock-movement-report]').forEach(button => { button.hidden = !hasAnyAccess('voir_stock', 'voir_approvisionnements'); button.textContent = 'Afficher fiche de stock'; });
  if (sessionUser) {
    container.querySelectorAll('[data-settings-company]').forEach(node => node.textContent = sessionUser.enterprise_name || '—');
    container.querySelectorAll('[data-settings-user]').forEach(node => node.textContent = sessionUser.full_name || sessionUser.email || '—');
    container.querySelectorAll('[data-settings-role]').forEach(node => node.textContent = sessionUser.role_name || 'Utilisateur');
    const fullNameInput = container.querySelector('[data-profile-full-name]');
    const usernameInput = container.querySelector('[data-profile-username]');
    const emailInput = container.querySelector('[data-profile-email]');
    const companyPanel = container.querySelector('#company-profile-panel');
    if (companyPanel) {
      companyPanel.hidden = !sessionUser.is_company_admin;
      companyPanel.querySelector('[data-company-name]').value = sessionUser.enterprise_name || '';
      companyPanel.querySelector('[data-company-email]').value = sessionUser.enterprise_email || '';
      companyPanel.querySelector('[data-company-phone]').value = sessionUser.enterprise_phone || '';
      companyPanel.querySelector('[data-company-address]').value = sessionUser.enterprise_address || '';
      companyPanel.querySelector('[data-company-rccm]').value = sessionUser.enterprise_rccm || '';
      companyPanel.querySelector('[data-company-bp]').value = sessionUser.enterprise_boite_postale || '';
      setCompanyImagePreview(companyPanel.querySelector('[data-company-logo-preview]'), sessionUser.enterprise_logo);
      setCompanyImagePreview(companyPanel.querySelector('[data-company-stamp-preview]'), sessionUser.enterprise_cachet);
      companyPanel.querySelector('[data-company-logo-file]').addEventListener('change', event => previewSelectedImage(event.target, companyPanel.querySelector('[data-company-logo-preview]')));
      companyPanel.querySelector('[data-company-stamp-file]').addEventListener('change', event => previewSelectedImage(event.target, companyPanel.querySelector('[data-company-stamp-preview]')));
    }
    if (fullNameInput) fullNameInput.value = sessionUser.full_name || '';
    if (usernameInput) { usernameInput.value = sessionUser.username || ''; usernameInput.closest('label').hidden = sessionUser.type === 'super_admin'; }
    if (emailInput) emailInput.value = sessionUser.email || '';
  }
  container.querySelectorAll('[data-view-link]').forEach(link => link.addEventListener('click', () => navigate(link.dataset.viewLink)));
  if (viewName === 'stock') {
    loadStock();
    if (hasAccess('voir_fournisseurs')) loadSupplierRows();
    if (hasAccess('voir_approvisionnements')) loadPurchaseRows();
  }
  if (viewName === 'users') {
    const userPanel = container.querySelector('#user-rows')?.closest('section');
    const rolePanel = container.querySelector('#role-list')?.closest('aside');
    if (userPanel) userPanel.hidden = !hasAccess('gerer_utilisateurs');
    if (rolePanel) rolePanel.hidden = !hasAccess('voir_roles') && !hasAccess('gerer_roles');
    const createRole = container.querySelector('[data-create-role]');
    if (createRole) createRole.hidden = !hasAccess('gerer_roles');
    if (hasAccess('voir_roles') || hasAccess('gerer_roles')) loadRoleList();
    if (hasAccess('gerer_utilisateurs')) loadUserRows();
  }
  if (viewName === 'dashboard') { loadDashboardData(); loadExpiringStock(); }
  if (viewName === 'sales') loadSalesRows();
  if (viewName === 'cash') loadCashRows();
  if (viewName === 'accounting') loadAccountingData();
  if (viewName === 'branches') loadSimpleRows('succursales', 'branch-rows', 6, row => `<tr><td>${escapeHtml(row.name)}</td><td>${escapeHtml(row.code)}</td><td>${Number(row.est_sucursal_mere) ? '<span class="status success">Principale</span>' : '—'}</td><td>${escapeHtml(row.address || '—')}</td><td>${escapeHtml(row.phone || '—')}</td><td><button class="text-button" data-branch-edit="${Number(row.succursale_id)}">Modifier</button> <button class="text-button" data-branch-delete="${Number(row.succursale_id)}">Supprimer</button></td></tr>`, 'Aucune succursale enregistrée.');
  if (viewName === 'clients') loadSimpleRows('clients', 'client-rows', 4, row => `<tr><td>${escapeHtml(row.name)}</td><td>${escapeHtml(row.email || '—')}</td><td>${escapeHtml(row.phone || '—')}</td><td>${escapeHtml(row.address || '—')}</td></tr>`, 'Aucun client enregistré.');
  if (viewName === 'procurement') loadPurchaseRows();
  if (viewName === 'branch-dashboard') { loadBranchDashboard(); loadExpiringStock(); }
  if (viewName === 'stock') loadExpiringStock();
  window.scrollTo({top: 0, behavior: 'smooth'});
}
const reportableViews = new Set(['dashboard', 'stock', 'sales', 'cash', 'accounting', 'procurement', 'users', 'branches', 'clients', 'branch-dashboard']);
function configureReportToolbar(viewName) {
  if (!reportableViews.has(viewName)) return;
  const toolbar = document.createElement('div');
  toolbar.className = 'report-toolbar';
  toolbar.dataset.reportToolbar = '';
  toolbar.innerHTML = '<strong>Rapports</strong><label>Du <input type="date" data-report-from></label><label>Au <input type="date" data-report-to></label><input type="search" data-report-search placeholder="Produit, client, statut…" aria-label="Filtrer le rapport"><span data-report-filter-hint>Filtres appliqués à l’aperçu, à l’impression et à l’export.</span><div class="report-toolbar-actions"><button type="button" data-report-action="preview">Afficher</button><button type="button" data-report-action="print">Imprimer</button><button type="button" data-report-action="pdf">Exporter en PDF</button><button type="button" data-report-action="excel">Exporter vers Excel</button></div>';
  if (viewName === 'cash') {
    const label=document.createElement('label');label.textContent='Rapport ';const select=document.createElement('select');select.dataset.reportKind='';
    if(hasAccess('voir_ventes'))select.add(new Option('Ventes','sales'));
    if(hasAccess('voir_caisse'))select.add(new Option('Journal de caisse','cash'));
    select.value=viewName==='cash'?'cash':'sales';if(!select.value&&select.options.length)select.selectedIndex=0;label.append(select);toolbar.insertBefore(label,toolbar.querySelector('[data-report-from]').closest('label'));
  }
  container.prepend(toolbar);
}
function reportDateColumn(row = null) {
  if (currentViewName === 'sales') return 4;
  if (currentViewName === 'cash') return row?.closest('tbody')?.id === 'cash-movement-rows' ? 0 : 3;
  if (currentViewName === 'stock' && container.querySelector('[data-stock-section].active')?.dataset.stockSection === 'procurement') return 2;
  if (currentViewName === 'procurement') return 2;
  return -1;
}
function reportFilterValues() {
  return {from:container.querySelector('[data-report-from]')?.value || '', to:container.querySelector('[data-report-to]')?.value || '', search:(container.querySelector('[data-report-search]')?.value || '').trim().toLocaleLowerCase('fr')};
}
function formatReportDate(value) {
  if (!value) return '';
  return new Date(`${value}T00:00:00`).toLocaleDateString('fr-FR');
}
function stockReportPeriod(filters, movements) {
  const firstMovement = movements[0]?.movement_date ? String(movements[0].movement_date).slice(0, 10) : '';
  const lastMovement = movements.length ? String(movements[movements.length - 1].movement_date).slice(0, 10) : '';
  const from = filters.from || firstMovement;
  const to = filters.to || lastMovement;
  if (from && to) return `du ${formatReportDate(from)} au ${formatReportDate(to)}`;
  if (from) return `à partir du ${formatReportDate(from)}`;
  if (to) return `jusqu’au ${formatReportDate(to)}`;
  return 'toutes périodes';
}
function filterCurrentReport() {
  const {from, to, search} = reportFilterValues();
  currentReportSource().querySelectorAll('[data-report-total]').forEach(row => row.remove());
  currentReportSource().querySelectorAll('table tbody tr').forEach(row => {
    if (row.dataset.reportTotal === 'true') { row.hidden = false; return; }
    const dateText = reportDateColumn(row) >= 0 ? (row.dataset.reportDate || '') : '';
    const dateMatch = !dateText || ((!from || dateText >= from) && (!to || dateText <= to));
    row.hidden = !(dateMatch && (!search || row.textContent.toLocaleLowerCase('fr').includes(search)));
  });
  const hint = container.querySelector('[data-report-filter-hint]');
  if (hint) hint.textContent = [from && `Du ${from}`, to && `au ${to}`, search && `Recherche : ${search}`].filter(Boolean).join(' · ') || 'Aucun filtre actif';
  updateProcurementSummary();
}
function updateProcurementSummary() {
  if (currentViewName !== 'procurement' && !(currentViewName === 'stock' && container.querySelector('[data-stock-section].active')?.dataset.stockSection === 'procurement')) return;
  const {from, to, search} = reportFilterValues();
  const requestId = ++procurementSummaryRequest;
  clearTimeout(procurementSummaryTimer);
  procurementSummaryTimer = setTimeout(async () => {
    try {
      const rows = await fetchReportData('procurement-summary', {date_debut:from, date_fin:to, recherche:search});
      if (requestId !== procurementSummaryRequest) return;
      const quantityIn = new Map();
      const quantityOut = new Map();
      rows.forEach(row => addUnitQuantity(row.movement_type === 'IN' ? quantityIn : quantityOut, row.unit_abbreviation || row.unit_name, row.total_quantity));
      const balance = new Map(quantityIn);
      for (const [unit, quantity] of quantityOut) balance.set(unit, (balance.get(unit) || 0) - quantity);
      const inField = container.querySelector('#purchase-total-in');
      const outField = container.querySelector('#purchase-total-out');
      const balanceField = container.querySelector('#purchase-balance');
      if (inField) inField.textContent = unitTotalsLabel(quantityIn);
      if (outField) outField.textContent = unitTotalsLabel(quantityOut);
      if (balanceField) balanceField.textContent = unitTotalsLabel(balance);
      [inField, outField, balanceField].forEach(field => field?.classList.add('quantity-by-unit'));
    } catch (error) {
      if (requestId === procurementSummaryRequest) showToast(error.message);
    }
  }, 250);
}
function currentReportSource() {
  if (currentViewName === 'stock') return container.querySelector('[data-stock-section-panel]:not([hidden])') || container;
  return container;
}
function selectedReportKind(){return container.querySelector('[data-report-kind]')?.value||(currentViewName==='cash'?'cash':'sales');}
function currentReportTitle() {
  if (currentViewName === 'sales' || currentViewName === 'cash') return selectedReportKind()==='cash'?'Journal de caisse':'Rapport des ventes';
  if (currentViewName === 'stock') {
    const activeSection = container.querySelector('[data-stock-section].active');
    if (activeSection) return `Stock · ${activeSection.textContent.trim()}`;
  }
  return views[currentViewName]?.label || 'Rapport';
}
function currentReportBranch() {
    if (activeBranchId) return branchOptions.find(branch => Number(branch.succursale_id) === Number(activeBranchId))?.name || 'Succursale sélectionnée';
  if (currentViewName === 'stock') {
    const branchSelect = document.getElementById('stock-branch');
    if (branchSelect?.value) return branchSelect.selectedOptions[0]?.textContent || 'Succursale sélectionnée';
    if (canSelectCompanyBranches()) return 'Toute l’entreprise';
  }
  return sessionUser?.branch_name || 'Toute l’entreprise';
}
function isCompanyWideReport() {
  const stockBranch = currentViewName === 'stock' ? document.getElementById('stock-branch')?.value : '';
  return !activeBranchId && !stockBranch && !(sessionUser?.succursale_id && !sessionUser?.is_company_admin);
}
function removeBranchColumns(root) {
  if (isCompanyWideReport()) return;
  root.querySelectorAll('[data-report-total]').forEach(row => row.remove());
  root.querySelectorAll('table').forEach(table => {
    const headers = [...table.querySelectorAll('thead th')];
    const indices = headers.map((cell, index) => /succursale|branche/i.test(cell.textContent.trim()) ? index : -1).filter(index => index >= 0).reverse();
    indices.forEach(index => table.querySelectorAll('tr').forEach(row => row.children[index]?.remove()));
  });
  addReportTableTotals(currentReportSource());
}
function addReportTableTotals(root) {
  root.querySelectorAll('table').forEach(table => {
    if (table.dataset.skipReportTotals === 'true') return;
    const headers = [...table.querySelectorAll('thead th')];
    const body = table.tBodies[0];
    if (!headers.length || !body || !body.rows.length || body.querySelector('[data-report-total]')) return;
    const totalColumns = headers.map((header, index) => /quantit|entr[eé]e|sortie|ajustement|solde|total|montant|articles?|avant|apr[eè]s|op[eé]rations/i.test(header.textContent) ? index : -1).filter(index => index >= 0);
    if (!totalColumns.length) return;
    const totals = new Map();
    totalColumns.forEach(index => {
      const sums = new Map();
      [...body.rows].forEach(row => {
        if (row.hidden || row.dataset.reportTotal === 'true') return;
        const cell = row.cells[index];
        if (!cell || row.cells.length !== headers.length) return;
        const raw = cell.textContent.trim();
        const match = raw.match(/-?\d[\d\s\u00a0.,]*/);
        if (!match) return;
        let numeric = match[0].replace(/[\s\u00a0]/g, '');
        if (numeric.includes(',') && numeric.includes('.')) numeric = numeric.lastIndexOf(',') > numeric.lastIndexOf('.') ? numeric.replace(/\./g, '').replace(',', '.') : numeric.replace(/,/g, '');
        else if (numeric.includes(',')) numeric = numeric.replace(',', '.');
        const value = Number(numeric);
        if (!Number.isFinite(value)) return;
        const currency = row.dataset.reportCurrency || raw.slice(match.index + match[0].length).trim();
        sums.set(currency, (sums.get(currency) || 0) + value);
      });
      if (sums.size) totals.set(index, [...sums].map(([currency, sum]) => `${sum.toLocaleString('fr-FR', {maximumFractionDigits:2})}${currency ? ` ${currency}` : ''}`).join(' / '));
    });
    if (!totals.size) return;
    const row = body.insertRow(); row.dataset.reportTotal = 'true'; row.className = 'report-total-row';
    const firstTotal = Math.min(...totals.keys());
    if (firstTotal > 0) { const label = row.insertCell(); label.colSpan = firstTotal; label.textContent = 'TOTAL'; }
    headers.forEach((_, index) => {
      if (index < firstTotal) return;
      const cell = row.insertCell(); cell.textContent = totals.get(index) || '';
    });
  });
}
async function selectedReportNode(){
  const kind=selectedReportKind();
  if((kind==='sales'&&currentViewName==='sales')||(kind==='cash'&&currentViewName==='cash'))return (kind==='sales'?container.querySelector('#sales-rows')?.closest('.panel'):container.querySelector('#cash-movement-rows')?.closest('.panel'))?.cloneNode(true)||document.createElement('div');
  const action=kind==='sales'?'sales-list':'cash-movements';let result=await fetchReportPage(action,1);const rows=[...result.rows];for(let page=2;page<=result.pagination.pages;page++){result=await fetchReportPage(action,page);rows.push(...result.rows);}
  const headers=kind==='sales'?['Facture','Client','Succursale','Caissier','Date','Articles','Total','Payé','Statut']:['Date','Caisse','Type','Motif','Référence','Montant'];
  const node=document.createElement('section');node.className='panel';node.innerHTML=`<div class="panel-header"><h2>${currentReportTitle()}</h2></div><table class="data-table"><thead><tr>${headers.map(h=>`<th>${escapeHtml(h)}</th>`).join('')}</tr></thead><tbody></tbody></table>`;
  const body=node.querySelector('tbody');rows.forEach(item=>{const isSales=kind==='sales';const day=String(isSales?item.sale_date:item.movement_date).slice(0,10);const values=isSales?[item.invoice_no,item.client_name||'Client comptoir',item.branch_name||'—',item.cashier||'—',dateLabel(item.sale_date),Number(item.item_count||0),moneyCurrencyLabel(item.total_amount,item.monais),moneyCurrencyLabel(item.amount_paid,item.monais),item.status]:[dateLabel(item.movement_date),item.cash_name,item.type==='ENTREE'?'Entrée':'Sortie',item.reason||'—',item.reference_id?`#${item.reference_id}`:'—',moneyCurrencyLabel(item.amount,item.monais)];const row=body.insertRow();row.dataset.reportDate=day;row.innerHTML=values.map(value=>`<td>${escapeHtml(value)}</td>`).join('');});
  const {from,to,search}=reportFilterValues();[...body.rows].forEach(row=>{const day=row.dataset.reportDate;row.hidden=Boolean((from&&day<from)||(to&&day>to)||(search&&!row.textContent.toLocaleLowerCase('fr').includes(search)));});return node;
}
async function cloneReportContent() {
  const clone = (currentViewName==='cash'||currentViewName==='sales'?await selectedReportNode():currentReportSource().cloneNode(true));
  clone.querySelectorAll('[hidden], .report-toolbar, .filter-bar, button, input, select, textarea').forEach(node => node.remove());
  clone.querySelectorAll('table').forEach(table => {
    const headers = [...table.querySelectorAll('thead th')];
    const removeColumns = headers.map((cell, index) => /^(actions?|bon|utilisateur|caissier|préparé par|créé par|nom de l’utilisateur)$/i.test(cell.textContent.trim()) ? index : -1).filter(index => index >= 0).reverse();
    removeColumns.forEach(index => table.querySelectorAll('tr').forEach(row => row.children[index]?.remove()));
  });
  removeBranchColumns(clone);
  addReportTableTotals(clone);
  return clone.innerHTML;
}
function reportDocument(title, content, note = '', orientation = 'portrait') {
  const enterprise = escapeHtml(sessionUser?.enterprise_name || 'ALBA-STOCK');
  const companyDetails = [sessionUser?.enterprise_address, sessionUser?.enterprise_phone && `Tél. : ${sessionUser.enterprise_phone}`, sessionUser?.enterprise_email, sessionUser?.enterprise_rccm && `RCCM : ${sessionUser.enterprise_rccm}`, sessionUser?.enterprise_boite_postale && `BP : ${sessionUser.enterprise_boite_postale}`].filter(Boolean).map(value => `<p>${escapeHtml(value)}</p>`).join('');
  const branch = escapeHtml(currentReportBranch());
  const filters = reportFilterValues();
  const filterSummary = [filters.from && `Du ${formatReportDate(filters.from)}`, filters.to && `au ${formatReportDate(filters.to)}`, filters.search && `Recherche : ${filters.search}`].filter(Boolean).join(' · ');
  return `<!doctype html><html lang="fr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>${escapeHtml(title)} · ${enterprise}</title><style>
    @page{size:${orientation === 'landscape' ? 'A4 landscape' : 'A4'};margin:${orientation === 'landscape' ? '8mm' : '12mm'}}*{box-sizing:border-box}body{font:12px Arial,sans-serif;color:#1d2926;margin:0}header{display:flex;justify-content:space-between;align-items:flex-start;border-bottom:2px solid #147c70;padding-bottom:12px;margin-bottom:18px}h1{font-size:21px;color:#126b5e;margin:0 0 6px}h2{font-size:15px;margin:15px 0 8px}p{margin:4px 0;color:#53635d}.report-meta{text-align:right;font-size:10px}.report-table,.data-table{width:100%;border-collapse:collapse;margin:12px 0 18px}.report-table th,.report-table td,.data-table th,.data-table td{border:1px solid #cfd9d3;padding:7px;text-align:left;font-size:10px}.report-table th,.data-table th{background:#eaf3ee;color:#254b42}.report-total-row td{font-weight:800;background:#eaf3ee;border-top:2px solid #147c70}.panel,.stat-card{border:0;box-shadow:none;padding:0;margin:10px 0}.dashboard-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:10px}.stat-card{border:1px solid #d9e3dd;padding:10px}.stat-label{display:block;font-size:10px;color:#53635d}.stat-value{font-size:17px;font-weight:bold;margin-top:5px}.status{border:1px solid #ccd8d1;padding:2px 5px}.empty-note{padding:10px;color:#53635d}.report-note{font-size:10px;color:#73807b;margin-top:12px}.report-company-footer{text-align:center;font-size:8px;color:#73807b;margin-top:20px}.signature-row{display:flex;justify-content:space-between;gap:30px;margin-top:38px}.signature-row div{width:42%;border-top:1px solid #697972;padding-top:6px;font-size:10px}.print-controls{position:sticky;top:0;background:#fff;padding:10px;text-align:right;border-bottom:1px solid #ddd}.print-controls button{border:0;border-radius:5px;padding:9px 14px;margin-left:6px;background:#147c70;color:#fff;font-weight:bold;cursor:pointer}@media print{.print-controls{display:none}}
  </style></head><body><div class="print-controls"><button onclick="window.print()">Imprimer / Enregistrer en PDF</button><button onclick="window.close()">Fermer</button></div><header><div><h1>${escapeHtml(title)}</h1>${companyDetails}<p>${branch}</p>${filterSummary ? `<p>Période et filtres : ${escapeHtml(filterSummary)}</p>` : ''}</div><div class="report-meta"><p>Date d’édition : ${new Date().toLocaleString('fr-FR')}</p><p>Format conseillé : A4 ${orientation === 'landscape' ? 'paysage' : 'portrait'} · modifiable dans les options de l’imprimante</p></div></header><main>${content}${note ? `<p class="report-note">${escapeHtml(note)}</p>` : ''}</main><footer class="report-company-footer">${enterprise}</footer></body></html>`;
}
async function openReportPreview() {
  const title = currentReportTitle();
  const modal = document.createElement('div');
  modal.className = 'report-modal';
  modal.innerHTML = `<section class="report-dialog"><div class="report-dialog-heading"><div><h2>Aperçu du rapport</h2><p>${escapeHtml(title)}</p></div><button type="button" data-report-close aria-label="Fermer">×</button></div><div class="report-preview"><header><h1>${escapeHtml(title)}</h1><p><strong>${escapeHtml(sessionUser?.enterprise_name || 'ALBA-STOCK')}</strong> · ${escapeHtml(currentReportBranch())}</p><p>Édité le ${new Date().toLocaleString('fr-FR')}</p></header>${cloneReportContent()}</div><div class="report-dialog-actions"><button type="button" data-report-close>Fermer</button><button type="button" data-report-action="print">Imprimer</button><button type="button" data-report-action="pdf">Exporter en PDF</button><button type="button" data-report-action="excel">Exporter vers Excel</button></div></section>`;
  const preview=modal.querySelector('.report-preview');preview.querySelector('header')?.insertAdjacentHTML('afterend',await cloneReportContent());[...preview.childNodes].filter(node=>node.nodeType===3).forEach(node=>node.remove());
  const previewLogoPath = sessionUser?.enterprise_logo;
  if (previewLogoPath) {
    const logo = document.createElement('img');
    logo.className = 'report-company-logo';
    logo.src = companyImageUrl(previewLogoPath);
    logo.alt = `Logo ${sessionUser.enterprise_name || 'entreprise'}`;
    modal.querySelector('.report-preview header')?.prepend(logo);
  }
  document.body.appendChild(modal);
}
async function reportRowsForExcel() {
  const clone = (currentViewName==='sales'||currentViewName==='cash'?await selectedReportNode():currentReportSource().cloneNode(true));
  clone.querySelectorAll('[hidden], .report-toolbar, .filter-bar, button, input, select, textarea').forEach(node => node.remove());
  addReportTableTotals(clone);
  const rows = [[currentReportTitle()], [`${sessionUser?.enterprise_name || 'ALBA-STOCK'} · ${currentReportBranch()}`], [`Édité le ${new Date().toLocaleString('fr-FR')}`], []];
  clone.querySelectorAll('.stat-card').forEach(card => rows.push([card.querySelector('.stat-label')?.textContent.trim() || '', card.querySelector('.stat-value')?.textContent.trim() || '']));
  clone.querySelectorAll('table').forEach((table, tableIndex) => {
    if (tableIndex) rows.push([]);
    const headers = [...table.querySelectorAll('thead th')];
    const hiddenIndices = headers.map((cell, index) => /^(actions?|bon|utilisateur|caissier|préparé par|créé par|nom de l’utilisateur)$/i.test(cell.textContent.trim()) ? index : -1).filter(index => index >= 0);
    rows.push(headers.filter((_, index) => !hiddenIndices.includes(index)).map(cell => cell.textContent.trim()));
    table.querySelectorAll('tbody tr').forEach(row => rows.push([...row.cells].filter((_, index) => !hiddenIndices.includes(index)).map(cell => cell.textContent.trim().replace(/\s+/g, ' '))));
  });
  return rows.length > 4 ? rows : [...rows, ...clone.innerText.split('\n').map(line => [line.trim()]).filter(row => row[0])];
}
async function exportReportExcel() {
  const rows=await reportRowsForExcel();
  const csv = rows.map(row => row.map(value => `"${String(value ?? '').replace(/"/g, '""')}"`).join(';')).join('\r\n');
  const blob = new Blob(['\ufeff', csv], {type:'text/csv;charset=utf-8'});
  const link = document.createElement('a');
  link.href = URL.createObjectURL(blob);
  link.download = `${currentReportTitle().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/[^a-z0-9]+/gi, '-').replace(/^-|-$/g, '').toLowerCase() || 'rapport'}.csv`;
  link.click();
  setTimeout(() => URL.revokeObjectURL(link.href), 1000);
}
async function printCurrentReport(title = currentReportTitle(), sourceHtml = null) {
  try {
    const clone = new DOMParser().parseFromString(sourceHtml ?? await cloneReportContent(), 'text/html');
    const tables = [...clone.querySelectorAll('table')].map(table => ({
      headers: [...table.querySelectorAll('thead th')].map(cell => cell.textContent.trim()),
      rows: [...table.querySelectorAll('tbody tr')].filter(row => !row.hidden).map(row => [...row.cells].flatMap(cell => [cell.textContent.trim().replace(/\s+/g, ' '), ...Array(Math.max(0, cell.colSpan - 1)).fill('')]))
    })).filter(table => table.headers.length > 0);
    if (!tables.length) throw new Error('Aucun tableau de données à exporter en PDF.');
    const branchId = activeBranchId || (currentViewName === 'stock' ? document.getElementById('stock-branch')?.value : '');
    const response = await fetch('../backend/public/pdf-report.php', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      credentials: 'include',
      body: JSON.stringify({title, succursale_id: branchId || null, tables})
    });
    if (!response.ok) {
      const result = await readJson(response);
      throw new Error(result.message || 'Génération du PDF impossible.');
    }
    const blob = await response.blob();
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = `${title.normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/[^a-z0-9]+/gi, '-').replace(/^-|-$/g, '').toLowerCase() || 'rapport'}.pdf`;
    link.click();
    setTimeout(() => URL.revokeObjectURL(link.href), 1000);
  } catch (error) {
    showToast(error.message);
  }
}
function configureStockWorkspace() {
  const productPanel = document.getElementById('stock-rows')?.closest('section');
  const categoryPanel = document.getElementById('category-admin-panel');
  if (!productPanel || !categoryPanel) return;
  productPanel.dataset.stockSectionPanel = 'products';
  categoryPanel.dataset.stockSectionPanel = 'categories';
  categoryPanel.hidden = true;
  const supplierPanel = document.createElement('section');
  supplierPanel.className = 'panel';
  supplierPanel.dataset.stockSectionPanel = 'suppliers';
  supplierPanel.hidden = true;
  supplierPanel.innerHTML = `<div class="panel-header"><div><h2>Gestion des fournisseurs</h2><p class="panel-subtitle">Fournisseurs enregistrés pour votre entreprise</p></div><button class="primary-button" type="button" data-create-supplier>+ Créer un fournisseur</button></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Nom</th><th>Contact</th><th>Adresse électronique</th><th>Téléphone</th><th>Actions</th></tr></thead><tbody id="supplier-rows"><tr><td colspan="5">Chargement…</td></tr></tbody></table></div>`;
  const purchasePanel = document.createElement('section');
  purchasePanel.className = 'panel';
  purchasePanel.dataset.stockSectionPanel = 'procurement';
  purchasePanel.hidden = true;
  purchasePanel.innerHTML = `<div class="panel-header"><div><h2>Approvisionnements</h2><p class="panel-subtitle">Entrées et sorties appliquées au stock</p></div><button type="button" class="movement-report-button" data-stock-movement-report>Fiche de stock</button><button class="primary-button" type="button" data-create-purchase>+ Nouvel approvisionnement</button></div><div class="dashboard-grid procurement-summary"><article class="stat-card"><span class="stat-label">Quantités entrées (validées)</span><div class="stat-value" id="purchase-total-in">0</div></article><article class="stat-card"><span class="stat-label">Quantités sorties (validées)</span><div class="stat-value" id="purchase-total-out">0</div></article><article class="stat-card"><span class="stat-label">Solde net</span><div class="stat-value" id="purchase-balance">0</div></article></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Référence</th><th>Motif</th><th>Date</th><th>Quantité</th><th>Quantité sortie</th><th>Quantité entrée</th><th>Solde du lot</th><th>Total</th><th>Statut</th><th>Bon</th></tr></thead><tbody id="purchase-rows"><tr><td colspan="10">Chargement…</td></tr></tbody></table></div>`;
  supplierPanel.querySelector('[data-create-supplier]').hidden = !hasAccess('creer_fournisseurs');
  purchasePanel.querySelector('[data-create-purchase]').hidden = !hasAccess('creer_approvisionnements');
  purchasePanel.querySelector('[data-stock-movement-report]').hidden = !hasAnyAccess('voir_stock', 'voir_approvisionnements');
  purchasePanel.querySelector('[data-stock-movement-report]').textContent = 'Afficher fiche de stock';
  const tabs = document.createElement('div');
  tabs.className = 'filter-bar stock-section-tabs';
  const sections = [
    ['products', 'Produits', true],
    ['categories', 'Catégories', hasAccess('voir_stock')],
    ['suppliers', 'Fournisseurs', hasAccess('voir_fournisseurs')],
    ['procurement', 'Approvisionnements', hasAccess('voir_approvisionnements')]
  ].filter(([, , visible]) => visible);
  tabs.innerHTML = sections.map(([key, label], index) => `<button type="button" class="text-button${index === 0 ? ' active' : ''}" data-stock-section="${key}">${label}</button>`).join('');
  productPanel.before(tabs);
  categoryPanel.after(supplierPanel, purchasePanel);
}
function selectStockSection(sectionName) {
  document.querySelectorAll('[data-stock-section-panel]').forEach(panel => { panel.hidden = panel.dataset.stockSectionPanel !== sectionName; });
  document.querySelectorAll('[data-stock-section]').forEach(button => button.classList.toggle('active', button.dataset.stockSection === sectionName));
  renderModuleNavigation();
  filterCurrentReport();
}
// Les droits reçus dans la session sont utilisés pour afficher seulement les écrans autorisés.
function permissionList(user = sessionUser) {
  let permissions = user?.permissions ?? [];
  if (typeof permissions === 'string') { try { permissions = JSON.parse(permissions); } catch { permissions = []; } }
  if (!Array.isArray(permissions)) return [];
  // Compatibilité avec les anciens rôles qui stockaient le groupe "stock" tel quel.
  if (permissions.includes('stock') || (permissions.includes('voir_stock') && !permissions.includes('approvisionnement'))) permissions.push('voir_stock', 'modifier_stock', 'creer_produit', 'modifier_produit', 'supprimer_produit', 'voir_succursales', 'voir_fournisseurs', 'creer_fournisseurs', 'modifier_fournisseurs', 'supprimer_fournisseurs', 'voir_approvisionnements', 'creer_approvisionnements');
  if (permissions.includes('vente')) permissions.push('voir_ventes', 'creer_ventes', 'modifier_ventes');
  if (permissions.includes('caisse')) permissions.push('voir_caisse', 'creer_caisse', 'modifier_caisse', 'supprimer_caisse');
  if (permissions.includes('comptabilite')) permissions.push('voir_comptabilite', 'creer_comptabilite', 'modifier_comptabilite');
  if (permissions.includes('clients')) permissions.push('voir_clients', 'gerer_clients');
  if (permissions.includes('creer_approvisionnements')) permissions.push('creer_fournisseurs');
  return [...new Set(permissions)];
}
function moduleForPermission(permission) {
  if (['voir_stock', 'modifier_stock', 'stock', 'creer_produit', 'modifier_produit', 'supprimer_produit', 'voir_fournisseurs', 'creer_fournisseurs', 'modifier_fournisseurs', 'supprimer_fournisseurs', 'gerer_unites_mesure', 'voir_transferts', 'creer_transferts'].includes(permission)) return 'stock';
  if (permission === 'approvisionnement' || permission.endsWith('_approvisionnements')) return 'approvisionnements';
  if (permission.endsWith('_transferts')) return 'stock';
  if (permission.endsWith('_ventes')) return 'ventes';
  if (permission.endsWith('_caisse')) return 'caisse';
  if (permission.endsWith('_comptabilite')) return 'comptabilite';
  if (['gerer_utilisateurs', 'gerer_roles', 'voir_roles'].includes(permission)) return 'utilisateurs';
  if (permission === 'voir_rapports') return 'rapports';
  if (['voir_succursales', 'gerer_succursales', 'voir_clients', 'gerer_clients'].includes(permission) || permission.endsWith('_clients')) return 'administration';
  return null;
}
function hasAccess(permission, user = sessionUser) {
  const permissions = permissionList(user);
  if (!permissions.includes('*') && !permissions.includes(permission)) return false;
  const module = moduleForPermission(permission);
  const enabledModules = user?.modules_autorises;
  return module === null || (Array.isArray(enabledModules) && enabledModules.includes(module));
}
function hasAnyAccess(...permissions) { return permissions.some(permission => hasAccess(permission)); }
function applyMenuAccess(user) {
  const permissions = permissionList(user);
  document.querySelectorAll('.nav-item[data-access]').forEach(item => {
    const required = item.dataset.access.split('|');
    item.hidden = !required.includes('session') && !required.some(permission => permission === '*' ? permissions.includes('*') : hasAccess(permission, user));
  });
  // Masque aussi les titres de groupe quand aucun des liens suivants n'est autorisé.
  document.querySelectorAll('[data-nav-section]').forEach(heading => {
    let sibling = heading.nextElementSibling;
    let hasVisibleItem = false;
    while (sibling && !sibling.matches('[data-nav-section]')) {
      if (sibling.matches('.nav-item') && !sibling.hidden) hasVisibleItem = true;
      sibling = sibling.nextElementSibling;
    }
    heading.hidden = !hasVisibleItem;
  });
}
const apiUrl = resource => `../backend/public/api.php?resource=${encodeURIComponent(resource)}`;
async function fetchStockSummary(branchId) {
  const selectedBranchId = arguments.length ? branchId : activeBranchId;
  const query = new URLSearchParams({action:'summary'});
  if (selectedBranchId) query.set('succursale_id', selectedBranchId);
  const response = await fetch(`../backend/public/stock.php?${query}`, {credentials:'include'});
  const result = await readJson(response);
  if (!response.ok || !result.success) throw new Error(result.message || 'Chargement du résumé de stock impossible.');
  return result.data;
}
const escapeHtml = value => String(value ?? '').replace(/[&<>"']/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));
function companyImageUrl(path) {
  return path ? new URL(`../${String(path).replace(/^\/+/, '')}`, window.location.href).href : '';
}
function setCompanyImagePreview(image, path) {
  if (!image) return;
  image.src = companyImageUrl(path);
  image.hidden = !path;
}
function previewSelectedImage(input, image) {
  if (!input?.files?.[0] || !image) return;
  image.src = URL.createObjectURL(input.files[0]);
  image.hidden = false;
}
function companyLogoMarkup() {
  const path = sessionUser?.enterprise_logo;
  return path ? `<img class="report-company-logo" src="${escapeHtml(companyImageUrl(path))}" alt="Logo ${escapeHtml(sessionUser.enterprise_name || 'entreprise')}">` : '';
}
async function readJson(response) {
  const raw = await response.text();
  try { return JSON.parse(raw); }
  catch {
    const detail = raw.replace(/<[^>]*>/g, ' ').replace(/&(?:nbsp|lt|gt|amp|quot);/g, ' ').replace(/\s+/g, ' ').trim().slice(0, 220);
    throw new Error(`Le serveur a renvoyé une erreur au lieu du JSON (HTTP ${response.status}). ${detail || 'Vérifiez les journaux PHP.'}`);
  }
}
async function apiGet(resource, branchId) {
  const selectedBranchId = arguments.length > 1 ? branchId : activeBranchId;
  const scopedBranchId = branchScopedResources.has(resource) ? selectedBranchId : '';
  const endpoint = resource === 'stocks' ? `../backend/public/stock.php${scopedBranchId ? `?succursale_id=${encodeURIComponent(scopedBranchId)}` : ''}` : `${apiUrl(resource)}${scopedBranchId ? `&succursale_id=${encodeURIComponent(scopedBranchId)}` : ''}`;
  const response = await fetch(endpoint, {credentials:'include'});
  const result = await readJson(response);
  if (!response.ok || !result.success) throw new Error(result.message || 'Chargement impossible.');
  return result.data;
}
const PAGE_SIZE_OPTIONS = [5, 10, 20, 25, 100];
let PAGE_SIZE = PAGE_SIZE_OPTIONS.includes(Number(localStorage.getItem('alba-stock-page-size')))
  ? Number(localStorage.getItem('alba-stock-page-size'))
  : 10;
const paginationLoaders = new Map();
async function apiGetPage(resource, page, branchId) {
  const endpoint = new URL(resource === 'stocks' ? '../backend/public/stock.php' : apiUrl(resource), window.location.href);
  const selectedBranchId = arguments.length > 2 ? branchId : activeBranchId;
  if (branchScopedResources.has(resource) && selectedBranchId) endpoint.searchParams.set('succursale_id', selectedBranchId);
  else if (resource !== 'stocks') endpoint.searchParams.set('resource', resource);
  endpoint.searchParams.set('page', String(page));
  endpoint.searchParams.set('per_page', String(PAGE_SIZE));
  const response = await fetch(endpoint, {credentials:'include'});
  const result = await readJson(response);
  if (!response.ok || !result.success) throw new Error(result.message || 'Chargement impossible.');
  return {rows:result.data || [], summary:result.summary || [], pagination:result.pagination || {page, per_page:PAGE_SIZE, total:(result.data || []).length, pages:1}};
}
function showPagination(body, key, info, onPage) {
  if (!body) return;
  if (body.id === 'pending-sale-rows') labelSaleInvoiceButtons(body);
  const resultTable = body.closest('table');
  if (resultTable && resultTable.classList.contains('data-table')) addReportTableTotals(resultTable.parentElement);
  let controls = document.querySelector(`[data-list-pagination="${key}"]`);
  if (!controls) {
    controls = document.createElement('nav');
    controls.className = 'list-pagination';
    controls.dataset.listPagination = key;
    (body.closest('table')?.parentElement || body)?.insertAdjacentElement('afterend', controls);
  }
  if (!controls) return;
  const page = Number(info?.page || 1), pages = Number(info?.pages || 1), total = Number(info?.total || 0);
  paginationLoaders.set(key, onPage);
  controls.innerHTML = `<span>Page ${page} sur ${pages} · ${total.toLocaleString('fr-FR')} résultat${total === 1 ? '' : 's'}</span><div><label class="pagination-size">Lignes par page<select data-page-size-key="${key}">${PAGE_SIZE_OPTIONS.map(size => `<option value="${size}"${PAGE_SIZE === size ? ' selected' : ''}>${size}</option>`).join('')}</select></label><button type="button" data-page-key="${key}" data-page="${page - 1}" ${page <= 1 ? 'disabled' : ''}>&#8249; Précédent</button><button type="button" data-page-key="${key}" data-page="${page + 1}" ${page >= pages ? 'disabled' : ''}>Suivant &#8250;</button></div>`;
}
let stockData = {products:[], stocks:[], categories:[], branches:[], units:[], summary:[]};
let unitManagerModal = null;
let refreshUnitManager = null;
let roleData = [];
let userData = [];
const permissionLabels = {
  voir_ventes:'Consulter les ventes', creer_ventes:'Créer des ventes', modifier_ventes:'Modifier les ventes', supprimer_ventes:'Supprimer les ventes',
  voir_caisse:'Consulter la caisse', creer_caisse:'Créer une caisse', modifier_caisse:'Gérer la caisse', supprimer_caisse:'Supprimer une caisse',
  voir_stock:'Consulter le stock', modifier_stock:'Ajuster les quantités', creer_produit:'Créer des produits', modifier_produit:'Modifier les produits', supprimer_produit:'Supprimer des produits', voir_fournisseurs:'Consulter les fournisseurs', creer_fournisseurs:'Créer des fournisseurs', modifier_fournisseurs:'Modifier les fournisseurs', supprimer_fournisseurs:'Supprimer des fournisseurs', voir_approvisionnements:'Consulter les approvisionnements', creer_approvisionnements:'Créer des approvisionnements', voir_comptabilite:'Consulter la comptabilité', supprimer_caisse:'Supprimer une caisse'
};
async function loadRoleList(page = 1) {
  const list = document.getElementById('role-list'); if (!list) return;
  try {
    const pageResult = await apiGetPage('roles', page);
    const roles = pageResult.rows;
    roleData = roles;
    list.innerHTML = roles.length ? roles.map(role => {
      let permissions = role.permissions;
      if (typeof permissions === 'string') { try { permissions = JSON.parse(permissions); } catch { permissions = []; } }
      const labels = Array.isArray(permissions) && permissions.includes('*') ? ['Accès complet'] : (Array.isArray(permissions) ? permissions.map(permission => permissionLabels[permission]).filter(Boolean) : []);
      const actions = hasAccess('gerer_roles') ? `<div class="user-action-group"><button class="user-action-button user-action-edit" title="Modifier le rôle" aria-label="Modifier le rôle ${escapeHtml(role.role_name)}" data-role-edit="${Number(role.role_id)}"><span aria-hidden="true">✎</span> Modifier</button><button class="user-action-button user-action-delete" title="Supprimer le rôle" aria-label="Supprimer le rôle ${escapeHtml(role.role_name)}" data-role-delete="${Number(role.role_id)}"><span aria-hidden="true">×</span> Supprimer</button></div>` : '';
      return `<div class="permission"><strong>${escapeHtml(role.role_name)}</strong><small>${escapeHtml(labels.join(' · ') || 'Aucun droit attribué')}</small>${actions}</div>`;
    }).join('') : '<p class="empty-note">Aucun rôle défini. Créez un rôle pour commencer.</p>';
    showPagination(list, 'roles', pageResult.pagination, loadRoleList);
  } catch (error) { list.innerHTML = `<p class="empty-note">${escapeHtml(error.message)}</p>`; }
}
function showLoadError(id, error, columns = 1) {
  const target = document.getElementById(id); if (target) target.innerHTML = `<tr><td colspan="${columns}">${escapeHtml(error.message)}</td></tr>`;
}
const dateLabel = value => value ? new Date(String(value).replace(' ', 'T')).toLocaleString('fr-FR') : '—';
const moneyLabel = value => Number(value || 0).toLocaleString('fr-FR', {minimumFractionDigits:2, maximumFractionDigits:2});
const moneyCurrencyLabel = (value, currency) => `${moneyLabel(value)} ${String(currency || '').trim()}`.trim();
const currencyTotalsLabel = rows => {
  const totals = new Map();
  rows.forEach(row => {
    const balances = Array.isArray(row.currency_totals) && row.currency_totals.length ? row.currency_totals : [row];
    balances.forEach(balance => {
      const currency = balance.monais || 'Monnaie inconnue';
      totals.set(currency, (totals.get(currency) || 0) + Number(balance.total_amount || 0));
    });
  });
  return [...totals].map(([currency, total]) => moneyCurrencyLabel(total, currency)).join(' · ') || moneyCurrencyLabel(0, '');
};
const saleCurrencyAmounts = (sale, field) => {
  const balances = Array.isArray(sale.currency_totals) && sale.currency_totals.length ? sale.currency_totals : [sale];
  return balances.map(balance => moneyCurrencyLabel(balance[field], balance.monais)).join(' · ');
};
const purchaseStatusLabel = value => ({RECEIVED:'Validé', PENDING:'En attente', CANCELLED:'Annulé'}[String(value || '').toUpperCase()] || value || '—');
function addUnitQuantity(totals, unit, quantity) {
  const amount = Number(quantity || 0);
  if (amount === 0) return;
  const unitLabel = unit || 'unité non précisée';
  totals.set(unitLabel, (totals.get(unitLabel) || 0) + amount);
}
function unitTotalsLabel(totals) {
  return [...totals].filter(([, quantity]) => quantity !== 0).map(([unit, quantity]) => `${quantity.toLocaleString('fr-FR')} ${unit}`).join(' · ') || 'Aucune quantité';
}
function quantityRowsLabel(rows) {
  const totals = new Map();
  rows.forEach(row => addUnitQuantity(totals, row.unit_abbreviation || row.unit_symbol || row.unit_name, row.quantity));
  return unitTotalsLabel(totals);
}
function setQuantitySummary(target, rows) {
  if (!target) return;
  target.textContent = quantityRowsLabel(rows);
  target.classList.add('quantity-by-unit');
}
async function loadUserRows(page = 1) {
  const body = document.getElementById('user-rows'); if (!body) return;
  try {
    const users = await readJson(await fetch(`../backend/public/auth.php?action=list-users&page=${page}&per_page=${PAGE_SIZE}`, {credentials:'include'}));
    if (!users.success) throw new Error(users.message || 'Chargement des utilisateurs impossible.');
    userData = users.data;
    body.innerHTML = users.data.length ? users.data.map(user => `<tr><td>${escapeHtml(user.full_name || user.username)}</td><td>${escapeHtml(user.username)}</td><td>${escapeHtml(user.email || '—')}</td><td>${escapeHtml(user.role_name)}</td><td>${escapeHtml(user.branch_name || 'Entreprise mère')}</td><td><span class="status ${Number(user.is_active) ? 'success' : 'danger'}">${Number(user.is_active) ? 'Actif' : 'Inactif'}</span></td><td>${hasAccess('gerer_utilisateurs') ? `<div class="user-action-group"><button class="user-action-button user-action-edit" title="Modifier l’utilisateur" aria-label="Modifier ${escapeHtml(user.full_name || user.username)}" data-user-edit="${Number(user.user_id)}"><span aria-hidden="true">✎</span> Modifier</button><button class="user-action-button user-action-delete" title="Supprimer l’utilisateur" aria-label="Supprimer ${escapeHtml(user.full_name || user.username)}" data-user-delete="${Number(user.user_id)}"><span aria-hidden="true">×</span> Supprimer</button></div>` : '—'}</td></tr>`).join('') : '<tr><td colspan="7">Aucun utilisateur enregistré.</td></tr>';
    showPagination(body, 'users', users.pagination, loadUserRows);
  } catch (error) { showLoadError('user-rows', error, 7); }
}
async function loadSimpleRows(resource, bodyId, columns, renderRow, emptyLabel, page = 1) {
  const body = document.getElementById(bodyId); if (!body) return;
  try {
    const result = await apiGetPage(resource, page);
    const rows = result.rows;
    body.innerHTML = rows.length ? rows.map(renderRow).join('') : `<tr><td colspan="${columns}">${emptyLabel}</td></tr>`;
    showPagination(body, bodyId, result.pagination, nextPage => loadSimpleRows(resource, bodyId, columns, renderRow, emptyLabel, nextPage));
  } catch (error) { showLoadError(bodyId, error, columns); }
}
async function openSaleClientForm(branchId,onSaved){
  const modal=document.createElement('div');modal.className='entity-modal';modal.innerHTML='<section class="entity-dialog sale-client-dialog"><h2>Ajouter un client</h2><form class="entity-form"><label class="full">Nom du client<input name="name" maxlength="100" required autofocus></label><label>Adresse électronique<input name="email" type="email" maxlength="100"></label><label>Téléphone<input name="phone" maxlength="20"></label><label class="full">Adresse<textarea name="address"></textarea></label><div class="entity-modal-actions full"><button type="button" class="modal-cancel">Annuler</button><button class="modal-submit">Enregistrer le client</button></div></form></section>';document.body.appendChild(modal);modal.querySelector('.modal-cancel').addEventListener('click',()=>modal.remove());modal.querySelector('form').addEventListener('submit',async event=>{event.preventDefault();const body=Object.fromEntries(new FormData(event.currentTarget));body.succursale_id=Number(branchId);try{const response=await fetch('../backend/public/auth.php?action=create-sale-client',{method:'POST',headers:{'Content-Type':'application/json'},credentials:'include',body:JSON.stringify(body)});const result=await readJson(response);if(!response.ok||!result.success)throw new Error(result.message||'Création du client impossible.');modal.remove();onSaved(result.data);showToast('Client ajouté à la vente.');}catch(error){showToast(error.message);}});
}
async function openSaleForm() {
  if (!hasAccess('creer_ventes')) return;
  const modal=document.createElement('div');modal.className='entity-modal';modal.innerHTML=`<section class="entity-dialog sale-dialog"><h2>Nouvelle vente</h2><p>Les lots ayant la date d’expiration la plus proche sont prélevés en premier.</p><form class="entity-form"><label>Référence de facture<input name="invoice_no" required></label><label>Succursale<select name="succursale_id" required></select></label><label>Client (facultatif)<select name="client_id"><option value="">Client comptoir</option></select></label><label class="full" data-counter-client-field>Nom du client comptoir<input name="client_comptoir_name" maxlength="100" autocomplete="off" required></label><div class="full sale-lines-wrap"><div class="sale-lines-heading"><strong>Produits vendus</strong><button type="button" data-sale-add-line>+ Ajouter un produit</button></div><div data-sale-lines></div></div><p class="full sale-total" data-sale-total>0</p><div class="entity-modal-actions full"><button type="button" class="modal-cancel">Annuler</button><button class="modal-submit">Enregistrer la vente</button></div></form></section>`;document.body.appendChild(modal);
  const form=modal.querySelector('form'),branchSelect=form.elements.namedItem('succursale_id'),clientSelect=form.elements.namedItem('client_id'),linesBox=modal.querySelector('[data-sale-lines]');modal.querySelector('.sale-total').insertAdjacentHTML('beforebegin','<p class="full">La vente est enregistrée en attente. Son règlement sera saisi depuis le module Caisse.</p>');
  const counterClientField=form.querySelector('[data-counter-client-field]'),counterClientInput=counterClientField.querySelector('input');const syncCounterClientField=()=>{const counterSale=!clientSelect.value;counterClientField.hidden=!counterSale;counterClientInput.required=counterSale;if(!counterSale)counterClientInput.value='';};syncCounterClientField();clientSelect.addEventListener('change',syncCounterClientField);
  if(hasAccess('creer_ventes')||hasAccess('gerer_clients')){const addClientButton=document.createElement('button');addClientButton.type='button';addClientButton.className='sale-add-client-button';addClientButton.textContent='+ Ajouter un client';clientSelect.closest('label').append(addClientButton);addClientButton.addEventListener('click',()=>openSaleClientForm(branchSelect.value,client=>{if(!catalog)catalog={clients:[]};catalog.clients.push(client);const option=document.createElement('option');option.value=String(client.client_id);option.textContent=client.name;clientSelect.append(option);clientSelect.value=option.value;}));}
  const branches=branchOptions.length?branchOptions:sessionUser?.succursale_id?[{succursale_id:sessionUser.succursale_id,name:sessionUser.branch_name||'Ma succursale'}]:[];
  branchSelect.innerHTML=branches.map(b=>`<option value="${Number(b.succursale_id)}">${escapeHtml(b.name)}</option>`).join('');branchSelect.value=String(activeBranchId||sessionUser?.succursale_id||branches[0]?.succursale_id||'');
  form.elements.namedItem('invoice_no').value=`FAC-${new Date().toISOString().slice(0,10).replaceAll('-','')}-${Math.random().toString(36).slice(2,6).toUpperCase()}`;
  let catalog=null;
  const loadCatalog=async()=>{linesBox.querySelectorAll('[data-sale-product]').forEach(select=>{select.disabled=true;select.innerHTML='<option value="">Chargement…</option>';});try{catalog=await fetchReportData('sale-catalog',{succursale_id:branchSelect.value});clientSelect.innerHTML='<option value="">Client comptoir</option>'+catalog.clients.map(c=>`<option value="${Number(c.client_id)}">${escapeHtml(c.name)}</option>`).join('');syncCounterClientField();linesBox.querySelectorAll('[data-sale-line]').forEach(fillSaleProducts);linesBox.querySelectorAll('[data-sale-product]').forEach(select=>{select.disabled=false;if(select.options.length===1)select.options[0].textContent='Aucun produit disponible';});refreshSaleTotal();}catch(error){linesBox.querySelectorAll('[data-sale-product]').forEach(select=>{select.disabled=true;select.innerHTML=`<option value="">${escapeHtml(error.message||'Chargement impossible')}</option>`;});showToast(error.message);}};
  const refreshSaleAvailability=row=>{const select=row.querySelector('[data-sale-product]'),hint=row.querySelector('[data-sale-available-stock]'),option=select.selectedOptions[0];if(!option?.value){hint.textContent='Stock disponible : —';return;}const available=Number(option.dataset.quantity||0),requested=Number(row.querySelector('[data-sale-quantity]').value||0),unit=option.dataset.unit||'';hint.textContent=`Stock disponible dans cette succursale : ${available} ${unit}${requested>available?' · Quantité demandée supérieure au stock':''}`;};
  const fillSaleProducts=row=>{const select=row.querySelector('[data-sale-product]');if(!catalog)return;const previous=select.value,currency='';select.innerHTML='<option value="">Choisir un produit</option>'+catalog.products.filter(p=>!currency||p.monais===currency).map(p=>`<option value="${Number(p.produit_id)}" data-price="${Number(p.unit_price)}" data-currency="${escapeHtml(p.monais)}" data-quantity="${Number(p.quantity)}" data-unit="${escapeHtml(p.unit_symbol||p.unit_name||'')}" data-perishable="${Number(p.est_perisable)}">${escapeHtml(p.name)} · ${escapeHtml(p.sku)} · ${Number(p.quantity)} ${escapeHtml(p.unit_symbol||p.unit_name||'')} · ${escapeHtml(p.monais)}</option>`).join('');select.value=previous;refreshSaleAvailability(row);};
  const refreshSaleLinePrice=row=>{const option=row.querySelector('[data-sale-product]').selectedOptions[0],field=row.querySelector('[data-sale-price-field]'),input=row.querySelector('[data-sale-price]'),manual=Boolean(option?.value)&&Number(option.dataset.price||0)<=0;field.hidden=!manual;field.style.display=manual?'':'none';input.disabled=!manual;input.required=manual;if(!manual)input.value='';};
  const addLine=()=>{const row=document.createElement('div');row.dataset.saleLine='';row.className='sale-line';row.innerHTML='<label>Produit<select data-sale-product required><option value="">Chargement…</option></select><small data-sale-available-stock role="status">Stock disponible : —</small></label><label>Quantité<input type="number" min="1" step="1" value="1" data-sale-quantity required></label><label data-sale-price-field hidden>Prix de vente<input type="number" min="0.01" step="0.01" data-sale-price disabled></label><label class="sale-discount-toggle"><input type="checkbox" data-sale-discount> Réduction</label><label data-sale-discount-field hidden>Réduction (montant)<input type="number" min="0" step="0.01" value="0" data-sale-discount-amount disabled></label><strong data-sale-line-total>—</strong><button type="button" data-sale-remove aria-label="Retirer le produit">×</button>';linesBox.appendChild(row);fillSaleProducts(row);refreshSaleLinePrice(row);refreshSaleTotal();};
  function refreshSaleTotal(){const totals=new Map();linesBox.querySelectorAll('[data-sale-line]').forEach(row=>{const option=row.querySelector('[data-sale-product]').selectedOptions[0],savedPrice=Number(option?.dataset.price||0),price=savedPrice>0?savedPrice:Number(row.querySelector('[data-sale-price]').value||0),qty=Number(row.querySelector('[data-sale-quantity]').value||0),gross=price*qty,reduced=row.querySelector('[data-sale-discount]').checked,discount=reduced?Math.min(gross,Number(row.querySelector('[data-sale-discount-amount]').value||0)):0,line=Math.max(0,gross-discount),currency=option?.dataset.currency||'';if(currency)totals.set(currency,(totals.get(currency)||0)+line);row.querySelector('[data-sale-line-total]').textContent=moneyCurrencyLabel(line,currency);});const summary=[...totals].map(([currency,total])=>moneyCurrencyLabel(total,currency)).join(' · ')||moneyCurrencyLabel(0,'');const itemCount=[...linesBox.querySelectorAll('[data-sale-line]')].reduce((count,row)=>count+Number(row.querySelector('[data-sale-quantity]').value||0),0);modal.querySelector('[data-sale-total]').textContent=`Totaux par monnaie : ${summary} · ${itemCount} article(s)`;}
  addLine();await loadCatalog();branchSelect.addEventListener('change',loadCatalog);modal.querySelector('[data-sale-add-line]').addEventListener('click',addLine);linesBox.addEventListener('input',event=>{if(event.target.matches('[data-sale-quantity]'))refreshSaleAvailability(event.target.closest('[data-sale-line]'));if(event.target.matches('[data-sale-quantity],[data-sale-price],[data-sale-discount-amount]'))refreshSaleTotal();});linesBox.addEventListener('change',event=>{const row=event.target.closest('[data-sale-line]');if(event.target.matches('[data-sale-discount]')){const field=row.querySelector('[data-sale-discount-field]'),input=row.querySelector('[data-sale-discount-amount]');field.hidden=!event.target.checked;input.disabled=!event.target.checked;if(!event.target.checked)input.value='0';}if(event.target.matches('[data-sale-product]')){refreshSaleAvailability(row);refreshSaleLinePrice(row);}refreshSaleTotal();});linesBox.addEventListener('click',event=>{if(event.target.closest('[data-sale-remove]')){event.target.closest('[data-sale-line]').remove();refreshSaleTotal();}});modal.querySelector('.modal-cancel').addEventListener('click',()=>modal.remove());
  form.addEventListener('submit',async event=>{event.preventDefault();const items=[...linesBox.querySelectorAll('[data-sale-line]')].map(row=>({produit_id:Number(row.querySelector('[data-sale-product]').value),quantity:Number(row.querySelector('[data-sale-quantity]').value),unit_price:Number(row.querySelector('[data-sale-price]').value||0),discount_enabled:row.querySelector('[data-sale-discount]').checked?1:0,discount_amount:Number(row.querySelector('[data-sale-discount-amount]').value||0)}));if(items.some(item=>!item.produit_id)){showToast('Choisissez un produit sur chaque ligne.');return;}if([...linesBox.querySelectorAll('[data-sale-line]')].some(row=>{const option=row.querySelector('[data-sale-product]').selectedOptions[0];return Number(option?.dataset.price||0)<=0&&Number(row.querySelector('[data-sale-price]').value||0)<=0;})){showToast('Saisissez un prix de vente positif pour chaque produit concerné.');return;}const body={invoice_no:form.elements.namedItem('invoice_no').value.trim(),succursale_id:Number(branchSelect.value),caisse_id:null,client_id:clientSelect.value||null,client_comptoir_name:clientSelect.value?'':counterClientInput.value.trim(),items};try{const response=await fetch('../backend/public/auth.php?action=create-sale',{method:'POST',headers:{'Content-Type':'application/json'},credentials:'include',body:JSON.stringify(body)});const result=await readJson(response);if(!response.ok||!result.success)throw new Error(result.message||'Enregistrement de la vente impossible.');modal.remove();showToast('Vente enregistrée. La facture est disponible dans la liste.');loadSalesRows();loadCashRows();loadStock();}catch(error){showToast(error.message);}});
}
function labelSaleInvoiceButtons(root) {
  root.querySelectorAll('[data-sale-receipt]').forEach(button => {
    button.dataset.saleInvoice = button.dataset.saleReceipt;
    delete button.dataset.saleReceipt;
    button.className = 'document-action-button';
    button.textContent = 'Facture';
    button.title = 'Imprimer la facture';
    button.setAttribute('aria-label', 'Imprimer la facture');
  });
}
async function loadSalesRows(page = 1) {
  const body = document.getElementById('sales-rows'); if (!body) return;
  try {
    const result = await fetchReportPage('sales-list', page);
    const sales = result.rows;
    document.getElementById('sales-count').textContent = `${result.pagination.total} vente${result.pagination.total === 1 ? '' : 's'} enregistrée${result.pagination.total === 1 ? '' : 's'}`;
    body.innerHTML = sales.length ? sales.map(sale => {const unpaidPending=sale.status==='PENDING'&&Number(sale.amount_paid)<=0;const cancelable=sale.status!=='CANCELLED'&&(unpaidPending||Date.now()-new Date(sale.sale_date).getTime()<172800000);return `<tr data-report-date="${escapeHtml(String(sale.sale_date).slice(0, 10))}"><td>${escapeHtml(sale.invoice_no)}</td><td>${escapeHtml(sale.client_name||'Client comptoir')}</td><td>${escapeHtml(sale.branch_name||'—')}</td><td>${escapeHtml(sale.cashier||'—')}</td><td>${escapeHtml(dateLabel(sale.sale_date))}</td><td>${Number(sale.item_count||0)}</td><td>${escapeHtml(saleCurrencyAmounts(sale,'total_amount'))}</td><td>${escapeHtml(saleCurrencyAmounts(sale,'amount_paid'))}</td><td>${escapeHtml(sale.status)}</td><td><button type="button" title="Imprimer la pièce justificative" aria-label="Imprimer la pièce justificative" data-sale-receipt="${Number(sale.vente_id)}">Imprimer la pièce justificative</button>${cancelable&&hasAccess('modifier_ventes')?` <button type="button" data-sale-cancel="${Number(sale.vente_id)}">Annuler</button>`:''}</td></tr>`;}).join('') : '<tr><td colspan="10">Aucune vente enregistrée.</td></tr>';
    labelSaleInvoiceButtons(body);
    filterCurrentReport();
    showPagination(body, 'sales', result.pagination, loadSalesRows);
  } catch (error) { showLoadError('sales-rows', error, 10); }
}
function ensureBankPanels(){
  if(document.getElementById('bank-admin-panel'))return;
  const externalPanel=document.getElementById('external-payment-rows')?.closest('.panel');
  if(!externalPanel)return;
  externalPanel.insertAdjacentHTML('afterend',`<section class="panel" id="bank-admin-panel"><div class="panel-header"><div><h2>Banques de l’entreprise</h2><p class="panel-subtitle">Créez et gérez les banques associées aux opérations bancaires.</p></div><button type="button" class="text-button" data-bank-form-open>+ Ajouter une banque</button></div><form id="bank-create-form" class="entity-form" style="margin-bottom:16px" hidden><input type="hidden" name="banque_id"><label>Nom de la banque<input name="name" maxlength="120" required placeholder="Ex. Banque Atlantique"></label><label>Numéro de compte (facultatif)<input name="account_number" maxlength="80"></label><div class="entity-modal-actions"><button type="button" class="modal-cancel" data-bank-form-close>Fermer</button><button class="modal-submit">Ajouter la banque</button></div></form><div style="overflow:auto"><table class="data-table"><thead><tr><th>Banque</th><th>Compte</th><th>Actions</th></tr></thead><tbody id="bank-rows"><tr><td colspan="3">Chargement…</td></tr></tbody></table></div></section><section class="panel" id="bank-operations-panel"><div class="panel-header"><div><h2>Opérations par banque</h2><p class="panel-subtitle">Consultez les mouvements rattachés à une banque.</p></div><select id="bank-operation-select" class="select-field"><option value="">Choisir une banque</option></select></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Date</th><th>Banque</th><th>Caisse</th><th>Succursale</th><th>Opération</th><th>Motif</th><th>Montant</th></tr></thead><tbody id="bank-operation-rows"><tr><td colspan="7">Choisissez une banque.</td></tr></tbody></table></div></section>`);
  const form=document.getElementById('bank-create-form'),openButton=document.querySelector('[data-bank-form-open]');
  const resetForm=()=>{form.reset();form.hidden=true;form.querySelector('.modal-submit').textContent='Ajouter la banque';delete form.dataset.editing;};
  if(!hasAccess('modifier_caisse')){form.hidden=true;openButton.hidden=true;}
  openButton.addEventListener('click',()=>{resetForm();form.hidden=false;form.elements.namedItem('name').focus();});
  form.querySelector('[data-bank-form-close]').addEventListener('click',resetForm);
  form.addEventListener('submit',async event=>{
    event.preventDefault();
    const editing=Boolean(form.dataset.editing);
    try{
      const response=await fetch('../backend/public/auth.php?action=banks',{method:editing?'PUT':'POST',headers:{'Content-Type':'application/json'},credentials:'include',body:JSON.stringify(Object.fromEntries(new FormData(form)))});
      const result=await readJson(response);
      if(!response.ok||!result.success)throw new Error(result.message||(editing?'Modification':'Création')+' de la banque impossible.');
      resetForm();
      showToast(editing?'Banque modifiée.':'Banque enregistrée.');
      await loadBanks();
    }catch(error){showToast(error.message);}
  });
  document.getElementById('bank-rows').addEventListener('click',async event=>{
    const edit=event.target.closest('[data-bank-edit]');
    if(edit){
      form.hidden=false;
      form.dataset.editing=edit.dataset.bankEdit;
      form.elements.namedItem('banque_id').value=edit.dataset.bankEdit;
      form.elements.namedItem('name').value=edit.dataset.bankName;
      form.elements.namedItem('account_number').value=edit.dataset.bankAccount||'';
      form.querySelector('.modal-submit').textContent='Enregistrer les modifications';
      form.elements.namedItem('name').focus();
      return;
    }
    const remove=event.target.closest('[data-bank-delete]');
    if(!remove||!window.confirm(`Supprimer la banque « ${remove.dataset.bankName} » de la liste active ?`))return;
    try{
      const response=await fetch(`../backend/public/auth.php?action=banks&banque_id=${encodeURIComponent(remove.dataset.bankDelete)}`,{method:'DELETE',credentials:'include'});
      const result=await readJson(response);
      if(!response.ok||!result.success)throw new Error(result.message||'Suppression de la banque impossible.');
      showToast('Banque supprimée de la liste active.');
      await loadBanks();
    }catch(error){showToast(error.message);}
  });
  document.getElementById('bank-operation-select').addEventListener('change',event=>loadBankOperations(event.currentTarget.value));
}
async function loadBanks(){
  const list=document.getElementById('bank-rows'),select=document.getElementById('bank-operation-select');
  if(!list||!select)return;
  try{
    const response=await fetch('../backend/public/auth.php?action=banks',{credentials:'include',cache:'no-store'}),result=await readJson(response);
    if(!response.ok||!result.success)throw new Error(result.message||'Chargement des banques impossible.');
    const selected=select.value,banks=result.data||[],canEdit=hasAccess('modifier_caisse');
    list.innerHTML=banks.length?banks.map(bank=>`<tr><td>${escapeHtml(bank.name)}</td><td>${escapeHtml(bank.account_number||'—')}</td><td>${canEdit?`<button type="button" data-bank-edit="${Number(bank.banque_id)}" data-bank-name="${escapeHtml(bank.name)}" data-bank-account="${escapeHtml(bank.account_number||'')}">Modifier</button> <button type="button" data-bank-delete="${Number(bank.banque_id)}" data-bank-name="${escapeHtml(bank.name)}">Supprimer</button>`:'—'}</td></tr>`).join(''):'<tr><td colspan="3">Aucune banque enregistrée.</td></tr>';
    select.innerHTML='<option value="">Choisir une banque</option>'+banks.map(bank=>`<option value="${Number(bank.banque_id)}">${escapeHtml(bank.name)}${bank.account_number?` · ${escapeHtml(bank.account_number)}`:''}</option>`).join('');
    if(banks.some(bank=>String(bank.banque_id)===selected))select.value=selected;else if(banks.length)select.value=String(banks[0].banque_id);
    if(select.value)await loadBankOperations(select.value);
  }catch(error){list.innerHTML=`<tr><td colspan="3">${escapeHtml(error.message)}</td></tr>`;}
}
async function loadBankOperations(bankId){
  const body=document.getElementById('bank-operation-rows');if(!body)return;if(!bankId){body.innerHTML='<tr><td colspan="7">Choisissez une banque.</td></tr>';return;}
  try{const result=await fetchReportData('bank-operations',{banque_id:bankId}),summary=result.summary||[],rows=result.operations||[],panel=body.closest('.panel');let summaryBox=panel.querySelector('#bank-balance-summary');if(!summaryBox){summaryBox=document.createElement('div');summaryBox.id='bank-balance-summary';summaryBox.style.overflow='auto';panel.querySelector('.panel-header').after(summaryBox);}summaryBox.innerHTML=summary.length?`<table class="data-table"><thead><tr><th>Monnaie</th><th>Total entrées</th><th>Total sorties</th><th>Solde net</th><th>Opérations</th></tr></thead><tbody>${summary.map(row=>`<tr><td>${escapeHtml(row.monais)}</td><td>${moneyCurrencyLabel(row.entrees,row.monais)}</td><td>${moneyCurrencyLabel(row.sorties,row.monais)}</td><td><strong>${moneyCurrencyLabel(row.solde,row.monais)}</strong></td><td>${Number(row.operations)}</td></tr>`).join('')}</tbody></table>`:'<p class="panel-subtitle">Aucun mouvement comptabilisé pour cette banque.</p>';body.innerHTML=rows.length?rows.map(row=>`<tr data-report-date="${escapeHtml(String(row.movement_date).slice(0,10))}"><td>${escapeHtml(dateLabel(row.movement_date))}</td><td>${escapeHtml(row.bank_name)}</td><td>${escapeHtml(row.cash_name)}</td><td>${escapeHtml(row.branch_name)}</td><td>${escapeHtml(row.type==='ENTREE'?'Entrée':'Sortie')} · ${escapeHtml(row.payment_mode||'Banque')}</td><td>${escapeHtml(row.reason||'—')}${row.bank_reference?`<br><small>Réf. bancaire : ${escapeHtml(row.bank_reference)}</small>`:''}</td><td>${moneyCurrencyLabel(row.amount,row.monais)}</td></tr>`).join(''):'<tr><td colspan="7">Aucune opération enregistrée pour cette banque.</td></tr>';
  }catch(error){body.innerHTML=`<tr><td colspan="7">${escapeHtml(error.message)}</td></tr>`;}
}
function addSalePaymentReceiptActions(body, rows) {
  const header = body?.closest('table')?.tHead?.rows[0];
  if (!body || !header) return;
  if (!header.querySelector('[data-sale-payment-action]')) {
    const actionHeader = document.createElement('th');
    actionHeader.dataset.salePaymentAction = 'true';
    actionHeader.textContent = 'Actions';
    header.append(actionHeader);
  }
  if (body.rows.length === 1 && body.rows[0].querySelector('td[colspan]')) {
    body.rows[0].cells[0].colSpan = header.cells.length;
    return;
  }
  rows.forEach((row, index) => {
    const tableRow = body.rows[index];
    if (!tableRow) return;
    const actionCell = tableRow.insertCell();
    if (Number(row.vente_id || 0) < 1 || (row.operation && row.operation !== 'Vente')) return;
    const button = document.createElement('button');
    button.type = 'button';
    button.className = 'document-action-button';
    button.dataset.salePaymentReceipt = String(Number(row.vente_id));
    button.dataset.salePaymentId = String(Number(row.paiement_id || 0));
    button.dataset.salePaymentAmount = String(Number(row.amount));
    button.dataset.salePaymentCurrency = String(row.monais || '');
    button.dataset.salePaymentDate = String(row.payment_date || row.movement_date || '');
    button.dataset.salePaymentMode = String(row.payment_mode || 'Caisse');
    button.dataset.salePaymentReference = String(row.reference || row.bank_reference || '');
    button.dataset.salePaymentInvoice = String(row.document_no || row.invoice_no || '');
    button.dataset.salePaymentNumber = String(row.mouvement_id || row.paiement_id || '');
    button.textContent = 'Reçu';
    button.title = 'Imprimer le reçu de ce paiement';
    button.setAttribute('aria-label', 'Imprimer le reçu de ce paiement');
    actionCell.append(button);
  });
  body.querySelectorAll('tr[data-report-total]').forEach(row => row.insertCell());
}
function updateExchangeRateLabel(panel) {
  const reference = panel.querySelector('#exchange-reference-form [name="monais"]').value || '…';
  const currency = panel.querySelector('#exchange-rate-form [name="monais"]').value || '…';
  panel.querySelector('[data-exchange-rate-label]').textContent = `Valeur de 1 ${currency} en ${reference}`;
}
function ensureExchangeRatePanel() {
  if (document.getElementById('exchange-rates-panel')) return;
  const cashPanel = document.getElementById('cash-rows')?.closest('.panel');
  if (!cashPanel) return;
  const panel = document.createElement('section');
  panel.id = 'exchange-rates-panel';
  panel.className = 'panel';
  panel.innerHTML = `<div class="panel-header"><div><h2>Taux de change</h2><p class="panel-subtitle">Choisissez la monnaie dans laquelle votre entreprise exprime ses prix. Elle sert de base au calcul des conversions.</p></div></div><form id="exchange-reference-form" class="filter-bar"><label>Monnaie de référence<select name="monais" required></select></label><button type="submit" class="primary-button">Enregistrer la référence</button><button type="button" class="icon-action-button icon-action-danger" data-exchange-reference-delete title="Supprimer la monnaie de référence" aria-label="Supprimer la monnaie de référence" hidden><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h16m-14 0 1 14h10l1-14M9 7V4h6v3m-5 4v6m4-6v6"/></svg></button></form><p class="exchange-rate-help" data-exchange-reference-help></p><form id="exchange-rate-form" class="filter-bar"><label>Monnaie à convertir<select name="monais" required></select></label><label><span data-exchange-rate-label>Valeur de 1 unité en monnaie de référence</span><input name="taux_vers_reference" type="number" min="0.0000000001" step="any" required></label><button type="submit" class="primary-button">Créer le taux</button><button type="button" class="text-button" data-exchange-cancel hidden>Annuler</button></form><p class="panel-subtitle" data-exchange-hint></p><div style="overflow:auto"><table class="data-table"><thead><tr><th>Monnaie</th><th>Taux vers la référence</th><th>Mis à jour le</th><th>Actions</th></tr></thead><tbody data-exchange-rates><tr><td colspan="4">Chargement…</td></tr></tbody></table></div>`;
  cashPanel.insertAdjacentElement('afterend', panel);
  const referenceForm = panel.querySelector('#exchange-reference-form');
  const rateForm = panel.querySelector('#exchange-rate-form');
  const cancelButton = panel.querySelector('[data-exchange-cancel]');
  const deleteReferenceButton = panel.querySelector('[data-exchange-reference-delete]');
  referenceForm.elements.namedItem('monais').addEventListener('change', () => updateExchangeRateLabel(panel));
  rateForm.elements.namedItem('monais').addEventListener('change', () => updateExchangeRateLabel(panel));
  const resetRateForm = () => {
    rateForm.reset();
    rateForm.elements.namedItem('monais').disabled = false;
    rateForm.querySelector('[type="submit"]').textContent = 'Créer le taux';
    cancelButton.hidden = true;
    delete rateForm.dataset.editing;
  };
  cancelButton.addEventListener('click', resetRateForm);
  referenceForm.addEventListener('submit', async event => {
    event.preventDefault();
    try {
      const response = await fetch('../backend/public/auth.php?action=exchange-rates', {method:'POST',headers:{'Content-Type':'application/json'},credentials:'include',body:JSON.stringify({type:'reference',monais:referenceForm.elements.namedItem('monais').value})});
      const result = await readJson(response);
      if (!response.ok || !result.success) throw new Error(result.message || 'Enregistrement de la monnaie de référence impossible.');
      showToast('Monnaie de référence enregistrée.');
      await loadExchangeRates();
    } catch (error) { showToast(error.message); }
  });
  deleteReferenceButton.addEventListener('click', async () => {
    if (!window.confirm('Supprimer la monnaie de référence ? Cette action est possible uniquement après la suppression de tous les taux de change.')) return;
    try {
      const response = await fetch('../backend/public/auth.php?action=exchange-rates&type=reference', {method:'DELETE',credentials:'include'});
      const result = await readJson(response);
      if (!response.ok || !result.success) throw new Error(result.message || 'Suppression de la monnaie de référence impossible.');
      showToast('Monnaie de référence supprimée.');
      await loadExchangeRates();
    } catch (error) { showToast(error.message); }
  });
  rateForm.addEventListener('submit', async event => {
    event.preventDefault();
    const formData = new FormData(rateForm);
    const currency = String(formData.get('monais') || '');
    const method = rateForm.dataset.editing ? 'PUT' : 'POST';
    try {
      const response = await fetch('../backend/public/auth.php?action=exchange-rates', {method,headers:{'Content-Type':'application/json'},credentials:'include',body:JSON.stringify({type:'rate',monais:currency,taux_vers_reference:Number(formData.get('taux_vers_reference'))})});
      const result = await readJson(response);
      if (!response.ok || !result.success) throw new Error(result.message || 'Enregistrement du taux impossible.');
      resetRateForm();
      showToast(method === 'PUT' ? 'Taux de change modifié.' : 'Taux de change créé.');
      await loadExchangeRates();
    } catch (error) { showToast(error.message); }
  });
  panel.querySelector('[data-exchange-rates]').addEventListener('click', async event => {
    const editButton = event.target.closest('[data-exchange-edit]');
    if (editButton) {
      rateForm.elements.namedItem('monais').value = editButton.dataset.exchangeEdit;
      rateForm.elements.namedItem('monais').disabled = true;
      rateForm.elements.namedItem('taux_vers_reference').value = editButton.dataset.rate;
      rateForm.dataset.editing = editButton.dataset.exchangeEdit;
      rateForm.querySelector('[type="submit"]').textContent = 'Modifier le taux';
      cancelButton.hidden = false;
      updateExchangeRateLabel(panel);
      return;
    }
    const deleteButton = event.target.closest('[data-exchange-delete]');
    if (!deleteButton || !window.confirm(`Supprimer le taux de ${deleteButton.dataset.exchangeDelete} ?`)) return;
    try {
      const response = await fetch(`../backend/public/auth.php?action=exchange-rates&monais=${encodeURIComponent(deleteButton.dataset.exchangeDelete)}`, {method:'DELETE',credentials:'include'});
      const result = await readJson(response);
      if (!response.ok || !result.success) throw new Error(result.message || 'Suppression du taux impossible.');
      showToast('Taux de change supprimé.');
      await loadExchangeRates();
    } catch (error) { showToast(error.message); }
  });
}
async function loadExchangeRates() {
  const panel = document.getElementById('exchange-rates-panel');
  if (!panel) return;
  try {
    const response = await fetch('../backend/public/auth.php?action=exchange-rates', {credentials:'include',cache:'no-store'});
    const result = await readJson(response);
    if (!response.ok || !result.success) throw new Error(result.message || 'Chargement des taux impossible.');
    const data = result.data;
    const referenceForm = panel.querySelector('#exchange-reference-form');
    const rateForm = panel.querySelector('#exchange-rate-form');
    const referenceSelect = referenceForm.elements.namedItem('monais');
    const currencySelect = rateForm.elements.namedItem('monais');
    const currencies = data.currencies || [];
    referenceSelect.innerHTML = currencies.map(item => `<option value="${escapeHtml(item.type_monais)}"${item.type_monais === data.reference_currency ? ' selected' : ''}>${escapeHtml(item.type_monais)}${item.description ? ` · ${escapeHtml(item.description)}` : ''}</option>`).join('');
    const selectedCurrency = currencySelect.value;
    currencySelect.innerHTML = currencies.filter(item => item.type_monais !== data.reference_currency).map(item => `<option value="${escapeHtml(item.type_monais)}">${escapeHtml(item.type_monais)}${item.description ? ` · ${escapeHtml(item.description)}` : ''}</option>`).join('');
    if ([...currencySelect.options].some(option => option.value === selectedCurrency)) currencySelect.value = selectedCurrency;
    updateExchangeRateLabel(panel);
    const editable = hasAccess('voir_caisse');
    referenceForm.hidden = !editable;
    rateForm.hidden = !editable;
    referenceSelect.disabled = !editable || currencies.length === 0;
    const deleteReferenceButton = panel.querySelector('[data-exchange-reference-delete]');
    deleteReferenceButton.hidden = !editable || !data.reference_currency;
    deleteReferenceButton.disabled = !editable || !data.reference_currency;
    rateForm.querySelector('[type="submit"]').disabled = !editable || !data.reference_currency || currencySelect.options.length === 0;
    panel.querySelector('[data-exchange-reference-help]').textContent = data.reference_currency
      ? `La référence est ${data.reference_currency}. Exemple : un taux USD de 2 300 signifie 1 USD = 2 300 ${data.reference_currency}, donc 2 300 ${data.reference_currency} = 1 USD. Pour convertir des ${data.reference_currency} en USD, divisez le montant par 2 300. Les paiements sont convertis automatiquement dans les deux sens vers la monnaie de la facture. Pour changer la référence après avoir créé des taux, supprimez d’abord ces taux.`
      : 'Étape 1 : sélectionnez la monnaie habituelle de votre entreprise ci-dessus et enregistrez-la. Ensuite, ajoutez un taux pour chaque autre monnaie.';
    panel.querySelector('[data-exchange-hint]').textContent = data.reference_currency
      ? `Étape 2 : choisissez une autre monnaie et indiquez combien vaut 1 unité de cette monnaie en ${data.reference_currency}. Le taux inverse est calculé automatiquement.`
      : '';
    const rates = data.rates || [];
    panel.querySelector('[data-exchange-rates]').innerHTML = rates.length ? rates.map(rate => {
      const isReference = rate.monais === data.reference_currency;
      const rateValue = Number(rate.taux_vers_reference);
      const rateLabel = rateValue.toLocaleString('fr-FR',{maximumFractionDigits:10});
      const inverseLabel = rateValue > 0 ? `${rateValue.toLocaleString('fr-FR',{maximumFractionDigits:10})} ${escapeHtml(data.reference_currency || '')} = 1 ${escapeHtml(rate.monais)}` : '';
      return `<tr><td>${escapeHtml(rate.monais)}${isReference ? ' (référence)' : ''}</td><td>${isReference ? '1' : `1 ${escapeHtml(rate.monais)} = ${rateLabel} ${escapeHtml(data.reference_currency || '')}${inverseLabel ? `<br><small>${inverseLabel}</small>` : ''}`}</td><td>${escapeHtml(rate.updated_at || '—')}</td><td>${!editable || isReference ? '—' : `<button type="button" class="icon-action-button" data-exchange-edit="${escapeHtml(rate.monais)}" data-rate="${rateValue}" title="Modifier le taux ${escapeHtml(rate.monais)}" aria-label="Modifier le taux ${escapeHtml(rate.monais)}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 20h9"/><path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L8 18l-4 1 1-4Z"/></svg></button> <button type="button" class="icon-action-button icon-action-danger" data-exchange-delete="${escapeHtml(rate.monais)}" title="Supprimer le taux ${escapeHtml(rate.monais)}" aria-label="Supprimer le taux ${escapeHtml(rate.monais)}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h16m-14 0 1 14h10l1-14M9 7V4h6v3m-5 4v6m4-6v6"/></svg></button>`}</td></tr>`;
    }).join('') : '<tr><td colspan="4">Aucun taux enregistré.</td></tr>';
  } catch (error) {
    panel.querySelector('[data-exchange-rates]').innerHTML = `<tr><td colspan="4">${escapeHtml(error.message)}</td></tr>`;
  }
}
async function loadCashRows(page = 1, movementPage = 1) {
  const body = document.getElementById('cash-rows'); if (!body) return;
  try {
    const [result,movementResult,externalPayments] = await Promise.all([fetchReportPage('cashboxes-list', page),fetchReportPage('cash-movements',movementPage),fetchReportData('payment-journal')]);
    const cashboxes = result.rows;
    body.innerHTML = cashboxes.length ? cashboxes.map(item => `<tr data-report-date="${escapeHtml(String(item.date_ouverture||'').slice(0,10))}"><td>${escapeHtml(item.name)}</td><td>${escapeHtml(branchOptions.find(branch => Number(branch.succursale_id) === Number(item.succursale_id))?.name || `ID ${Number(item.succursale_id)}`)}</td><td>${escapeHtml(item.currency_name)} (${escapeHtml(item.monais)}) · ${escapeHtml(item.payment_mode)}${item.bank_name?` · ${escapeHtml(item.bank_name)}`:``}</td><td>${escapeHtml(dateLabel(item.date_ouverture))}</td><td>${moneyCurrencyLabel(item.solde_ouverture,item.monais)}</td><td>${moneyCurrencyLabel(item.solde_courant,item.monais)}</td><td>${item.statut === 'FERMEE' ? moneyCurrencyLabel(item.solde_fermeture,item.monais) : '—'}</td><td>${escapeHtml(item.statut)}</td><td>${item.statut === 'OUVERTE' && hasAccess('modifier_caisse') ? `<button type="button" data-cash-close="${Number(item.caisse_id)}">Clôturer</button>` : item.statut === 'FERMEE' && hasAccess('creer_caisse') ? `<button type="button" data-cash-reopen="${Number(item.caisse_id)}" data-cash-name="${escapeHtml(item.name)}" data-cash-branch="${Number(item.succursale_id)}" data-cash-currency="${escapeHtml(item.monais)}" data-cash-mode="${Number(item.mode_paiement_id)}">Ouvrir</button>` : '—'}</td></tr>`).join('') : '<tr><td colspan="8">Aucune caisse enregistrée.</td></tr>';
    cashboxes.forEach((item,index)=>{const row=body.rows[index];if(!row)return;const reopen=row.querySelector('[data-cash-reopen]');if(reopen)reopen.dataset.cashBank=String(item.banque_id||'');if(item.statut==='FERMEE'&&hasAccess('supprimer_caisse'))row.cells[row.cells.length-1].insertAdjacentHTML('beforeend',` <button type="button" class="icon-action-button" title="Supprimer la caisse" aria-label="Supprimer la caisse" data-cash-delete="${Number(item.caisse_id)}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h16m-14 0 1 14h10l1-14M9 7V4h6v3m-5 4v6m4-6v6"/></svg></button>`);});
    showPagination(body, 'cash', result.pagination, next=>loadCashRows(next,movementPage));
    const movementBody=document.getElementById('cash-movement-rows');if(movementBody){movementBody.innerHTML=movementResult.rows.length?movementResult.rows.map(row=>`<tr data-report-date="${escapeHtml(String(row.movement_date).slice(0,10))}"><td>${escapeHtml(dateLabel(row.movement_date))}</td><td>${escapeHtml(row.cash_name)}</td><td>${escapeHtml(row.type==='ENTREE'?'Entrée':'Sortie')}</td><td>${escapeHtml(row.payment_mode||'Caisse')}</td><td>${escapeHtml(row.reason||'—')}</td><td>${row.reference_id?`#${Number(row.reference_id)}`:'—'}</td><td>${moneyCurrencyLabel(row.amount,row.monais)}</td></tr>`).join(''):'<tr><td colspan="7">Aucun mouvement de caisse enregistré.</td></tr>';const currencySummary=new Map((movementResult.summary||[]).map(item=>[item.monais,{entrees:Number(item.entrees),sorties:Number(item.sorties),operations:Number(item.operations)}]));let summaryBox=movementBody.closest('.panel').querySelector('#cash-currency-summary');if(!summaryBox){summaryBox=document.createElement('div');summaryBox.id='cash-currency-summary';summaryBox.style.overflow='auto';movementBody.closest('.panel').querySelector('.panel-header').after(summaryBox);}summaryBox.innerHTML=currencySummary.size?`<table class="data-table"><thead><tr><th>Monnaie</th><th>Total entrées</th><th>Total sorties</th><th>Solde net</th><th>Opérations</th></tr></thead><tbody>${[...currencySummary].map(([currency,item])=>`<tr><td>${escapeHtml(currency)}</td><td>${moneyCurrencyLabel(item.entrees,currency)}</td><td>${moneyCurrencyLabel(item.sorties,currency)}</td><td><strong>${moneyCurrencyLabel(item.entrees-item.sorties,currency)}</strong></td><td>${item.operations}</td></tr>`).join('')}</tbody></table>`:'<p class="panel-subtitle">Aucun mouvement enregistré.</p>';showPagination(movementBody,'cash-movements',movementResult.pagination,next=>loadCashRows(page,next));}const externalBody=document.getElementById('external-payment-rows');if(externalBody){externalBody.innerHTML=externalPayments.length?externalPayments.map(payment=>`<tr><td>${escapeHtml(dateLabel(payment.payment_date))}</td><td>${escapeHtml(payment.operation)}</td><td>${escapeHtml(payment.document_no)}</td><td>${escapeHtml(payment.branch_name)}</td><td>${escapeHtml(payment.payment_mode)}</td><td>${escapeHtml(payment.reference||'—')}</td><td>${moneyCurrencyLabel(payment.amount,payment.monais)}</td></tr>`).join(''):'<tr><td colspan="7">Aucun paiement externe enregistré.</td></tr>'; }
    const cashSummaryBox=document.getElementById('cash-currency-summary');
    if(cashSummaryBox){
      const balanceByCurrency=new Map((movementResult.summary||[]).map(item=>[item.monais,Number(item.solde)]));
      const balanceHeader=cashSummaryBox.querySelector('thead th:nth-child(4)');
      if(balanceHeader)balanceHeader.textContent='Solde actuel (ouvert)';
      cashSummaryBox.querySelectorAll('tbody tr').forEach(row=>{const currency=row.cells[0]?.textContent||'';if(balanceByCurrency.has(currency)&&row.cells[3])row.cells[3].textContent=moneyCurrencyLabel(balanceByCurrency.get(currency),currency);});
    }
    addSalePaymentReceiptActions(document.getElementById('cash-movement-rows'), movementResult.rows);
    const cashMovementRowsBody = document.getElementById('cash-movement-rows');
    movementResult.rows.forEach((movement, index) => {
      const row = cashMovementRowsBody?.rows[index];
      const actionCell = row?.cells[row.cells.length - 1];
      if (!actionCell || !hasAccess('modifier_caisse') || movement.reference_id !== null || movement.caisse_statut !== 'OUVERTE') return;
      if (movement.annulation_demande_id || movement.annulation_statut === 'EN_ATTENTE') {
        actionCell.innerHTML = '<span class="status warning">En attente</span>';
        return;
      }
      if (movement.annulation_statut === 'APPROUVEE') {
        actionCell.innerHTML = '<span class="status danger">Annulée</span>';
        return;
      }
      actionCell.innerHTML = `<button type="button" class="icon-action-button icon-action-danger" title="Demander l’annulation de cette opération" aria-label="Demander l’annulation de l’opération ${Number(movement.mouvement_id)}" data-cash-cancellation-request="${Number(movement.mouvement_id)}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h16m-14 0 1 14h10l1-14M9 7V4h6v3m-5 4v6m4-6v6"/></svg></button>`;
    });
    addSalePaymentReceiptActions(document.getElementById('external-payment-rows'), externalPayments);
    ensureBankPanels();await loadBanks();ensureExchangeRatePanel();await loadExchangeRates();renderModuleNavigation();
    if(hasAccess('modifier_caisse'))loadPendingSales();
  } catch (error) { showLoadError('cash-rows', error, 9); }
}
async function loadPendingSales(page = 1) {
  let panel = document.getElementById('pending-sales-panel');
  if (!panel) {
    const journal = document.getElementById('cash-movement-rows')?.closest('.panel');
    if (!journal) return;
    panel = document.createElement('section');
    panel.id = 'pending-sales-panel';
    panel.className = 'panel';
    panel.innerHTML = '<div class="panel-header"><div><h2>Ventes à encaisser</h2><p class="panel-subtitle">Consultez les factures en attente et enregistrez leurs paiements par monnaie.</p></div></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Facture</th><th>Client</th><th>Vendeur</th><th>Date</th><th>Totaux par monnaie</th><th>Déjà payé</th><th>Reste à payer</th><th>Actions</th></tr></thead><tbody id="pending-sale-rows"><tr><td colspan="8">Chargement…</td></tr></tbody></table></div>';
    journal.before(panel);
  }

  const body = panel.querySelector('#pending-sale-rows');
  try {
    const result = await fetchReportPage('pending-sales', page);
    panel.querySelector('h2').textContent = `Ventes à encaisser (${result.pagination.total})`;
    body.innerHTML = result.rows.length ? result.rows.map(sale => {
      const balances = Array.isArray(sale.currency_totals) && sale.currency_totals.length ? sale.currency_totals : [{monais:sale.monais,total_amount:sale.total_amount,amount_paid:sale.amount_paid}];
      const dueBalances = balances.map(balance => ({...balance, due:Math.max(0,Number(balance.total_amount)-Number(balance.amount_paid))}));
      const payableBalances = dueBalances.filter(balance => balance.due > 0).map(balance => ({monais:balance.monais || '', due:balance.due}));
      const paymentButton = payableBalances.length ? `<button type="button" data-sale-pay-cash="${Number(sale.vente_id)}" data-sale-balances="${escapeHtml(JSON.stringify(payableBalances))}" data-sale-branch="${Number(sale.succursale_id)}" data-sale-invoice-no="${escapeHtml(sale.invoice_no)}">Payer la facture</button>` : '';
      return `<tr><td>${escapeHtml(sale.invoice_no)}</td><td>${escapeHtml(sale.client_name || 'Client comptoir')}</td><td>${escapeHtml(sale.seller || '—')}</td><td>${escapeHtml(dateLabel(sale.sale_date))}</td><td>${saleCurrencyAmounts(sale,'total_amount')}</td><td>${saleCurrencyAmounts(sale,'amount_paid')}</td><td><strong>${dueBalances.map(balance => moneyCurrencyLabel(balance.due,balance.monais)).join(' · ')}</strong></td><td><button type="button" data-sale-view="${Number(sale.vente_id)}">Voir</button> ${paymentButton}</td></tr>`;
    }).join('') : '<tr><td colspan="8">Aucune vente en attente de paiement.</td></tr>';
    showPagination(body, 'pending-sales', result.pagination, loadPendingSales);
  } catch (error) {
    body.innerHTML = `<tr><td colspan="8">${escapeHtml(error.message)}</td></tr>`;
  }
}
async function openCashForm(reopenCash=null){
  if(!hasAccess('creer_caisse'))return;
  const branches=branchOptions.length?branchOptions:sessionUser?.succursale_id?[{succursale_id:sessionUser.succursale_id,name:sessionUser.branch_name||'Ma succursale'}]:[];
  let currencies=[],modes=[],banks=[];
  try{
    const [currencyResponse,modeResponse,bankResponse]=await Promise.all([
      fetch('../backend/public/auth.php?action=currencies',{credentials:'include',cache:'no-store'}),
      fetch('../backend/public/auth.php?action=payment-modes',{credentials:'include',cache:'no-store'}),
      fetch('../backend/public/auth.php?action=banks',{credentials:'include',cache:'no-store'})
    ]);
    const currencyResult=await readJson(currencyResponse),modeResult=await readJson(modeResponse),bankResult=await readJson(bankResponse);
    if(!currencyResponse.ok||!currencyResult.success)throw new Error(currencyResult.message||'Chargement des monnaies impossible.');
    if(!modeResponse.ok||!modeResult.success)throw new Error(modeResult.message||'Chargement des modes impossible.');
    if(!bankResponse.ok||!bankResult.success)throw new Error(bankResult.message||'Chargement des banques impossible.');
    currencies=(currencyResult.data||[]).filter(currency=>String(currency.type_monais||'').trim()!=='');modes=modeResult.data||[];banks=bankResult.data||[];
    if(!currencies.length||!modes.length)throw new Error('Définissez une monnaie et un mode de paiement avant d’ouvrir une caisse.');
  }catch(error){showToast(error.message);return;}
  const branchesHtml=branches.map(branch=>`<option value="${Number(branch.succursale_id)}" ${Number(branch.succursale_id)===Number(reopenCash?.succursale_id)?'selected':''}>${escapeHtml(branch.name)}</option>`).join('');
  const modal=document.createElement('div');modal.className='entity-modal';
  modal.innerHTML=`<section class="entity-dialog"><h2>${reopenCash?'Ouvrir à nouveau la caisse':'Ouvrir une caisse'}</h2><form class="entity-form"><label class="full">Nom de la caisse<input name="name" required maxlength="100" placeholder="Ex. Caisse principale" value="${escapeHtml(reopenCash?.name||'')}"></label><label>Succursale<select name="succursale_id" required>${branchesHtml}</select></label><label>Monnaie de la caisse<select name="type_monais" required><option value="" ${reopenCash?'':'selected'} disabled>Choisir une monnaie</option>${currencies.map(currency=>`<option value="${escapeHtml(currency.type_monais)}" ${String(currency.type_monais)===String(reopenCash?.monais)?'selected':''}>${escapeHtml(currency.type_monais)} (${escapeHtml(currency.description||currency.type_monais)})</option>`).join('')}</select></label><label>Mode de paiement<select name="mode_paiement_id" required ${reopenCash?'disabled':''}>${modes.map(mode=>`<option value="${Number(mode.mode_paiement_id)}" data-mode-code="${escapeHtml(mode.code)}" ${Number(mode.mode_paiement_id)===Number(reopenCash?.mode_paiement_id)?'selected':''}>${escapeHtml(mode.name)}</option>`).join('')}</select></label><label class="full" data-open-cash-bank-label hidden>Banque<select name="banque_id"><option value="">Choisir une banque</option>${banks.map(bank=>`<option value="${Number(bank.banque_id)}" ${Number(bank.banque_id)===Number(reopenCash?.banque_id)?'selected':''}>${escapeHtml(bank.name)}${bank.account_number?` · ${escapeHtml(bank.account_number)}`:''}</option>`).join('')}</select><small data-open-cash-no-banks ${banks.length?'hidden':''}>Créez d’abord une banque dans le module Caisse.</small></label><label class="full">Solde d’ouverture<input name="solde_ouverture" type="number" min="0" step="0.01" value="0" required></label><div class="entity-modal-actions full"><button type="button" class="modal-cancel">Annuler</button><button class="modal-submit">Ouvrir la caisse</button></div></form></section>`;
  document.body.appendChild(modal);
  const form=modal.querySelector('form'),modeSelect=form.elements.namedItem('mode_paiement_id'),bankLabel=modal.querySelector('[data-open-cash-bank-label]'),bankSelect=form.elements.namedItem('banque_id'),submit=form.querySelector('.modal-submit');
  const syncMode=()=>{const needsBank=modeSelect.selectedOptions[0]?.dataset.modeCode==='BANK';bankLabel.hidden=!needsBank;bankSelect.required=needsBank;bankSelect.disabled=!needsBank;modal.querySelector('[data-open-cash-no-banks]').hidden=banks.length>0;submit.disabled=needsBank&&!banks.length;};
  modeSelect.addEventListener('change',syncMode);syncMode();modal.querySelector('.modal-cancel').addEventListener('click',()=>modal.remove());
  form.addEventListener('submit',async event=>{event.preventDefault();const data=Object.fromEntries(new FormData(form));if(reopenCash)data.mode_paiement_id=Number(reopenCash.mode_paiement_id);data.banque_id=data.banque_id?Number(data.banque_id):null;try{const response=await fetch('../backend/public/auth.php?action=open-cash',{method:'POST',headers:{'Content-Type':'application/json'},credentials:'include',body:JSON.stringify(data)});const result=await readJson(response);if(!response.ok||!result.success)throw new Error(result.message||'Ouverture impossible.');modal.remove();showToast('Caisse ouverte.');loadCashRows();}catch(error){showToast(error.message);}});
}async function openCashMovementForm(type='ENTREE'){if(!hasAccess('modifier_caisse'))return;let boxes=[],banks=[];try{let page=1,pages=1;while(page<=pages){const result=await fetchReportPage('cashboxes-list',page);boxes.push(...result.rows);pages=result.pagination.pages;page++;}boxes=boxes.filter(c=>c.statut==='OUVERTE');const response=await fetch('../backend/public/auth.php?action=banks',{credentials:'include'}),result=await readJson(response);if(!response.ok||!result.success)throw new Error(result.message||'Chargement des banques impossible.');banks=result.data||[];}catch(error){showToast(error.message);return;}if(!boxes.length){showToast('Ouvrez une caisse avant d’enregistrer un mouvement.');return;}const isEntry=type==='ENTREE';const modal=document.createElement('div');modal.className='entity-modal';modal.innerHTML=`<section class="entity-dialog"><h2>${isEntry?'Entrée manuelle en caisse':'Sortie manuelle de caisse'}</h2><form class="entity-form"><input type="hidden" name="type" value="${type}"><label class="full">Caisse<select name="caisse_id" required>${boxes.map(c=>`<option value="${Number(c.caisse_id)}" data-mode-code="${escapeHtml(c.payment_mode_code)}" data-bank-id="${Number(c.banque_id||0)}">${escapeHtml(c.name)} · ${escapeHtml(c.payment_mode)} · ${escapeHtml(c.monais)}</option>`).join('')}</select></label><label class="full" data-manual-bank-label>Banque<select name="banque_id">${banks.map(bank=>`<option value="${Number(bank.banque_id)}">${escapeHtml(bank.name)}${bank.account_number?` · ${escapeHtml(bank.account_number)}`:''}</option>`).join('')}</select><small data-manual-no-banks ${banks.length?'hidden':''}>Créez d’abord une banque dans le module Caisse.</small></label><label class="full">Montant<input name="amount" type="number" min="0.01" step="0.01" required></label><label class="full">Motif<input name="reason" maxlength="150" required placeholder="${isEntry?'Ex. Dépôt, autre revenu…':'Ex. Dépense, retrait…'}"></label><div class="entity-modal-actions full"><button type="button" class="modal-cancel">Annuler</button><button class="modal-submit ${isEntry?'cash-submit-in':'cash-submit-out'}">${isEntry?'＋ Enregistrer l’entrée':'－ Enregistrer la sortie'}</button></div></form></section>`;document.body.appendChild(modal);const form=modal.querySelector('form'),cashSelect=form.elements.namedItem('caisse_id'),bankLabel=modal.querySelector('[data-manual-bank-label]'),bankSelect=form.elements.namedItem('banque_id'),submit=form.querySelector('.modal-submit'),bankReferenceLabel=document.createElement('label');bankReferenceLabel.className='full';bankReferenceLabel.innerHTML='<span>Référence de l’opération bancaire</span><input name="bank_reference" maxlength="120" placeholder="N° de virement ou reçu">';bankLabel.after(bankReferenceLabel);const bankReference=bankReferenceLabel.querySelector('input');const syncCash=()=>{const selected=cashSelect.selectedOptions[0],isBank=selected?.dataset.modeCode==='BANK',linkedBank=selected?.dataset.bankId||'';if(linkedBank)bankSelect.value=linkedBank;bankLabel.hidden=!isBank;bankSelect.required=isBank;bankSelect.disabled=!isBank||Boolean(linkedBank);bankReferenceLabel.hidden=!isBank;bankReference.required=isBank;bankReference.disabled=!isBank;submit.disabled=isBank&&!banks.length;};cashSelect.addEventListener('change',syncCash);syncCash();modal.querySelector('.modal-cancel').addEventListener('click',()=>modal.remove());form.addEventListener('submit',async e=>{e.preventDefault();const data=Object.fromEntries(new FormData(form));data.banque_id=Number(cashSelect.selectedOptions[0]?.dataset.bankId||data.banque_id||0)||null;try{const response=await fetch('../backend/public/auth.php?action=create-cash-movement',{method:'POST',headers:{'Content-Type':'application/json'},credentials:'include',body:JSON.stringify(data)});const result=await readJson(response);if(!response.ok||!result.success)throw new Error(result.message||'Enregistrement impossible.');modal.remove();showToast(isEntry?'Entrée manuelle enregistrée.':'Sortie manuelle enregistrée.');loadCashRows();}catch(error){showToast(error.message);}});}
async function loadPurchaseRows(page = 1) {
  const body = document.getElementById('purchase-rows'); if (!body) return;
  try {
    const pageResult = await fetchReportPage('procurement-list', page);
    const purchases = pageResult.rows;
    const header = body.closest('table')?.tHead?.rows[0];
    if (header) header.innerHTML = '<th>Référence</th><th>Motif</th><th>Date</th><th>Quantité</th><th>Quantité sortie</th><th>Quantité entrée</th><th>Solde du lot</th><th>Total</th><th>Statut</th><th>Bon</th>';
    body.innerHTML = purchases.length ? purchases.map(item => {
      const unit = item.unit_abbreviation || item.unit_name || '';
      const isPerishableLot = Boolean(item.date_expiration);
      const quantityOut = item.movement_type === 'OUT'
        ? `${Number(item.total_quantity || 0).toLocaleString('fr-FR')} ${unit}`.trim()
        : isPerishableLot ? `${Number(item.quantity_out || 0).toLocaleString('fr-FR')} ${unit}`.trim() : '—';
      const remaining = isPerishableLot ? `${Number(item.remaining_quantity || 0).toLocaleString('fr-FR')} ${unit}`.trim() : '—';
      const incoming = item.movement_type === 'IN' ? `${Number(item.total_quantity || 0).toLocaleString('fr-FR')} ${unit}`.trim() : '—';
      const reason = item.movement_type === 'OUT' ? (item.motif_sortie || 'Sortie stock') : (item.supplier_name || 'Approvisionnement');
      const canCancel = item.status === 'PENDING';
      const canCancelValidated = item.status === 'RECEIVED' && item.validation_date && Date.now() - new Date(item.validation_date).getTime() < 172800000;
      return `<tr data-report-date="${escapeHtml(String(item.validation_date || '').slice(0, 10))}" data-purchase-movement="${escapeHtml(item.movement_type)}" data-purchase-status="${escapeHtml(item.status)}" data-purchase-quantity="${Number(item.total_quantity || 0)}"><td>${escapeHtml(item.purchase_no)}</td><td>${escapeHtml(reason)}</td><td>${escapeHtml(item.validation_date ? dateLabel(item.validation_date) : '—')}</td><td>${Number(item.total_quantity || 0).toLocaleString('fr-FR')} ${escapeHtml(unit)}</td><td>${escapeHtml(quantityOut)}</td><td>${escapeHtml(incoming)}</td><td>${escapeHtml(remaining)}</td><td>${moneyLabel(item.total_amount)} ${escapeHtml(item.monais || '')}</td><td>${escapeHtml(purchaseStatusLabel(item.status))}${item.status === 'PENDING' ? ` <button type="button" data-purchase-validate="${Number(item.achat_id)}">Valider</button><button type="button" data-purchase-cancel="${Number(item.achat_id)}">Annuler</button>` : canCancelValidated ? ` <button type="button" data-purchase-cancel="${Number(item.achat_id)}">Annuler</button>` : ''}</td><td><button type="button" class="document-action-button purchase-voucher-button" title="Imprimer le bon" aria-label="Imprimer le bon" data-purchase-voucher="${Number(item.achat_id)}"><span>Bon</span></button></td></tr>`;
    }).join('') : '<tr><td colspan="10">Aucun approvisionnement enregistré.</td></tr>';
    filterCurrentReport();
    showPagination(body, 'purchases', pageResult.pagination, loadPurchaseRows);
  } catch (error) { showLoadError('purchase-rows', error, 10); }
}
async function loadSupplierRows(page = 1) {
  const body = document.getElementById('supplier-rows'); if (!body) return;
  try {
    const result = await apiGetPage('fournisseurs', page);
    const suppliers = result.rows;
    body.innerHTML = suppliers.length ? suppliers.map(supplier => {
      const branchScoped = Boolean(sessionUser?.succursale_id && !sessionUser?.is_company_admin);
      const canManageThisSupplier = !branchScoped || Number(supplier.succursale_id) === Number(sessionUser.succursale_id);
      const actions = canManageThisSupplier && (hasAccess('modifier_fournisseurs') || hasAccess('supprimer_fournisseurs')) ? `${hasAccess('modifier_fournisseurs') ? `<button class="text-button" data-supplier-edit="${Number(supplier.fournisseur_id)}">Modifier</button>` : ''} ${hasAccess('supprimer_fournisseurs') ? `<button class="text-button" data-supplier-delete="${Number(supplier.fournisseur_id)}">Supprimer</button>` : ''}` : '—';
      return `<tr><td>${escapeHtml(supplier.name)}</td><td>${escapeHtml(supplier.contact_name || '—')}</td><td>${escapeHtml(supplier.email || '—')}</td><td>${escapeHtml(supplier.phone || '—')}</td><td>${actions}</td></tr>`;
    }).join('') : '<tr><td colspan="5">Aucun fournisseur enregistré.</td></tr>';
    showPagination(body, 'suppliers', result.pagination, loadSupplierRows);
  } catch (error) { showLoadError('supplier-rows', error, 5); }
}
async function loadDashboardData() {
  const lowRows = document.getElementById('dash-low-stock'); if (!lowRows) return;
  const [stocksResult, salesResult] = await Promise.allSettled([fetchStockSummary(), fetchReportPage('sales-list', 1)]);
  if (stocksResult.status === 'fulfilled') {
    const summary = stocksResult.value;
    document.getElementById('dash-products').textContent = Number(summary.products_count).toLocaleString('fr-FR');
    setQuantitySummary(document.getElementById('dash-quantity'), summary.branches.map(row => ({unit_abbreviation:row.unit_abbreviation, unit_name:row.unit_name, quantity:row.quantity})));
    document.getElementById('dash-alerts').textContent = Number(summary.low_stock_count).toLocaleString('fr-FR');
    lowRows.innerHTML = summary.low_stock_rows.length ? summary.low_stock_rows.map(item => { const unit = item.unit_abbreviation || item.unit_name || ''; return `<tr><td>${escapeHtml(item.name)}</td><td>${escapeHtml(item.branch_name || '—')}</td><td>${Number(item.quantity)} ${escapeHtml(unit)}</td><td>${Number(item.min_stock_level)} ${escapeHtml(unit)}</td></tr>`; }).join('') : '<tr><td colspan="4">Aucun produit sous son seuil minimum.</td></tr>';
  } else {
    document.getElementById('dash-products').textContent = '—'; document.getElementById('dash-quantity').textContent = '—'; document.getElementById('dash-alerts').textContent = '—';
    showLoadError('dash-low-stock', stocksResult.reason, 4);
  }
  document.getElementById('dash-sales').textContent = salesResult.status === 'fulfilled' ? Number(salesResult.value.pagination.total).toLocaleString('fr-FR') : '—';
}
async function loadAccountingData() {
  if (!document.getElementById('accounting-report-type')) return;
  setAccountingDateDefaults();
  await populateAccountingCurrencies();
  await loadAccountingAccounts();
  await Promise.all([loadAccountingEntryRows(), loadAccountingDrafts()]);
}
function renderAccountingDraftPanel(container) {
  const entriesSection = container.querySelector('#accounting-entry-rows')?.closest('.panel');
  if (!entriesSection) return;
  const panel = document.createElement('section');
  panel.className = 'panel';
  panel.innerHTML = `<div class="panel-header"><div><h2>Brouillons comptables</h2><p class="panel-subtitle">Enregistrez vos saisies, reprenez-les plus tard et validez-les lorsqu’elles sont prêtes.</p></div></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Date</th><th>Journal</th><th>Référence</th><th>Libellé</th><th>Lignes</th><th>Total débit</th><th>Total crédit</th><th>Actions</th></tr></thead><tbody id="accounting-draft-rows"><tr><td colspan="8">Chargement…</td></tr></tbody></table></div>`;
  entriesSection.before(panel);
}
let accountingCancellationCount = 0;
let cashCancellationCount = 0;
function updateRequestsBadge() {
  const badge = document.querySelector('.nav-item[data-view="requests"] .nav-badge');
  const total = accountingCancellationCount + cashCancellationCount;
  if (badge) {
    badge.textContent = String(total);
    badge.hidden = total === 0;
  }
}
async function loadEntryCancellationRequests() {
  const rows = document.getElementById('accounting-cancellation-rows');
  if (!rows || !sessionUser?.is_company_admin) return;
  try {
    const requests = await fetchReportData('accounting-cancellation-requests');
    accountingCancellationCount = requests.length;
    updateRequestsBadge();
    rows.innerHTML = requests.length ? requests.map(request => `<tr><td>${escapeHtml(dateLabel(request.created_at))}</td><td>${escapeHtml(request.reference)} · ${escapeHtml(request.libelle)}</td><td>${escapeHtml(request.demandeur || 'Compte supprimé')}</td><td>${escapeHtml(request.motif)}</td><td><div class="user-action-group"><button type="button" class="icon-action-button icon-action-success" title="Approuver l’annulation" aria-label="Approuver l’annulation de ${escapeHtml(request.reference)}" data-entry-cancellation-decision="APPROUVER" data-cancellation-request-id="${Number(request.demande_id)}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m5 12 4 4L19 6"/></svg></button><button type="button" class="icon-action-button icon-action-danger" title="Refuser la demande" aria-label="Refuser la demande pour ${escapeHtml(request.reference)}" data-entry-cancellation-decision="REFUSER" data-cancellation-request-id="${Number(request.demande_id)}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m6 6 12 12M18 6 6 18"/></svg></button></div></td></tr>`).join('') : '<tr><td colspan="5">Aucune demande d’annulation en attente.</td></tr>';
  } catch (error) {
    rows.innerHTML = `<tr><td colspan="5">${escapeHtml(error.message)}</td></tr>`;
  }
}
async function loadCashMovementCancellationRequests() {
  const rows = document.getElementById('cash-cancellation-rows');
  if (!rows || !sessionUser?.is_company_admin) return;
  try {
    const requests = await fetchReportData('cash-cancellation-requests');
    cashCancellationCount = requests.length;
    updateRequestsBadge();
    rows.innerHTML = requests.length ? requests.map(request => `<tr><td>${escapeHtml(dateLabel(request.created_at))}</td><td>${escapeHtml(request.cash_name)} · ${escapeHtml(request.currency)}</td><td>${escapeHtml(request.type === 'ENTREE' ? 'Entrée' : 'Sortie')} · ${moneyCurrencyLabel(request.amount, request.currency)}<br><small>${escapeHtml(request.reason || '—')}</small></td><td>${escapeHtml(request.demandeur || 'Compte supprimé')}</td><td>${escapeHtml(request.motif)}</td><td><div class="user-action-group"><button type="button" class="icon-action-button icon-action-success" title="Approuver l’annulation" aria-label="Approuver l’annulation de l’opération ${Number(request.mouvement_id)}" data-cash-cancellation-decision="APPROUVER" data-cancellation-request-id="${Number(request.demande_id)}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m5 12 4 4L19 6"/></svg></button><button type="button" class="icon-action-button icon-action-danger" title="Refuser la demande" aria-label="Refuser la demande ${Number(request.demande_id)}" data-cash-cancellation-decision="REFUSER" data-cancellation-request-id="${Number(request.demande_id)}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m6 6 12 12M18 6 6 18"/></svg></button></div></td></tr>`).join('') : '<tr><td colspan="6">Aucune demande d’annulation de caisse en attente.</td></tr>';
  } catch (error) {
    rows.innerHTML = `<tr><td colspan="6">${escapeHtml(error.message)}</td></tr>`;
  }
}
function openEntryCancellationRequest(entryId) {
  const modal = document.createElement('div');
  modal.className = 'entity-modal';
  modal.innerHTML = `<section class="entity-dialog"><h2>Demander l’annulation</h2><p>La demande sera transmise à l’administrateur de l’entreprise. L’écriture restera active jusqu’à sa décision.</p><form class="entity-form"><label class="full">Motif de l’annulation<textarea name="motif" maxlength="500" required></textarea></label><div class="entity-modal-actions full"><button type="button" class="modal-cancel">Annuler</button><button class="modal-submit">Envoyer la demande</button></div></form></section>`;
  document.body.appendChild(modal);
  const form = modal.querySelector('form');
  modal.querySelector('.modal-cancel').addEventListener('click', () => modal.remove());
  form.addEventListener('submit', async event => {
    event.preventDefault();
    const submitButton = form.querySelector('.modal-submit');
    submitButton.disabled = true;
    try {
      const response = await fetch('../backend/public/report-data.php?action=accounting-cancellation-request', {method: 'POST', headers: {'Content-Type': 'application/json'}, credentials: 'include', body: JSON.stringify({ecriture_id: entryId, motif: form.elements.namedItem('motif').value.trim()})});
      const result = await readJson(response);
      if (!response.ok || !result.success) throw new Error(result.message || 'Envoi de la demande impossible.');
      modal.remove();
      await loadAccountingEntryRows();
      if (sessionUser?.is_company_admin) await loadEntryCancellationRequests();
      showToast('Demande d’annulation envoyée à l’administrateur.');
    } catch (error) {
      showToast(error.message);
    } finally {
      if (submitButton.isConnected) submitButton.disabled = false;
    }
  });
}
function openCashMovementCancellationRequest(movementId) {
  const modal = document.createElement('div');
  modal.className = 'entity-modal';
  modal.innerHTML = `<section class="entity-dialog"><h2>Demander l’annulation de l’opération</h2><p>La demande sera transmise à l’administrateur de l’entreprise. Le solde ne changera qu’après son approbation.</p><form class="entity-form"><label class="full">Motif de l’annulation<textarea name="motif" maxlength="500" required></textarea></label><div class="entity-modal-actions full"><button type="button" class="modal-cancel">Annuler</button><button class="modal-submit">Envoyer la demande</button></div></form></section>`;
  document.body.appendChild(modal);
  const form = modal.querySelector('form');
  modal.querySelector('.modal-cancel').addEventListener('click', () => modal.remove());
  form.addEventListener('submit', async event => {
    event.preventDefault();
    const submitButton = form.querySelector('.modal-submit');
    submitButton.disabled = true;
    try {
      const response = await fetch('../backend/public/report-data.php?action=cash-cancellation-request', {method: 'POST', headers: {'Content-Type': 'application/json'}, credentials: 'include', body: JSON.stringify({mouvement_id: movementId, motif: form.elements.namedItem('motif').value.trim()})});
      const result = await readJson(response);
      if (!response.ok || !result.success) throw new Error(result.message || 'Envoi de la demande impossible.');
      modal.remove();
      await loadCashRows();
      if (sessionUser?.is_company_admin) await loadCashMovementCancellationRequests();
      showToast('Demande d’annulation envoyée à l’administrateur.');
    } catch (error) {
      showToast(error.message);
    } finally {
      if (submitButton.isConnected) submitButton.disabled = false;
    }
  });
}
function setAccountingDateDefaults() {
  const fromInput = document.getElementById('accounting-from');
  const toInput = document.getElementById('accounting-to');
  if (!fromInput || !toInput) return;
  if (!fromInput.value) {
    const fromDate = new Date();
    fromDate.setDate(fromDate.getDate() - 30);
    fromInput.value = localDateInputValue(fromDate);
  }
  if (!toInput.value) {
    const toDate = new Date();
    toInput.value = localDateInputValue(toDate);
  }
}
function localDateInputValue(date) {
  const localDate = new Date(date.getTime() - date.getTimezoneOffset() * 60000);
  return localDate.toISOString().slice(0, 10);
}
async function populateAccountingCurrencies() {
  const currencySelect = document.getElementById('accounting-currency');
  if (!currencySelect) return;
  try {
    const response = await fetch('../backend/public/auth.php?action=currencies', {credentials: 'include'});
    const result = await readJson(response);
    if (!response.ok || !result.success) throw new Error(result.message || 'Chargement des monnaies impossible.');
    const currencies = result.data || [];
    const currentValue = currencySelect.value || 'USD';
    currencySelect.innerHTML = '<option value="">Choisir une monnaie</option>' + currencies.map(currency => `<option value="${escapeHtml(currency.type_monais)}">${escapeHtml(currency.type_monais)}${currency.description ? ` — ${escapeHtml(currency.description)}` : ''}</option>`).join('');
    const exists = currencies.some(currency => String(currency.type_monais) === String(currentValue));
    currencySelect.value = exists ? currentValue : (currencies[0]?.type_monais || '');
  } catch (error) {
    currencySelect.innerHTML = '<option value="">Monnaie inaccessible</option>';
    showToast(error.message);
  }
}
let accountingAccountPage = 1;
async function loadAccountingAccounts(page = accountingAccountPage) {
  const accountSelect = document.getElementById('accounting-account');
  const accountRows = document.getElementById('accounting-account-rows');
  if (!accountSelect && !accountRows) return;
  try {
    const accounts = await fetchReportData('accounting-accounts');
    if (accountSelect) accountSelect.innerHTML = '<option value="">Sélectionner un compte</option>' + accounts.map(account => `<option value="${Number(account.compte_id)}">${escapeHtml(account.code)} — ${escapeHtml(account.intitule)}</option>`).join('');
    const totalPages = Math.max(1, Math.ceil(accounts.length / PAGE_SIZE));
    accountingAccountPage = Math.min(Math.max(1, page), totalPages);
    const visibleAccounts = accounts.slice((accountingAccountPage - 1) * PAGE_SIZE, accountingAccountPage * PAGE_SIZE);
    if (accountRows) {
      accountRows.innerHTML = visibleAccounts.length ? visibleAccounts.map(account => `<tr><td>${escapeHtml(account.code)}</td><td>${escapeHtml(account.intitule)}</td><td>${Number(account.classe)}</td><td>${escapeHtml(account.nature)}</td><td>${escapeHtml(account.parent_code ? `${account.parent_code} — ${account.parent_intitule}` : '—')}</td><td>${Number(account.is_active) ? 'Actif' : 'Inactif'}</td><td>${Number(account.is_system) ? 'Système' : hasAccess('modifier_comptabilite') ? `<div class="user-action-group"><button type="button" class="icon-action-button" title="Modifier le compte ${escapeHtml(account.code)}" aria-label="Modifier le compte ${escapeHtml(account.code)}" data-account-edit="${Number(account.compte_id)}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m14 6 4 4M4 20l4.5-1L19 8.5 15.5 5 5 15.5 4 20Z"/></svg></button><button type="button" class="icon-action-button icon-action-danger" title="Supprimer le compte ${escapeHtml(account.code)}" aria-label="Supprimer le compte ${escapeHtml(account.code)}" data-account-delete="${Number(account.compte_id)}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h16m-14 0 1 14h10l1-14M9 7V4h6v3m-5 4v6m4-6v6"/></svg></button></div>` : '—'}</td></tr>`).join('') : '<tr><td colspan="7">Aucun compte comptable. Créez d’abord les comptes nécessaires aux écritures.</td></tr>';
      showPagination(accountRows, 'accounting-accounts', {page: accountingAccountPage, per_page: PAGE_SIZE, total: accounts.length, pages: totalPages}, loadAccountingAccounts);
    }
    const reportType = document.getElementById('accounting-report-type')?.value;
    const showAccountFilter = reportType === 'grand-livre';
    const filterWrapper = document.getElementById('accounting-account-filter');
    if (filterWrapper) filterWrapper.hidden = !showAccountFilter;
    if (accountSelect) accountSelect.disabled = !showAccountFilter;
  } catch (error) {
    if (accountSelect) {
      accountSelect.innerHTML = '<option value="">Compte inaccessible</option>';
      accountSelect.disabled = true;
    }
    if (accountRows) accountRows.innerHTML = `<tr><td colspan="7">${escapeHtml(error.message)}</td></tr>`;
    showToast(error.message);
  }
}
async function loadAccountingEntryRows(page = 1) {
  const rowsTarget = document.getElementById('accounting-entry-rows');
  if (!rowsTarget) return;
  const from = document.getElementById('accounting-from')?.value;
  const to = document.getElementById('accounting-to')?.value;
  const currency = document.getElementById('accounting-currency')?.value;
  if (!from || !to || !currency) {
    rowsTarget.innerHTML = '<tr><td colspan="8">Choisissez une période et une monnaie pour afficher le journal.</td></tr>';
    return;
  }
  try {
    const result = await fetchReportPage('accounting-entries', page, {date_debut: from, date_fin: to, monnaie: currency});
    const entries = result.rows;
    rowsTarget.innerHTML = entries.length ? entries.map(entry => `<tr><td>${escapeHtml(dateLabel(entry.date_ecriture))}</td><td>${escapeHtml(entry.journal_code)}</td><td>${escapeHtml(entry.reference)}</td><td>${escapeHtml(entry.libelle)}</td><td>${Number(entry.line_count)}</td><td>${moneyCurrencyLabel(entry.debit_total, entry.monnaie)}</td><td>${moneyCurrencyLabel(entry.credit_total, entry.monnaie)}</td><td>${entry.annulation_demande_id ? '<span class="status warning">En attente</span>' : `<button type="button" class="icon-action-button icon-action-danger" title="Demander l’annulation de l’écriture ${escapeHtml(entry.reference)}" aria-label="Demander l’annulation de l’écriture ${escapeHtml(entry.reference)}" data-entry-cancellation-request="${Number(entry.ecriture_id)}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h16m-14 0 1 14h10l1-14M9 7V4h6v3m-5 4v6m4-6v6"/></svg></button>`}</td></tr>`).join('') : '<tr><td colspan="8">Aucune écriture validée pour cette période et cette monnaie.</td></tr>';
    showPagination(rowsTarget, 'accounting-entries', result.pagination, loadAccountingEntryRows);
  } catch (error) {
    rowsTarget.innerHTML = `<tr><td colspan="8">${escapeHtml(error.message)}</td></tr>`;
  }
}
async function loadAccountingDrafts(page = 1) {
  const target = document.getElementById('accounting-draft-rows');
  if (!target) return;
  try {
    const result = await fetchReportPage('accounting-drafts', page);
    const drafts = result.rows;
    target.innerHTML = drafts.length ? drafts.map(draft => `<tr><td>${escapeHtml(dateLabel(draft.date_ecriture))}</td><td>${escapeHtml(draft.journal_code)}</td><td>${escapeHtml(draft.reference)}</td><td>${escapeHtml(draft.libelle)}</td><td>${Number(draft.line_count)}</td><td>${escapeHtml(moneyCurrencyLabel(draft.debit_total, draft.monnaie))}</td><td>${escapeHtml(moneyCurrencyLabel(draft.credit_total, draft.monnaie))}</td><td>${hasAccess('creer_comptabilite') ? `<div class="user-action-group"><button type="button" class="icon-action-button" title="Modifier le brouillon" aria-label="Modifier le brouillon" data-accounting-draft-edit="${Number(draft.ecriture_id)}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m14 6 4 4M4 20l4.5-1L19 8.5 15.5 5 5 15.5 4 20Z"/></svg></button><button type="button" class="icon-action-button icon-action-success" title="Valider le brouillon" aria-label="Valider le brouillon" data-accounting-draft-validate="${Number(draft.ecriture_id)}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m5 12 4 4L19 6"/></svg></button><button type="button" class="icon-action-button icon-action-danger" title="Supprimer le brouillon" aria-label="Supprimer le brouillon" data-accounting-draft-delete="${Number(draft.ecriture_id)}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h16m-14 0 1 14h10l1-14M9 7V4h6v3m-5 4v6m4-6v6"/></svg></button></div>` : '—'}</td></tr>`).join('') : '<tr><td colspan="8">Aucun brouillon comptable enregistré.</td></tr>';
    showPagination(target, 'accounting-drafts', result.pagination, loadAccountingDrafts);
  } catch (error) {
    target.innerHTML = `<tr><td colspan="8">${escapeHtml(error.message)}</td></tr>`;
  }
}
function toggleAccountingAccountFilter() {
  const reportType = document.getElementById('accounting-report-type')?.value || 'bilan';
  const filterWrapper = document.getElementById('accounting-account-filter');
  const accountSelect = document.getElementById('accounting-account');
  const shouldShow = reportType === 'grand-livre';
  if (filterWrapper) filterWrapper.hidden = !shouldShow;
  if (accountSelect) accountSelect.disabled = !shouldShow;
}
function renderAccountingReportTable(report) {
  const output = document.getElementById('accounting-report-result');
  if (!output) return;
  const rows = report?.type === 'resultat'
    ? [...(report.charges || []).map(row => ({...row, section: 'Charges'})), ...(report.produits || []).map(row => ({...row, section: 'Produits'}))]
    : (report?.rows || []);
  const totals = report?.totals || report?.summary || {debit: 0, credit: 0};
  let summaryHtml = '';
  if (report?.type === 'resultat') {
    summaryHtml = `<div class="report-summary-grid" style="display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:12px;margin:12px 0 18px;">
      <div class="stat-card"><span class="stat-label">Total charges</span><div class="stat-value">${moneyCurrencyLabel(report.total_charges, report.monnaie)}</div></div>
      <div class="stat-card"><span class="stat-label">Total produits</span><div class="stat-value">${moneyCurrencyLabel(report.total_produits, report.monnaie)}</div></div>
      <div class="stat-card"><span class="stat-label">Résultat net</span><div class="stat-value">${moneyCurrencyLabel(report.resultat_net, report.monnaie)}</div></div>
    </div>`;
  } else if (report?.type === 'flux-tresorerie') {
    summaryHtml = `<div class="report-summary-grid" style="display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:12px;margin:12px 0 18px;">
      <div class="stat-card"><span class="stat-label">Total entrées</span><div class="stat-value">${moneyCurrencyLabel(report.total_entrees, report.monnaie)}</div></div>
      <div class="stat-card"><span class="stat-label">Total sorties</span><div class="stat-value">${moneyCurrencyLabel(report.total_sorties, report.monnaie)}</div></div>
      <div class="stat-card"><span class="stat-label">Variation nette</span><div class="stat-value">${moneyCurrencyLabel(report.variation_nette, report.monnaie)}</div></div>
    </div>`;
  } else if (totals && totals.debit !== undefined && totals.credit !== undefined) {
    summaryHtml = `<div class="report-summary-grid" style="display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:12px;margin:12px 0 18px;">
      <div class="stat-card"><span class="stat-label">Débit</span><div class="stat-value">${moneyCurrencyLabel(totals.debit, report?.monnaie || '')}</div></div>
      <div class="stat-card"><span class="stat-label">Crédit</span><div class="stat-value">${moneyCurrencyLabel(totals.credit, report?.monnaie || '')}</div></div>
    </div>`;
  }
  const balanceCheck = report?.balance_check;
  const balanceHtml = balanceCheck ? `<p class="status ${balanceCheck.balanced ? 'success' : 'warning'}" role="status"><strong>${balanceCheck.balanced ? 'Équilibre respecté' : 'Équilibre non respecté'}</strong> · Débit : ${escapeHtml(moneyCurrencyLabel(balanceCheck.debit, report?.monnaie || ''))} · Crédit : ${escapeHtml(moneyCurrencyLabel(balanceCheck.credit, report?.monnaie || ''))} · Écart : ${escapeHtml(moneyCurrencyLabel(Math.abs(Number(balanceCheck.difference)), report?.monnaie || ''))}</p>` : '';
  if (!rows.length) {
    output.innerHTML = `${balanceHtml}${summaryHtml}<p class="empty-note">Aucune donnée pour cet état.</p>`;
    return;
  }
  const allowedKeys = new Set(['section', 'code', 'compte_code', 'compte_id', 'journal_code', 'reference', 'libelle', 'ecriture_libelle', 'date_ecriture', 'monnaie', 'intitule', 'compte_intitule', 'classe', 'nature', 'debit', 'credit', 'solde_cumulatif', 'ouverture_debit', 'ouverture_credit', 'debit_periode', 'credit_periode', 'solde_debit', 'solde_credit', 'total_charges', 'total_produits', 'resultat_net', 'total_entrees', 'total_sorties', 'variation_nette']);
  const labels = Object.keys(rows[0]).filter(key => !['compte_id', 'ligne_id', 'ecriture_id', 'user_id', 'entreprise_id', 'parent_id', 'is_active', 'is_system'].includes(key) && (allowedKeys.has(key) || !key.startsWith('_')));
  const tableHeaders = labels.length ? labels : ['Libellé', 'Débit', 'Crédit'];
  const headerMarkup = tableHeaders.map(key => `<th>${escapeHtml(labelForAccountingKey(key))}</th>`).join('');
  const rowMarkup = rows.map(row => {
    const values = labels.length ? labels.map(key => `<td>${escapeHtml(valueForAccountingCell(row[key]))}</td>`).join('') : `<td>${escapeHtml(Object.values(row).map(value => String(value ?? '')).join(' — '))}</td>`;
    return `<tr>${values}</tr>`;
  }).join('');
  output.innerHTML = `${balanceHtml}${summaryHtml}<div style="overflow:auto"><table class="data-table"><thead><tr>${headerMarkup}</tr></thead><tbody>${rowMarkup || '<tr><td colspan="' + tableHeaders.length + '">Aucune ligne pour cet état.</td></tr>'}</tbody></table></div>`;
}
function labelForAccountingKey(key) {
  const labels = {
    code: 'Code',
    compte_code: 'Compte',
    intitule: 'Intitulé',
    compte_intitule: 'Compte',
    journal_code: 'Journal',
    reference: 'Référence',
    libelle: 'Libellé',
    ecriture_libelle: 'Libellé',
    date_ecriture: 'Date',
    monnaie: 'Monnaie',
    classe: 'Classe',
    nature: 'Nature',
    section: 'Type',
    debit: 'Débit',
    credit: 'Crédit',
    solde_cumulatif: 'Solde cumulé',
    ouverture_debit: 'Ouverture débit',
    ouverture_credit: 'Ouverture crédit',
    debit_periode: 'Débit période',
    credit_periode: 'Crédit période',
    solde_debit: 'Solde débit',
    solde_credit: 'Solde crédit',
    total_charges: 'Total charges',
    total_produits: 'Total produits',
    resultat_net: 'Résultat net',
    total_entrees: 'Total entrées',
    total_sorties: 'Total sorties',
    variation_nette: 'Variation nette'
  };
  return labels[key] || key.replace(/_/g, ' ').replace(/\b\w/g, char => char.toUpperCase());
}
function valueForAccountingCell(value) {
  if (value === null || value === undefined || value === '') return '—';
  if (typeof value === 'number') return Number(value).toLocaleString('fr-FR', {minimumFractionDigits: 2, maximumFractionDigits: 2});
  if (typeof value === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(value.trim())) return dateLabel(value);
  return String(value);
}
async function loadAccountingReport() {
  const printButton = document.querySelector('[data-account-report-print]');
  if (printButton) printButton.disabled = true;
  const reportType = document.getElementById('accounting-report-type')?.value || 'bilan';
  const from = document.getElementById('accounting-from')?.value;
  const to = document.getElementById('accounting-to')?.value;
  const currency = document.getElementById('accounting-currency')?.value;
  const accountId = document.getElementById('accounting-account')?.value;
  if (!from || !to || !currency) {
    showToast('Sélectionnez une période et une monnaie pour générer l’état.');
    return;
  }
  if (reportType === 'grand-livre' && !accountId) {
    showToast('Sélectionnez un compte pour générer le grand livre.');
    return;
  }
  try {
    const params = {type: reportType, date_debut: from, date_fin: to, monnaie: currency};
    if (reportType === 'grand-livre' && accountId) params.compte_id = accountId;
    const report = await fetchReportData('accounting-report', params);
    const title = document.getElementById('accounting-report-title');
    const meta = document.getElementById('accounting-report-meta');
    if (title) title.textContent = report?.type ? {journal:'Journal', 'grand-livre':'Grand livre', balance:'Balance générale', bilan:'Bilan', resultat:'Compte de résultat', 'flux-tresorerie':'Tableau de flux de trésorerie', annexes:'États annexes'}[report.type] || 'État financier' : 'État financier';
    if (meta) meta.textContent = `${dateLabel(from)} au ${dateLabel(to)} · ${currency}`;
    renderAccountingReportTable(report);
    if (printButton) printButton.disabled = false;
  } catch (error) {
    const output = document.getElementById('accounting-report-result');
    if (output) output.innerHTML = `<p class="empty-note">${escapeHtml(error.message)}</p>`;
    if (printButton) printButton.disabled = true;
    showToast(error.message);
  }
}
async function openAccountingAccountForm(accountId = null) {
  try {
    const accounts = await fetchReportData('accounting-accounts');
    const editingAccount = accountId === null ? null : accounts.find(account => Number(account.compte_id) === accountId);
    if (accountId !== null && (!editingAccount || Number(editingAccount.is_system))) throw new Error('Ce compte ne peut pas être modifié.');
    const modal = document.createElement('div');
    modal.className = 'entity-modal';
    const classOptions = '<option value="1">1 — Ressources durables</option><option value="2">2 — Immobilisations</option><option value="3">3 — Stocks</option><option value="4">4 — Tiers</option><option value="5">5 — Trésorerie</option><option value="6">6 — Charges</option><option value="7">7 — Produits</option><option value="8">8 — Autres charges et produits</option><option value="9">9 — Comptabilité analytique</option>';
    const accountFields = editingAccount
      ? `<label>Code<input value="${escapeHtml(editingAccount.code)}" disabled></label><label>Classe<input value="${Number(editingAccount.classe)}" disabled></label>`
      : `<label>Code<input name="code" maxlength="20" required placeholder="Ex. 101100"></label><label>Classe<select name="classe" required>${classOptions}</select></label><label>Compte parent<select name="parent_id"><option value="">Aucun parent</option>${accounts.map(account => `<option value="${Number(account.compte_id)}">${escapeHtml(account.code)} — ${escapeHtml(account.intitule)}</option>`).join('')}</select></label>`;
    modal.innerHTML = `<section class="entity-dialog"><h2>${editingAccount ? 'Modifier un compte comptable' : 'Créer un compte comptable'}</h2><form class="entity-form">${accountFields}<label>Intitulé<input name="intitule" maxlength="160" required value="${escapeHtml(editingAccount?.intitule || '')}"></label><label>Nature<select name="nature" required><option value="DEBIT"${editingAccount?.nature === 'DEBIT' ? ' selected' : ''}>Débit</option><option value="CREDIT"${editingAccount?.nature === 'CREDIT' ? ' selected' : ''}>Crédit</option></select></label>${editingAccount ? `<label>Statut<select name="is_active"><option value="1"${Number(editingAccount.is_active) ? ' selected' : ''}>Actif</option><option value="0"${!Number(editingAccount.is_active) ? ' selected' : ''}>Inactif</option></select></label>` : ''}<div class="entity-modal-actions full"><button type="button" class="modal-cancel">Annuler</button><button class="modal-submit">Enregistrer</button></div></form></section>`;
    document.body.appendChild(modal);
    const form = modal.querySelector('form');
    modal.querySelector('.modal-cancel').addEventListener('click', () => modal.remove());
    form.addEventListener('submit', async event => {
      event.preventDefault();
      const submitButton = form.querySelector('.modal-submit');
      submitButton.disabled = true;
      try {
        const payload = Object.fromEntries(new FormData(form));
        const endpoint = editingAccount
          ? `../backend/public/report-data.php?action=accounting-account&compte_id=${Number(editingAccount.compte_id)}`
          : '../backend/public/report-data.php?action=accounting-accounts';
        const method = editingAccount ? 'PATCH' : 'POST';
        if (editingAccount) payload.is_active = form.elements.namedItem('is_active').checked ? 1 : 0;
        else {
          payload.classe = Number(payload.classe);
          payload.parent_id = payload.parent_id ? Number(payload.parent_id) : null;
        }
        const response = await fetch(endpoint, {method, headers: {'Content-Type': 'application/json'}, credentials: 'include', body: JSON.stringify(payload)});
        const result = await readJson(response);
        if (!response.ok || !result.success) throw new Error(result.message || 'Création du compte impossible.');
        modal.remove();
        await loadAccountingAccounts();
        showToast(editingAccount ? 'Compte comptable modifié.' : 'Compte comptable créé.');
      } catch (error) {
        showToast(error.message);
      } finally {
        if (submitButton.isConnected) submitButton.disabled = false;
      }
    });
  } catch (error) {
    showToast(error.message);
  }
}
function accountingEntryPayload(form) {
  const formData = new FormData(form);
  const lines = [];
  for (const [name, value] of formData.entries()) {
    const match = name.match(/^line_(compte|label|debit|credit)_(\d+)$/);
    if (!match) continue;
    const [, field, index] = match;
    if (!lines[Number(index)]) lines[Number(index)] = {};
    lines[Number(index)][field] = value;
  }
  const prepared = lines.filter(line => line && (
    String(line.label || '').trim() !== '' ||
    (line.debit !== undefined && Number(line.debit) !== 0) ||
    (line.credit !== undefined && Number(line.credit) !== 0)
  )).map(line => ({
    compte_id: Number(line.compte || 0),
    libelle: String(line.label || '').trim() || String(formData.get('libelle') || '').trim(),
    debit: Number(line.debit || 0),
    credit: Number(line.credit || 0)
  }));
  return {
    date_ecriture: String(formData.get('date_ecriture') || ''),
    journal_code: String(formData.get('journal_code') || '').trim().toUpperCase(),
    reference: String(formData.get('reference') || '').trim(),
    libelle: String(formData.get('libelle') || '').trim(),
    monnaie: String(formData.get('monnaie') || '').trim().toUpperCase(),
    lines: prepared
  };
}
async function openAccountingEntryForm(draftId = null) {
  try {
    const [accounts, draft] = await Promise.all([
      fetchReportData('accounting-accounts'),
      draftId ? fetchReportData('accounting-draft', {ecriture_id: draftId}) : Promise.resolve(null)
    ]);
    if (!accounts.length) {
      showToast('Créez d’abord au moins deux comptes comptables pour saisir une écriture.');
      return;
    }
    const currency = document.getElementById('accounting-currency')?.value || 'USD';
    const draftLines = draft?.lines || [];
    const rowCount = Math.max(2, draftLines.length);
    const createLineRow = (index, line = {}) => `
      <div class="accounting-entry-line" style="display:grid;grid-template-columns:1.8fr 1.1fr 1.1fr 1.3fr 0.5fr;gap:8px;align-items:end;padding:10px 0;border-top:1px solid #e8efeb;">
        <label>Compte<select name="line_compte_${index}" required>${accounts.map(account => `<option value="${Number(account.compte_id)}" ${Number(line.compte_id) === Number(account.compte_id) ? 'selected' : ''}>${escapeHtml(account.code)} — ${escapeHtml(account.intitule)}</option>`).join('')}</select></label>
        <label>Libellé de ligne<input name="line_label_${index}" maxlength="255" value="${escapeHtml(line.libelle || '')}" placeholder="Libellé général par défaut"></label>
        <label>Débit<input type="number" min="0" step="0.01" name="line_debit_${index}" value="${Number(line.debit || 0)}"></label>
        <label>Crédit<input type="number" min="0" step="0.01" name="line_credit_${index}" value="${Number(line.credit || 0)}"></label>
        <button type="button" class="icon-action-button" data-account-line-remove="${index}" aria-label="Supprimer cette ligne">×</button>
      </div>`;
    const currencyOptions = [...new Set([currency, draft?.monnaie].filter(Boolean))];
    const modal = document.createElement('div');
    modal.className = 'entity-modal';
    modal.innerHTML = `<section class="entity-dialog"><h2>${draft ? 'Modifier le brouillon comptable' : 'Nouvelle écriture comptable'}</h2><form class="entity-form"><label>Date<input type="date" name="date_ecriture" value="${escapeHtml(draft?.date_ecriture || localDateInputValue(new Date()))}" required></label><label>Code du journal<input name="journal_code" value="${escapeHtml(draft?.journal_code || 'OD')}" maxlength="12" pattern="[A-Za-z0-9_-]{1,12}" title="Utilisez un code de 1 à 12 lettres ou chiffres, sans espace (ex. OD, ACH, VTE)." required placeholder="Ex. OD, ACH, VTE"></label><label>Référence<input name="reference" maxlength="120" value="${escapeHtml(draft?.reference || '')}" required></label><label>Monnaie<select name="monnaie" required>${currencyOptions.map(m => `<option value="${escapeHtml(m)}" ${String(m) === String(draft?.monnaie || currency) ? 'selected' : ''}>${escapeHtml(m)}</option>`).join('')}</select></label><label class="full">Libellé<input name="libelle" maxlength="255" value="${escapeHtml(draft?.libelle || '')}" required></label><div class="full" id="accounting-entry-lines">${Array.from({length: rowCount}, (_, index) => createLineRow(index, draftLines[index] || {})).join('')}</div><div class="entity-modal-actions full"><button type="button" class="modal-cancel">Annuler</button><button type="button" class="text-button" id="accounting-entry-save-draft">Enregistrer le brouillon</button><button type="button" class="text-button" id="accounting-entry-add-line">+ Ajouter une ligne</button><button class="modal-submit">${draft ? 'Valider le brouillon' : 'Valider l’écriture'}</button></div></form></section>`;
    document.body.appendChild(modal);
    const form = modal.querySelector('form');
    const linesContainer = modal.querySelector('#accounting-entry-lines');
    let nextLineIndex = rowCount;
    modal.querySelector('#accounting-entry-add-line').addEventListener('click', () => {
      linesContainer.insertAdjacentHTML('beforeend', createLineRow(nextLineIndex++));
    });
    linesContainer.addEventListener('click', event => {
      const removeButton = event.target.closest('[data-account-line-remove]');
      if (removeButton) removeButton.closest('.accounting-entry-line')?.remove();
    });
    linesContainer.addEventListener('input', event => {
      const amountInput = event.target.closest('input[name^="line_debit_"], input[name^="line_credit_"]');
      if (!amountInput || Number(amountInput.value) <= 0) return;
      const otherSide = amountInput.name.startsWith('line_debit_') ? 'credit' : 'debit';
      const otherInput = amountInput.closest('.accounting-entry-line').querySelector(`input[name^="line_${otherSide}_"]`);
      if (otherInput) otherInput.value = '0';
    });
    modal.querySelector('.modal-cancel').addEventListener('click', () => modal.remove());
    const saveDraftButton = modal.querySelector('#accounting-entry-save-draft');
    saveDraftButton.addEventListener('click', async () => {
      saveDraftButton.disabled = true;
      try {
        const url = `../backend/public/report-data.php?action=accounting-draft${draftId ? `&ecriture_id=${encodeURIComponent(draftId)}` : ''}`;
        const response = await fetch(url, {method: draftId ? 'PUT' : 'POST', headers: {'Content-Type': 'application/json'}, credentials: 'include', body: JSON.stringify(accountingEntryPayload(form))});
        const result = await readJson(response);
        if (!response.ok || !result.success) throw new Error(result.message || 'Enregistrement du brouillon impossible.');
        modal.remove();
        await loadAccountingDrafts();
        showToast('Brouillon comptable enregistré.');
      } catch (error) {
        showToast(error.message);
      } finally {
        if (saveDraftButton.isConnected) saveDraftButton.disabled = false;
      }
    });
    form.addEventListener('submit', async event => {
      event.preventDefault();
      const submitButton = form.querySelector('.modal-submit');
      submitButton.disabled = true;
      try {
        const payload = accountingEntryPayload(form);
        if (payload.lines.length < 2) {
          showToast('Ajoutez au moins deux lignes à l’écriture comptable.');
          return;
        }
        if (payload.lines.some(line => !Number.isFinite(line.debit) || !Number.isFinite(line.credit) || line.debit < 0 || line.credit < 0 || (line.debit > 0 && line.credit > 0) || (line.debit === 0 && line.credit === 0))) {
          showToast('Chaque ligne doit porter un montant au débit ou au crédit, jamais les deux.');
          return;
        }
        const debitTotal = payload.lines.reduce((total, line) => total + line.debit, 0);
        const creditTotal = payload.lines.reduce((total, line) => total + line.credit, 0);
        if (debitTotal <= 0 || Math.abs(debitTotal - creditTotal) > 0.009) {
          showToast(`Écriture non équilibrée. Débit : ${moneyCurrencyLabel(debitTotal, payload.monnaie)} · Crédit : ${moneyCurrencyLabel(creditTotal, payload.monnaie)}.`);
          return;
        }
        if (draftId) {
          const updateResponse = await fetch(`../backend/public/report-data.php?action=accounting-draft&ecriture_id=${encodeURIComponent(draftId)}`, {method: 'PUT', headers: {'Content-Type': 'application/json'}, credentials: 'include', body: JSON.stringify(payload)});
          const updateResult = await readJson(updateResponse);
          if (!updateResponse.ok || !updateResult.success) throw new Error(updateResult.message || 'Mise à jour du brouillon impossible.');
          const response = await fetch('../backend/public/report-data.php?action=accounting-draft-validate', {method: 'POST', headers: {'Content-Type': 'application/json'}, credentials: 'include', body: JSON.stringify({ecriture_id: draftId})});
          const result = await readJson(response);
          if (!response.ok || !result.success) throw new Error(result.message || 'Validation du brouillon impossible.');
        } else {
          const response = await fetch('../backend/public/report-data.php?action=accounting-entry', {method: 'POST', headers: {'Content-Type': 'application/json'}, credentials: 'include', body: JSON.stringify(payload)});
          const result = await readJson(response);
          if (!response.ok || !result.success) throw new Error(result.message || 'Validation de l’écriture impossible.');
        }
        modal.remove();
        await Promise.all([loadAccountingEntryRows(), loadAccountingDrafts(), loadAccountingReport()]);
        showToast(draftId ? 'Brouillon comptable validé.' : 'Écriture comptable enregistrée.');
      } catch (error) {
        showToast(error.message);
      } finally {
        if (submitButton.isConnected) submitButton.disabled = false;
      }
    });
  } catch (error) {
    showToast(error.message);
  }
}
async function openPaymentEntry({title,amount,currency,branchId,referenceTitle,submit,isInbound=false}){
  try{
    const [modesResponse,banksResponse,exchangeResponse]=await Promise.all([
      fetch('../backend/public/auth.php?action=payment-modes',{credentials:'include'}),
      fetch('../backend/public/auth.php?action=banks',{credentials:'include'}),
      isInbound?fetch('../backend/public/auth.php?action=exchange-rates',{credentials:'include',cache:'no-store'}):Promise.resolve(null)
    ]);
    const modesResult=await readJson(modesResponse),banksResult=await readJson(banksResponse);
    if(!modesResponse.ok||!modesResult.success)throw new Error(modesResult.message||'Chargement des modes impossible.');
    if(!banksResponse.ok||!banksResult.success)throw new Error(banksResult.message||'Chargement des banques impossible.');
    const modes=(modesResult.data||[]).sort((a,b)=>Number(String(b.code).toUpperCase()==='CASH')-Number(String(a.code).toUpperCase()==='CASH')),banks=banksResult.data||[];
    if(!modes.length)throw new Error('Aucun mode de paiement actif.');
    let exchangeData={reference_currency:null,currencies:[],rates:[]};
    if(exchangeResponse){const exchangeResult=await readJson(exchangeResponse);if(!exchangeResponse.ok||!exchangeResult.success)throw new Error(exchangeResult.message||'Chargement des taux de change impossible.');exchangeData=exchangeResult.data;}
    const rates=new Map((exchangeData.rates||[]).map(rate=>[rate.monais,Number(rate.taux_vers_reference)]));
    let paymentCurrencies=[currency];
    if(isInbound){
      paymentCurrencies=[...new Set([currency,...(exchangeData.currencies||[]).map(item=>item.type_monais).filter(code=>code===currency||(rates.has(currency)&&rates.has(code)))])];
    }
    let cashboxes=[],page=1,totalPages=1;while(page<=totalPages){const result=await fetchReportPage('cashboxes-list',page);cashboxes.push(...result.rows);totalPages=result.pagination.pages;page++;}
    cashboxes=cashboxes.filter(row=>row.statut==='OUVERTE'&&Number(row.succursale_id)===Number(branchId)).sort((a,b)=>String(a.name).localeCompare(String(b.name),'fr'));
    const currencyOptions=isInbound?`<label class="full">Monnaie reçue<select name="received_monais" required>${paymentCurrencies.map(code=>`<option value="${escapeHtml(code)}"${code===currency?' selected':''}>${escapeHtml(code)}</option>`).join('')}</select></label>`:'';
    const modal=document.createElement('div');modal.className='entity-modal';modal.innerHTML=`<section class="entity-dialog"><h2>${escapeHtml(title)}</h2><p class="panel-subtitle">${escapeHtml(referenceTitle||'')} · À régler : ${moneyCurrencyLabel(amount,currency)}</p><form class="entity-form">${currencyOptions}<label class="full">Mode de paiement<select name="mode_paiement_id" required>${modes.map(mode=>`<option value="${Number(mode.mode_paiement_id)}" data-mode-code="${escapeHtml(mode.code)}" data-requires-cash="${Number(mode.requires_cash)}">${escapeHtml(mode.name)}</option>`).join('')}</select></label><label class="full" data-payment-cash-label>Caisse ou compte de paiement<select name="caisse_id" required></select><small data-no-cashboxes hidden>Aucun compte ouvert ne correspond à ce mode et à cette monnaie.</small><small data-insufficient-funds hidden>Solde insuffisant pour ce montant.</small></label><label class="full" data-payment-bank-label>Banque<select name="banque_id">${banks.map(bank=>`<option value="${Number(bank.banque_id)}">${escapeHtml(bank.name)}${bank.account_number?` · ${escapeHtml(bank.account_number)}`:''}</option>`).join('')}</select><small data-no-banks ${banks.length?'hidden':''}>Créez d’abord une banque dans le module Caisse.</small></label><label class="full" data-payment-reference-label>Référence de transaction<input name="reference" maxlength="120" placeholder="N° transaction Mobile Money ou référence bancaire"></label><label class="full">Montant du paiement<input name="amount" type="number" min="0.01" max="${Number(amount)}" step="0.01" value="${Number(amount)}" required></label><div class="full"><strong data-payment-amount-summary>Reste à payer : ${moneyCurrencyLabel(amount,currency)}</strong></div><div class="entity-modal-actions full"><button type="button" class="modal-cancel">Annuler</button><button class="modal-submit">Enregistrer le paiement</button></div></form></section>`;document.body.appendChild(modal);
    const form=modal.querySelector('form'),modeSelect=form.elements.namedItem('mode_paiement_id'),cashLabel=modal.querySelector('[data-payment-cash-label]'),cashSelect=form.elements.namedItem('caisse_id'),bankLabel=modal.querySelector('[data-payment-bank-label]'),bankSelect=form.elements.namedItem('banque_id'),refLabel=modal.querySelector('[data-payment-reference-label]'),refInput=form.elements.namedItem('reference'),amountInput=form.elements.namedItem('amount'),submitButton=form.querySelector('.modal-submit'),receivedCurrencySelect=form.elements.namedItem('received_monais');
    const amountLabel=amountInput.closest('label');amountLabel.firstChild.textContent=isInbound?'Montant reçu':'Montant versé';
    const rateFor=code=>code===exchangeData.reference_currency?1:rates.get(code);
    const multiplier=()=>{
      const received=receivedCurrencySelect?.value||currency;
      if(received===currency)return 1;
      const receivedRate=rateFor(received),invoiceRate=rateFor(currency);
      if(!Number.isFinite(receivedRate)||!Number.isFinite(invoiceRate)||receivedRate<=0||invoiceRate<=0)return null;
      return receivedRate/invoiceRate;
    };
    const maxReceived=()=>{const appliedRate=multiplier();return appliedRate?Number(amount)/appliedRate:0;};
    const summary=modal.querySelector('[data-payment-amount-summary]');
    const syncMode=()=>{
      const receivedCurrency=receivedCurrencySelect?.value||currency;
      const selected=modeSelect.selectedOptions[0],requiresCash=selected?.dataset.requiresCash==='1',isBank=selected?.dataset.modeCode==='BANK',modeId=Number(modeSelect.value);
      const available=cashboxes.filter(row=>row.monais===receivedCurrency&&Number(row.mode_paiement_id)===modeId);
      cashSelect.innerHTML=available.map(row=>`<option value="${Number(row.caisse_id)}" data-bank-id="${Number(row.banque_id||0)}" data-balance="${Number(row.solde_courant||0)}">${escapeHtml(row.name)} · ${escapeHtml(row.payment_mode)} · Disponible ${moneyCurrencyLabel(row.solde_courant,row.monais)}</option>`).join('');
      cashLabel.hidden=false;cashSelect.required=true;modal.querySelector('[data-no-cashboxes]').hidden=available.length>0;
      const linkedBank=cashSelect.selectedOptions[0]?.dataset.bankId||'';if(linkedBank)bankSelect.value=linkedBank;
      bankLabel.hidden=!isBank;bankSelect.required=isBank;bankSelect.disabled=!isBank||Boolean(linkedBank);modal.querySelector('[data-no-banks]').hidden=banks.length>0;
      refLabel.hidden=requiresCash;refInput.required=!requiresCash;
      const appliedRate=multiplier();
      const maxAmount=maxReceived();amountInput.max=String(maxAmount);const applied=Number(amountInput.value||0)*(appliedRate||0);
      const inverseRate=appliedRate&&appliedRate>0?1/appliedRate:0;
      summary.textContent=isInbound
        ? appliedRate===null?'Taux indisponible : vérifiez les taux configurés pour ces monnaies.'
          : `Imputé à la facture : ${moneyCurrencyLabel(applied,currency)} · Solde : ${moneyCurrencyLabel(amount,currency)}${receivedCurrency!==currency?` · Taux : 1 ${receivedCurrency} = ${appliedRate.toLocaleString('fr-FR',{maximumFractionDigits:8})} ${currency} · Inverse : ${inverseRate.toLocaleString('fr-FR',{maximumFractionDigits:8})} ${receivedCurrency} = 1 ${currency}`:''}`
        : `Reste à payer : ${moneyCurrencyLabel(amount,currency)}`;
      const insufficient=!isInbound&&available.length>0&&Number(amountInput.value)>Number(cashSelect.selectedOptions[0]?.dataset.balance||0)+0.009;
      modal.querySelector('[data-insufficient-funds]').hidden=!insufficient;
      submitButton.disabled=!available.length||(isBank&&!banks.length)||insufficient||appliedRate===null||Number(amountInput.value)>maxAmount+0.009;
    };
    if(isInbound){const max=maxReceived();amountInput.value=max.toFixed(2);amountInput.max=String(max);}
    const setFullAmount=()=>{amountInput.value=maxReceived().toFixed(2);syncMode();};
    const fullAmountButton=document.createElement('button');fullAmountButton.type='button';fullAmountButton.className='text-button';fullAmountButton.textContent='Payer le solde complet';amountLabel.before(fullAmountButton);fullAmountButton.addEventListener('click',setFullAmount);
    modeSelect.addEventListener('change',syncMode);cashSelect.addEventListener('change',syncMode);amountInput.addEventListener('input',syncMode);receivedCurrencySelect?.addEventListener('change',setFullAmount);
    syncMode();modal.querySelector('.modal-cancel').addEventListener('click',()=>modal.remove());
    form.addEventListener('submit',async event=>{event.preventDefault();const payload=Object.fromEntries(new FormData(form));payload.mode_paiement_id=Number(payload.mode_paiement_id);payload.caisse_id=payload.caisse_id?Number(payload.caisse_id):null;payload.banque_id=Number(cashSelect.selectedOptions[0]?.dataset.bankId||payload.banque_id||0)||null;payload.amount=Number(payload.amount);try{await submit(payload);modal.remove();}catch(error){showToast(error.message);}});
  }catch(error){showToast(error.message);}
}
async function openSupplierPayment(button){const amount=Number(button.dataset.supplierDue),currency=button.dataset.supplierCurrency;await openPaymentEntry({title:'Paiement fournisseur',amount,currency,branchId:Number(button.dataset.supplierBranch),referenceTitle:`Approvisionnement ${button.dataset.supplierRef}`,submit:async payload=>{payload.achat_id=Number(button.dataset.supplierPayment);const response=await fetch('../backend/public/auth.php?action=pay-supplier',{method:'POST',headers:{'Content-Type':'application/json'},credentials:'include',body:JSON.stringify(payload)});const result=await readJson(response);if(!response.ok||!result.success)throw new Error(result.message||'Paiement impossible.');showToast('Paiement fournisseur enregistré.');loadAccountingData();if(currentViewName==='cash')loadCashRows();}});}
async function loadBranchDashboard() {
  const target = document.getElementById('branch-product-count'); if (!target) return;
  try {
    const summary = await fetchStockSummary(sessionUser?.succursale_id);
    target.textContent = Number(summary.products_count).toLocaleString('fr-FR');
    setQuantitySummary(document.getElementById('branch-quantity'), summary.branches);
    document.getElementById('branch-alerts').textContent = Number(summary.low_stock_count).toLocaleString('fr-FR');
  } catch (error) { target.textContent = error.message; }
}
async function loadExpiringStock() {
  const anchor = document.getElementById('dash-low-stock')?.closest('.panel') || document.getElementById('stock-rows')?.closest('.panel') || document.getElementById('branch-product-count')?.closest('.dashboard-grid');
  if (!anchor) return;
  try {
    const lots = await fetchReportData('expiring-stock', {jours:'30'});
    let panel = document.getElementById('expiring-stock-panel');
    if (!panel) {
      panel = document.createElement('section');
      panel.className = 'panel';
      panel.id = 'expiring-stock-panel';
      panel.innerHTML = '<div class="panel-header"><div><h2>Produits à surveiller avant expiration</h2><p class="panel-subtitle">Lots périmés ou arrivant à expiration dans les 30 jours</p></div></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Produit</th><th>Succursale</th><th>Lot d’entrée</th><th>Date d’expiration</th><th>Quantité restante</th><th>État</th></tr></thead><tbody id="expiring-stock-rows"></tbody></table></div>';
      anchor.before(panel);
    }
    const rows = document.getElementById('expiring-stock-rows');
    rows.innerHTML = lots.length ? lots.map(lot => {
      const expired = Number(lot.days_remaining) < 0;
      const today = Number(lot.days_remaining) === 0;
      const state = expired ? 'Expiré' : today ? 'Expire aujourd’hui' : `Dans ${Number(lot.days_remaining)} jour${Number(lot.days_remaining) === 1 ? '' : 's'}`;
      const unit = lot.unit_symbol || lot.unit_name || '';
      return `<tr class="${expired || today ? 'expiration-urgent' : 'expiration-soon'}"><td>${escapeHtml(lot.product_name)} (${escapeHtml(lot.sku)})</td><td>${escapeHtml(lot.branch_name)}</td><td>${escapeHtml(lot.purchase_no)}</td><td>${escapeHtml(lot.date_expiration)}</td><td>${Number(lot.remaining_quantity).toLocaleString('fr-FR')} ${escapeHtml(unit)}</td><td><span class="status ${expired || today ? 'danger' : 'warning'}">${escapeHtml(state)}</span></td></tr>`;
    }).join('') : '<tr><td colspan="6">Aucun lot n’expire dans les 30 prochains jours.</td></tr>';
  } catch (error) {
    const panel = document.getElementById('expiring-stock-panel');
    if (panel) panel.querySelector('tbody').innerHTML = `<tr><td colspan="6">${escapeHtml(error.message)}</td></tr>`;
  }
}
async function loadSession() {
  try {
    const response = await fetch('../backend/public/auth.php?action=me', {credentials:'include'});
    const result = await readJson(response);
    if (response.status === 401 || (response.ok && result.success && !result.data)) { window.location.replace('login.html'); return; }
    if (!response.ok || !result.success || !result.data) throw new Error(result.message || 'Le profil de session n’a pas pu être chargé.');
    const user = result.data;
    if (user.type === 'super_admin') { window.location.replace('superadmin.html'); return; }
    sessionUser = user;
    const name = user.full_name || user.email || 'Utilisateur';
    const initials = name.trim().split(/\s+/).slice(0, 2).map(part => part[0]).join('').toLocaleUpperCase();
    document.querySelectorAll('[data-session-name]').forEach(node => node.textContent = name);
    document.querySelectorAll('[data-session-role]').forEach(node => node.textContent = user.role_name || 'Utilisateur');
    document.querySelectorAll('[data-session-enterprise]').forEach(node => node.textContent = user.enterprise_name || 'Entreprise inconnue');
    document.querySelectorAll('[data-session-branch]').forEach(node => node.textContent = user.branch_name || 'Entreprise mère');
    document.querySelectorAll('[data-context-company]').forEach(node => node.textContent = user.enterprise_name || 'Entreprise inconnue');
    document.querySelectorAll('[data-context-branch]').forEach(node => node.textContent = user.branch_name || 'Entreprise mère');
    document.querySelectorAll('[data-session-avatar]').forEach(node => node.textContent = initials || '—');
    document.querySelectorAll('[data-enterprise-name]').forEach(node => node.textContent = user.enterprise_name || 'Gestion de stock');
    document.querySelectorAll('[data-settings-company]').forEach(node => node.textContent = user.enterprise_name || '—');
    document.querySelectorAll('[data-settings-user]').forEach(node => node.textContent = name);
    document.querySelectorAll('[data-settings-role]').forEach(node => node.textContent = user.role_name || 'Utilisateur');
    applyMenuAccess(user);
    await configureCompanyScope(user);
    navigate(routeFromHash(), true);
  } catch (error) { showToast(`Problème de session : ${error.message}`); }
}
async function configureCompanyScope(user) {
  const control = document.getElementById('company-scope-control');
  const select = document.getElementById('company-scope');
  if (!control || !select) return;
  if (!canSelectCompanyBranches(user)) {
    branchOptions = user.succursale_id ? [{succursale_id:user.succursale_id, name:user.branch_name || 'Ma succursale'}] : [];
    control.hidden = true;
    return;
  }
  try {
    branchOptions = await apiGet('succursales');
    control.hidden = branchOptions.length < 2;
    select.innerHTML = '<option value="">Toute l’entreprise</option>' + branchOptions.map(branch => `<option value="${Number(branch.succursale_id)}">${escapeHtml(branch.name)}</option>`).join('');
    select.value = activeBranchId;
    select.onchange = () => {
      activeBranchId = select.value;
      navigate(currentViewName, true);
    };
  } catch (error) {
    control.hidden = true;
    console.error('Chargement des succursales impossible.', error);
  }
}
async function loadStock(page = 1) {
  const rows = document.getElementById('stock-rows'); if (!rows) return;
  try {
    const isBranchScoped = !canSelectCompanyBranches();
    const [stockPage, categoryPage, units, summary] = await Promise.all([apiGetPage('stocks', page), apiGetPage('categories', 1), apiGet('unites_mesure'), fetchStockSummary()]);
    const categories = categoryPage.rows;
    const products = [...new Map(stockPage.rows.map(row => [Number(row.produit_id), row])).values()];
    stockData = {products, stocks:stockPage.rows, categories, branches:branchOptions, units, summary:summary.branches};
    renderCategoryRows();
    const branchSelect = document.getElementById('stock-branch');
    branchSelect.hidden = true;
    branchSelect.innerHTML = '<option value="">Toutes les succursales</option>' + branchOptions.map(branch => `<option value="${Number(branch.succursale_id)}">${escapeHtml(branch.name)}</option>`).join('');
    branchSelect.value = activeBranchId || (isBranchScoped ? String(sessionUser.succursale_id) : '');
    document.getElementById('stock-search').oninput = renderStockRows;
    renderBranchStockSummary();
    renderStockRows();
    showPagination(rows, 'stock-products', stockPage.pagination, loadStock);
    showPagination(document.getElementById('category-rows'), 'stock-categories', categoryPage.pagination, loadCategoryRows);
  } catch (error) { rows.innerHTML = `<tr><td colspan="9">${escapeHtml(error.message)}</td></tr>`; }
}
function renderBranchStockSummary() {
  const stockPanel = document.getElementById('stock-rows')?.closest('.panel');
  if (!stockPanel || !branchOptions.length) return;
  let summary = document.getElementById('stock-company-summary');
  if (!summary) {
    summary = document.createElement('section');
    summary.className = 'panel';
    summary.id = 'stock-company-summary';
    summary.innerHTML = '<div class="panel-header"><div><h2>Stock consolidé</h2><p class="panel-subtitle">Total général et répartition actuelle par succursale</p></div></div><div class="dashboard-grid"><article class="stat-card"><span class="stat-label">Stock général</span><div class="stat-value" id="company-stock-total">0</div></article><article class="stat-card"><span class="stat-label">Succursales</span><div class="stat-value" id="company-stock-branch-count">0</div></article></div><div style="overflow:auto"><table class="data-table"><thead><tr><th>Succursale</th><th>Quantité totale</th><th>Alertes de seuil</th></tr></thead><tbody id="company-stock-branches"></tbody></table></div>';
    stockPanel.before(summary);
  }
  const totals = new Map(branchOptions.map(branch => [Number(branch.succursale_id), {name:branch.name, quantities:new Map(), alerts:0}]));
  const grandTotal = new Map();
  for (const stock of stockData.summary) {
    const branch = totals.get(Number(stock.succursale_id));
    if (!branch) continue;
    const unit = stock.unit_abbreviation || stock.unit_name;
    addUnitQuantity(branch.quantities, unit, stock.quantity);
    addUnitQuantity(grandTotal, unit, stock.quantity);
    branch.alerts += Number(stock.alerts || 0);
  }
  const grandTotalElement = document.getElementById('company-stock-total');
  grandTotalElement.textContent = unitTotalsLabel(grandTotal);
  grandTotalElement.classList.add('quantity-by-unit');
  document.getElementById('company-stock-branch-count').textContent = totals.size.toLocaleString('fr-FR');
  document.getElementById('company-stock-branches').innerHTML = [...totals].map(([branchId, branch]) => `<tr${String(branchId) === activeBranchId ? ' class="selected-branch-row"' : ''}><td>${escapeHtml(branch.name)}</td><td>${escapeHtml(unitTotalsLabel(branch.quantities))}</td><td>${branch.alerts.toLocaleString('fr-FR')}</td></tr>`).join('') || '<tr><td colspan="3">Aucune succursale enregistrée.</td></tr>';
}
function renderStockRows() {
  const rows = document.getElementById('stock-rows'); if (!rows) return;
  const branchId = document.getElementById('stock-branch').value;
  const search = document.getElementById('stock-search').value.trim().toLocaleLowerCase();
  const unitNames = Object.fromEntries((stockData.units || []).map(unit => [unit.unite_mesure_id, unit.symbole || unit.name]));
  const stocks = stockData.stocks.filter(stock => !branchId || stock.stock_id === null || Number(stock.succursale_id) === Number(branchId));
  const products = stockData.products.filter(product => Number(product.is_active ?? 1) === 1 && `${product.name} ${product.sku}`.toLocaleLowerCase().includes(search));
  document.getElementById('stock-count').textContent = `${products.length} produit${products.length > 1 ? 's' : ''} référencé${products.length > 1 ? 's' : ''}`;
  if (!products.length) { rows.innerHTML = '<tr><td colspan="9">Aucun produit. Utilisez Â« Créer un produit Â» pour commencer.</td></tr>'; return; }
  rows.innerHTML = products.map(product => {
    const productStocks = stocks.filter(stock => Number(stock.produit_id) === Number(product.produit_id));
    const quantity = productStocks.reduce((sum, stock) => sum + Number(stock.quantity || 0), 0);
    const threshold = productStocks.reduce((sum, stock) => sum + Number(stock.min_stock_level || 0), 0);
    const status = quantity === 0 ? ['Rupture','danger'] : quantity <= threshold ? ['Stock bas','warning'] : ['En stock','success'];
    const cardButton = hasAccess('voir_stock') ? `<button class="text-button" data-stock-card="${Number(product.produit_id)}">Afficher fiche de stock</button>` : '';
    const adjustButton = hasAccess('modifier_stock') ? `<button class="text-button" data-stock-edit="${Number(product.produit_id)}">Ajuster</button>` : '';
    const editButton = hasAccess('modifier_produit') ? `<button class="text-button" data-product-edit="${Number(product.produit_id)}">Modifier</button>` : '';
    const deleteButton = hasAccess('supprimer_produit') ? `<button class="text-button" data-product-delete="${Number(product.produit_id)}">Supprimer</button>` : '';
    const unit = unitNames[product.unite_de_mesure] || product.unit_abbreviation || product.unit_name || '';
    return `<tr><td>${escapeHtml(product.sku)}</td><td>${escapeHtml(product.name)}</td><td>${escapeHtml(product.category_name || '—')}</td><td>${Number(product.unit_price || 0).toFixed(2)} ${escapeHtml(product.monais || '')}</td><td>${escapeHtml(unit)}</td><td>${quantity.toLocaleString('fr-FR')} ${escapeHtml(unit)}</td><td>${threshold.toLocaleString('fr-FR')} ${escapeHtml(unit)}</td><td><span class="status ${status[1]}">${status[0]}</span></td><td>${cardButton} ${adjustButton} ${editButton} ${deleteButton}</td></tr>`;
  }).join('');
  renderCategoryRows();
}
function renderCategoryRows() {
  const body = document.getElementById('category-rows');
  if (!body) return;
  body.innerHTML = stockData.categories.length ? stockData.categories.map(category => `<tr><td>${escapeHtml(category.name)}</td><td>${escapeHtml(category.description || '—')}</td><td>${hasAccess('modifier_stock') ? `<button class="text-button" data-category-edit="${Number(category.category_id)}">Modifier</button> <button class="text-button" data-category-delete="${Number(category.category_id)}">Supprimer</button>` : '—'}</td></tr>`).join('') : '<tr><td colspan="3">Aucune catégorie enregistrée.</td></tr>';
}
async function loadCategoryRows(page = 1) {
  try {
    const result = await apiGetPage('categories', page);
    stockData.categories = result.rows;
    renderCategoryRows();
    showPagination(document.getElementById('category-rows'), 'stock-categories', result.pagination, loadCategoryRows);
  } catch (error) { showLoadError('category-rows', error, 3); }
}
function openUnitManager() {
  if (!sessionUser?.is_company_admin) return;
  unitManagerModal?.remove();
  const modal = document.createElement('div');
  unitManagerModal = modal;
  modal.className = 'entity-modal';
  modal.innerHTML = `<section class="entity-dialog unit-manager-dialog"><div class="unit-manager-heading"><div><span class="kicker">ADMINISTRATION ENTREPRISE</span><h2>Unités de mesure</h2><p>Gérez les unités proposées lors de la création des produits.</p></div><button type="button" class="modal-cancel" data-unit-manager-close aria-label="Fermer">×</button></div><div class="unit-manager-actions"><span>Unités enregistrées pour votre entreprise</span><button type="button" class="primary-button" data-unit-create><span aria-hidden="true">+</span> Ajouter une unité</button></div><div class="unit-manager-table-wrap"><table class="data-table"><thead><tr><th>Unité de mesure</th><th>Symbole</th><th>Actions</th></tr></thead><tbody data-unit-rows><tr><td colspan="3">Chargement…</td></tr></tbody></table></div><p class="unit-manager-note">Une unité utilisée par un produit doit être réaffectée avant sa suppression.</p></section>`;
  document.body.appendChild(modal);
  const render = async () => {
    const rows = modal.querySelector('[data-unit-rows]');
    if (!rows || !modal.isConnected) return;
    rows.innerHTML = '<tr><td colspan="3">Chargement…</td></tr>';
    try {
      const units = await apiGet('unites_mesure');
      if (!modal.isConnected) return;
      rows.innerHTML = units.length ? units.map(unit => `<tr><td>${escapeHtml(unit.name)}</td><td><span class="unit-symbol-badge">${escapeHtml(unit.symbole || '—')}</span></td><td><div class="user-action-group"><button type="button" class="user-action-button user-action-edit" data-unit-edit="${Number(unit.unite_mesure_id)}"><span aria-hidden="true">✎</span> Modifier</button><button type="button" class="user-action-button user-action-delete" data-unit-delete="${Number(unit.unite_mesure_id)}"><span aria-hidden="true">×</span> Supprimer</button></div></td></tr>`).join('') : '<tr><td colspan="3">Aucune unité enregistrée.</td></tr>';
    } catch (error) {
      rows.innerHTML = `<tr><td colspan="3">${escapeHtml(error.message)}</td></tr>`;
    }
  };
  refreshUnitManager = render;
  modal.querySelector('[data-unit-manager-close]').addEventListener('click', () => {
    modal.remove();
    if (unitManagerModal === modal) { unitManagerModal = null; refreshUnitManager = null; }
  });
  modal.addEventListener('click', event => {
    if (event.target === modal) modal.querySelector('[data-unit-manager-close]').click();
  });
  modal.querySelector('[data-unit-create]').addEventListener('click', () => openEntityForm('unit'));
  render();
}
function openEntityForm(type, entity = null) {
  const definitions = {
    product: {title: 'Créer un produit', endpoint: '../backend/public/api.php?resource=produits', fields: '<label>Référence du produit<input name="sku" required></label><label>Nom du produit<input name="name" required></label><label>Catégorie<select name="category_id" id="product-category"><option value="">Sans catégorie</option></select></label><label>Prix de vente<input name="unit_price" type="number" min="0" step="0.01" required></label><label>Prix d’achat<input name="cost_price" type="number" min="0" step="0.01" value="0" required></label><label>Seuil d’alerte du stock<input name="min_stock_level" type="number" min="0" step="1" value="5" required><small>Une alerte s’affiche lorsque le stock atteint ce niveau.</small></label><label>Unit&eacute; de mesure<select name="unite_de_mesure" id="product-unit" required><option value="">Chargement...</option></select></label><label>Monnaie du prix<select name="monais" id="product-currency" required><option value="">Chargement des monnaies…</option></select></label><label><span>Produit périssable</span><input name="est_perisable" type="checkbox" value="1" id="perishable-field"></label><label class="full">Description<textarea name="description"></textarea></label>'},
    unit: {title: 'Enregistrer une unit&eacute; de mesure', endpoint: '../backend/public/api.php?resource=unites_mesure', fields: '<label>Unit&eacute; de mesure<input name="name" required maxlength="50" placeholder="Ex. Kilogramme"></label><label>Symbole<input name="symbole" required maxlength="15" placeholder="Ex. kg"></label>'},
    branch: {title:'Créer une succursale', endpoint:'../backend/public/api.php?resource=succursales', fields:'<label>Nom de la succursale<input name="name" required maxlength="100"></label><label>Code unique<input name="code" required maxlength="20" placeholder="Ex. MAG-01"></label><label class="full"><span>Définir comme succursale mère</span><input name="est_sucursal_mere" type="checkbox" value="1"></label><label class="full">Adresse<textarea name="address"></textarea></label><label>Téléphone<input name="phone" maxlength="20"></label>'},
    supplier: {title:'Créer un fournisseur', endpoint:'../backend/public/api.php?resource=fournisseurs', fields:'<label>Nom du fournisseur<input name="name" required maxlength="100"></label><label>Personne de contact<input name="contact_name" maxlength="100"></label><label>Adresse électronique<input name="email" type="email" maxlength="100"></label><label>Téléphone<input name="phone" maxlength="20"></label><label class="full">Adresse<textarea name="address"></textarea></label>'},
    user: {title: 'Créer un utilisateur', endpoint: '../backend/public/auth.php?action=create-user', fields: '<label>Nom complet<input name="full_name" required></label><label>Nom d’utilisateur<input name="username" required></label><label>Adresse électronique<input name="email" type="email" required></label><label>Mot de passe<input name="password" type="password" minlength="8"></label><label>Rôle d’accès<select name="role_id" id="user-role" required><option value="">Chargement des rôles…</option></select></label><label>Succursale (facultatif)<select name="succursale_id" id="user-branch"><option value="">Entreprise mère (sans succursale)</option></select></label><label class="full"><span>Compte actif</span><input name="is_active" type="checkbox" value="1" checked></label>'},
    role: {title: 'Créer un rôle', endpoint: '../backend/public/auth.php?action=create-role', fields: '<label>Nom du rôle<input name="role_name" placeholder="Ex. Responsable stock" required></label><label class="full">Description<textarea name="description"></textarea></label><fieldset class="full" style="border:1px solid #e6ebe7;border-radius:7px;padding:12px"><legend>Droits d’accès</legend><label><input type="checkbox" name="permissions" value="vente"> Accès aux ventes</label><label><input type="checkbox" name="permissions" value="caisse"> Accès à la caisse</label><label><input type="checkbox" name="permissions" value="stock"> Accès au stock et aux produits</label><label><input type="checkbox" name="permissions" value="approvisionnement"> Accès aux approvisionnements</label><label><input type="checkbox" name="permissions" value="clients"> Gestion des clients</label><label><input type="checkbox" name="permissions" value="comptabilite"> Accès à la comptabilité</label></fieldset>'},
    category: {title: 'Créer une catégorie', endpoint: '../backend/public/api.php?resource=categories', fields: '<label>Nom de la catégorie<input name="name" required maxlength="100"></label><label class="full">Description<textarea name="description"></textarea></label>'},
    purchase: {title: 'Créer un approvisionnement', endpoint: '../backend/public/auth.php?action=create-purchase', fields: '<label>Référence<input name="purchase_no" required></label><label>Opération<select name="movement_type" id="purchase-operation"><option value="IN">Entrée — augmenter le stock</option><option value="OUT">Sortie — diminuer le stock</option></select></label><div id="purchase-supplier-fields" class="full"><label>Rechercher un fournisseur<input type="search" id="purchase-supplier-search" placeholder="Nom ou contact"></label><label>Fournisseur<select name="fournisseur_id" id="purchase-supplier" required><option value="">Chargement…</option></select></label><button type="button" class="text-button full" id="purchase-add-supplier">+ Créer un fournisseur</button><div class="full" id="purchase-new-supplier" hidden><label>Nom du fournisseur<input id="new-supplier-name" maxlength="100"></label><label>Personne de contact<input id="new-supplier-contact" maxlength="100"></label><label>Adresse électronique<input id="new-supplier-email" type="email" maxlength="100"></label><label>Téléphone<input id="new-supplier-phone" maxlength="20"></label><label class="full">Adresse<textarea id="new-supplier-address"></textarea></label><button type="button" class="modal-submit" id="purchase-save-supplier">Enregistrer le fournisseur</button></div></div><label id="purchase-reason-field" hidden class="full">Motif de sortie<input name="motif_sortie" maxlength="255" placeholder="Ex. Vente, casse, transfert..."></label><label>Rechercher un produit<input type="search" id="purchase-product-search" placeholder="Nom ou référence du produit"></label><label>Produit<select name="produit_id" id="purchase-product" required><option value="">Chargement…</option></select></label><label>Quantité<input name="quantity" type="number" min="1" step="1" required></label><label id="purchase-cost-choice" class="full"><input type="checkbox" id="purchase-use-product-cost" name="use_product_cost" checked> Utiliser le cout enregistre dans la fiche du produit</label><label id="purchase-custom-cost-field" hidden>Autre cout unitaire<input name="unit_cost" type="number" min="0" step="0.01" value="0"></label><label>Traitement<select name="status"><option value="PENDING" selected>En attente — aucun mouvement de stock</option><option value="RECEIVED">Valider et appliquer au stock</option><option value="CANCELLED">Annuler sans mouvement</option></select></label>'}
  };
  const definition = definitions[type];
  if (!definition) return;
  const modalHint = type === 'product'
    ? 'Le produit est ajouté au catalogue de toute l’entreprise. Les quantités de stock se gèrent ensuite par succursale.'
    : 'Les données seront enregistrées dans votre entreprise selon vos droits d’accès.';
  const modal = document.createElement('div');
  modal.className = 'entity-modal';
  const entityTitle = type === 'unit' && entity ? 'Modifier une unit&eacute; de mesure' : (entity ? definition.title.replace('Créer', 'Modifier') : definition.title);
  modal.innerHTML = `<section class="entity-dialog"><h2>${entityTitle}</h2><p>${modalHint}</p><form class="entity-form">${definition.fields}<div class="entity-modal-actions full"><button type="button" class="modal-cancel">Annuler</button><button class="modal-submit">${entity ? 'Enregistrer les modifications' : 'Enregistrer'}</button></div></form></section>`;
  if (type === 'purchase') {
    modal.querySelector('#purchase-add-supplier')?.remove();
    modal.querySelector('#purchase-new-supplier')?.remove();
  }
  document.body.appendChild(modal);
  const form = modal.querySelector('form');
  const formMessage = document.createElement('div');
  formMessage.className = 'entity-form-message full';
  formMessage.setAttribute('role', 'alert');
  formMessage.setAttribute('aria-live', 'assertive');
  formMessage.hidden = true;
  form.insertBefore(formMessage, form.firstChild);
  const showFormError = message => {
    formMessage.textContent = message;
    formMessage.hidden = false;
    formMessage.scrollIntoView({block:'nearest', behavior:'smooth'});
  };
  form.addEventListener('input', () => { formMessage.hidden = true; });
  form.addEventListener('change', () => { formMessage.hidden = true; });
  let selectedPerishableProduct = null;
  if (type === 'role') {
    const legacyClientLabel = form.querySelector('input[name="permissions"][value="clients"]')?.closest('label');
    const permissionFieldset = legacyClientLabel?.closest('fieldset');
    legacyClientLabel?.remove();
    if (permissionFieldset) {
      for (const [value, text] of [['voir_clients', 'Consulter les clients'], ['gerer_clients', 'Gérer les clients']]) {
        const label = document.createElement('label');
        const checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
        checkbox.name = 'permissions';
        checkbox.value = value;
        label.append(checkbox, ` ${text}`);
        permissionFieldset.append(label);
      }
    }
  }
  if (type === 'purchase') {
    const branchLabel = document.createElement('label');
    branchLabel.textContent = 'Succursale de destination';
    const purchaseBranchSelect = document.createElement('select');
    purchaseBranchSelect.name = 'succursale_id';
    purchaseBranchSelect.required = true;
    const mainBranch = branchOptions.find(branch => Number(branch.est_sucursal_mere) === 1) || branchOptions[0];
    const canChooseBranch = canSelectCompanyBranches();
    purchaseBranchSelect.innerHTML = branchOptions.map(branch => `<option value="${Number(branch.succursale_id)}">${escapeHtml(branch.name)}</option>`).join('');
    if (!branchOptions.length && sessionUser?.succursale_id) purchaseBranchSelect.innerHTML = `<option value="${Number(sessionUser.succursale_id)}">${escapeHtml(sessionUser.branch_name || 'Ma succursale')}</option>`;
    purchaseBranchSelect.value = String(activeBranchId || sessionUser?.succursale_id || mainBranch?.succursale_id || '');
    branchLabel.appendChild(purchaseBranchSelect);
    branchLabel.hidden = !canChooseBranch;
    formMessage.after(branchLabel);
    const expirationLabel = document.createElement('label');
    expirationLabel.className = 'full';
    expirationLabel.innerHTML = 'Date d’expiration du lot<input type="date" name="date_expiration">';
    expirationLabel.hidden = true;
    const lotLabel = document.createElement('label');
    lotLabel.className = 'full';
    lotLabel.innerHTML = 'Répartition automatique (date d’expiration la plus proche d’abord)<div class="perishable-allocation-preview">Sélectionnez un produit et une quantité pour voir la répartition.</div>';
    lotLabel.hidden = true;
    const quantityLabel = form.querySelector('[name="quantity"]').closest('label');
    quantityLabel.before(expirationLabel, lotLabel);
    const operation = modal.querySelector('#purchase-operation');
    const supplierFields = modal.querySelector('#purchase-supplier-fields');
    const reasonField = modal.querySelector('#purchase-reason-field');
    const reasonInput = reasonField.querySelector('input');
    const costChoice = modal.querySelector('#purchase-cost-choice');
    const customCost = modal.querySelector('#purchase-custom-cost-field');
    const useProductCost = modal.querySelector('#purchase-use-product-cost');
    const supplierSearchInput = modal.querySelector('#purchase-supplier-search');
    const expirationInput = expirationLabel.querySelector('input');
    const lotPreview = lotLabel.querySelector('.perishable-allocation-preview');
    const quantityInput = form.querySelector('[name="quantity"]');
    const refreshPerishableFields = async () => {
      const perishable = Number(selectedPerishableProduct?.est_perisable) === 1;
      const outgoing = operation.value === 'OUT';
      const showExpiration = perishable && !outgoing;
      expirationLabel.hidden = !showExpiration;
      expirationLabel.style.display = showExpiration ? '' : 'none';
      lotLabel.hidden = !perishable || !outgoing;
      expirationInput.required = perishable && !outgoing;
      if (!perishable) expirationInput.value = '';
      if (!perishable || !outgoing) lotPreview.textContent = 'La répartition automatique s’affichera pour une sortie périssable.';
      if (perishable && outgoing && selectedPerishableProduct) {
        lotPreview.textContent = 'Calcul de la répartition…';
        try {
          const lots = await fetchReportData('perishable-lots', {produit_id:selectedPerishableProduct.produit_id, succursale_id:purchaseBranchSelect.value});
          let needed = Math.max(0, Number(quantityInput.value || 0));
          let available = lots.reduce((sum, lot) => sum + Number(lot.remaining_quantity), 0);
          const selectedUnit = units.find(unit => Number(unit.unite_mesure_id) === Number(selectedPerishableProduct.unite_de_mesure));
          const unitLabel = selectedUnit?.symbole || selectedUnit?.name || 'unité';
          const plan = [];
          for (const lot of lots) {
            if (needed <= 0) break;
            const allocated = Math.min(needed, Number(lot.remaining_quantity));
            if (allocated > 0) plan.push(`<li>${allocated} ${escapeHtml(unitLabel)} · lot ${escapeHtml(lot.purchase_no)} · expiration ${escapeHtml(lot.date_expiration)}</li>`);
            needed -= allocated;
          }
          lotPreview.innerHTML = !lots.length
            ? 'Aucun lot disponible pour cette succursale.'
            : `${available < Number(quantityInput.value || 0) ? `<strong>Stock insuffisant dans les lots (${available} disponible${available === 1 ? '' : 's'}).</strong>` : '<strong>Sortie proposée :</strong>'}<ul>${plan.join('') || '<li>Saisissez la quantité à sortir.</li>'}</ul>`;
        } catch (error) {
          lotPreview.textContent = 'Chargement des lots impossible.';
          showToast(error.message);
        }
      } else {
        lotPreview.textContent = 'Sélectionnez un produit et une quantité pour voir la répartition.';
      }
    };
    const syncPurchaseFields = () => {
      const outgoing = operation.value === 'OUT';
      supplierFields.hidden = outgoing;
      supplierFields.style.display = outgoing ? 'none' : '';
      reasonField.hidden = !outgoing;
      reasonField.style.display = outgoing ? '' : 'none';
      reasonInput.required = outgoing;
      if (!outgoing) reasonInput.value = '';
      costChoice.hidden = outgoing;
      const showCustomCost = !outgoing && !useProductCost.checked;
      customCost.hidden = !showCustomCost;
      // Le style explicite garantit que le champ reste masqué malgré les styles des formulaires.
      customCost.style.display = showCustomCost ? '' : 'none';
      customCost.querySelector('input').required = showCustomCost;
      if (outgoing) { supplierSearchInput.value = ''; modal.querySelector('#purchase-supplier').value = ''; }
    };
    operation.addEventListener('change', syncPurchaseFields);
    operation.addEventListener('change', refreshPerishableFields);
    purchaseBranchSelect.addEventListener('change', refreshPerishableFields);
    quantityInput.addEventListener('input', refreshPerishableFields);
    useProductCost.addEventListener('change', syncPurchaseFields);
    syncPurchaseFields();
    const supplierSearch = modal.querySelector('#purchase-supplier-search');
    const productSearch = modal.querySelector('#purchase-product-search');
    const supplierSelect = modal.querySelector('#purchase-supplier');
    const productSelect = modal.querySelector('#purchase-product');
    supplierSearch.setAttribute('list', 'purchase-supplier-options');
    productSearch.setAttribute('list', 'purchase-product-options');
    productSearch.required = true;
    supplierSearch.closest('label').firstChild.textContent = 'Fournisseur (facultatif)';
    supplierSearch.closest('label').insertAdjacentHTML('beforeend', '<datalist id="purchase-supplier-options"></datalist><input type="hidden" name="fournisseur_id" id="purchase-supplier">');
    productSearch.closest('label').insertAdjacentHTML('beforeend', '<datalist id="purchase-product-options"></datalist><input type="hidden" name="produit_id" id="purchase-product">');
    supplierSelect.closest('label').remove();
    productSelect.closest('label').remove();
  }
  if (type === 'user') form.elements.namedItem('password').required = !entity;
  if (type === 'product' && entity) form.elements.namedItem('min_stock_level').closest('label').hidden = true;
  if (entity) {
    Object.entries(entity).forEach(([name, value]) => {
      const field = form.elements.namedItem(name);
      if (!field || field.tagName === 'SELECT') return;
      if (field.type === 'checkbox') field.checked = Number(value) === 1;
      else field.value = value ?? '';
    });
  }
  if (type === 'user') {
    Promise.all([apiGet('roles'), apiGet('succursales')]).then(([roles, branches]) => {
      const roleSelect = modal.querySelector('#user-role');
      roleSelect.innerHTML = '<option value="">Choisir un rôle</option>' + roles.map(role => `<option value="${Number(role.role_id)}">${escapeHtml(role.role_name)}</option>`).join('');
      const branchSelect = modal.querySelector('#user-branch');
      branchSelect.insertAdjacentHTML('beforeend', branches.map(branch => `<option value="${Number(branch.succursale_id)}">${escapeHtml(branch.name)}</option>`).join(''));
      if (entity) { roleSelect.value = entity.role_id; branchSelect.value = entity.succursale_id || ''; }
    }).catch(error => showToast(error.message));
  }
  if (type === 'role' && entity) {
    let granted = entity.permissions;
    if (typeof granted === 'string') { try { granted = JSON.parse(granted); } catch { granted = []; } }
    if (!Array.isArray(granted)) granted = [];
    const groupRights = {
      vente: ['voir_ventes', 'creer_ventes', 'modifier_ventes'],
      caisse: ['voir_caisse', 'creer_caisse', 'modifier_caisse', 'supprimer_caisse'],
      stock: ['voir_stock', 'modifier_stock', 'creer_produit', 'modifier_produit', 'supprimer_produit', 'voir_succursales', 'voir_fournisseurs', 'creer_fournisseurs', 'modifier_fournisseurs', 'supprimer_fournisseurs', 'voir_approvisionnements', 'creer_approvisionnements'],
      approvisionnement: ['voir_stock', 'voir_succursales', 'voir_fournisseurs', 'creer_fournisseurs', 'voir_approvisionnements', 'creer_approvisionnements'],
      voir_clients: ['voir_clients'],
      gerer_clients: ['voir_clients', 'gerer_clients'],
      comptabilite: ['voir_comptabilite', 'creer_comptabilite', 'modifier_comptabilite']
    };
    Object.entries(groupRights).forEach(([group, rights]) => {
      const checkbox = form.querySelector(`input[name="permissions"][value="${group}"]`);
      if (checkbox) {
        const legacyStockRole = group === 'stock' && !granted.includes('approvisionnement') && rights.some(right => granted.includes(right));
        const legacyProcurementRole = group === 'approvisionnement' && !granted.includes('stock') && granted.includes('voir_approvisionnements') && granted.includes('creer_approvisionnements');
        const legacyClientRole = ['voir_clients', 'gerer_clients'].includes(group) && granted.includes('clients');
        checkbox.checked = granted.includes('*') || granted.includes(group) || legacyStockRole || legacyProcurementRole || legacyClientRole;
      }
    });
  }
  if (type === 'product') {
    Promise.all([apiGet('categories'), apiGet('unites_mesure'), fetch('../backend/public/auth.php?action=currencies', {credentials:'include'}).then(readJson)]).then(([categories, units, currencyResponse]) => {
      if (!currencyResponse.success) throw new Error(currencyResponse.message || 'Chargement des monnaies impossible.');
      const fill = (id, items, key, label) => { const select = modal.querySelector(id); items.forEach(item => select.insertAdjacentHTML('beforeend', `<option value="${Number(item[key])}">${escapeHtml(item[label])}</option>`)); };
      fill('#product-category', categories, 'category_id', 'name');
      const unitSelect = modal.querySelector('#product-unit');
      unitSelect.innerHTML = '<option value="">Choisir une unite</option>' + units.map(unit => `<option value="${Number(unit.unite_mesure_id)}">${escapeHtml(unit.name)}${unit.symbole ? ` (${escapeHtml(unit.symbole)})` : ''}</option>`).join('');
      const currencySelect = modal.querySelector('#product-currency');
      currencySelect.innerHTML = '<option value="">Choisir une monnaie</option>' + currencyResponse.data.map(currency => `<option value="${escapeHtml(currency.type_monais)}">${escapeHtml(currency.type_monais)} — ${escapeHtml(currency.description || '')}</option>`).join('');
      if (!currencyResponse.data.length) currencySelect.innerHTML = '<option value="">Aucune monnaie configurée par le super administrateur</option>';
      if (entity) {
        modal.querySelector('#product-category').value = entity.category_id || '';

        currencySelect.value = entity.monais || '';
        unitSelect.value = entity.unite_de_mesure || '';
      }
    }).catch(error => showToast(error.message));
  }
  if (type === 'purchase') {
    const supplierSelect = modal.querySelector('#purchase-supplier');
    const supplierSearch = modal.querySelector('#purchase-supplier-search');
    const supplierOptions = modal.querySelector('#purchase-supplier-options');
    const productSearch = modal.querySelector('#purchase-product-search');
    const productOptions = modal.querySelector('#purchase-product-options');
    const productSelect = modal.querySelector('#purchase-product');
    const purchaseBranchId = Number(modal.querySelector('[name="succursale_id"]')?.value || sessionUser?.succursale_id || 0) || null;
    const suppliersRequest = purchaseBranchId
      ? apiGet('fournisseurs', purchaseBranchId)
      : apiGet('succursales').then(branches => {
          const mainBranch = branches.find(branch => Number(branch.est_sucursal_mere) === 1) || branches[0];
          return apiGet('fournisseurs', mainBranch ? Number(mainBranch.succursale_id) : undefined);
        });
    Promise.all([apiGet('produits'), suppliersRequest, apiGet('unites_mesure')]).then(([products, suppliers, units]) => {
        let availableSuppliers = suppliers;
      const normalizeSearch = value => String(value ?? '').normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLocaleLowerCase().trim();
      const supplierLabels = new Map();
      const productLabels = new Map();
      const supplierLabel = row => `${row.name}${row.contact_name ? ` — ${row.contact_name}` : ''} (#${Number(row.fournisseur_id)})`;
      const productLabel = row => { const unit = units.find(item => Number(item.unite_mesure_id) === Number(row.unite_de_mesure)); return `${row.name}${row.sku ? ` - ${row.sku}` : ''}${unit ? ` - ${unit.symbole || unit.name}` : ''}${row.monais ? ` - ${row.monais}` : ''}`; };
      const fillSuppliers = (term = '') => {
        const query = normalizeSearch(term);
        const matches = availableSuppliers.filter(row => normalizeSearch(`${row.name} ${row.contact_name || ''} ${row.email || ''} ${row.phone || ''} ${supplierLabel(row)}`).includes(query));
        supplierLabels.clear();
        supplierOptions.innerHTML = matches.map(row => {
          const label = supplierLabel(row);
          supplierLabels.set(label, row);
          return `<option value="${escapeHtml(label)}"></option>`;
        }).join('');
      };
      const fillProducts = (term = '') => {
        const query = normalizeSearch(term);
        const matches = products.filter(row => Number(row.is_active ?? 1) === 1 && normalizeSearch(`${row.name} ${row.sku || ''} ${productLabel(row)}`).includes(query));
        productLabels.clear();
        productOptions.innerHTML = matches.map(row => {
          const label = productLabel(row);
          productLabels.set(label, row);
          return `<option value="${escapeHtml(label)}"></option>`;
        }).join('');
      };
      modal.querySelector('[name="succursale_id"]').addEventListener('change', async event => {
        supplierSearch.value = '';
        supplierSelect.value = '';
        try {
          availableSuppliers = await apiGet('fournisseurs', event.target.value);
          fillSuppliers();
        } catch (error) { showToast(error.message); }
      });
      fillSuppliers();
      fillProducts();
      supplierSearch.addEventListener('input', event => {
        fillSuppliers(event.target.value);
        const selected = supplierLabels.get(event.target.value);
        supplierSelect.value = selected ? String(selected.fournisseur_id) : '';
      });
      const syncSelectedPurchaseProduct = event => {
        fillProducts(event.target.value);
        const selected = productLabels.get(event.target.value);
        selectedPerishableProduct = selected || null;
        productSelect.value = selected ? String(selected.produit_id) : '';
        productSelect.dataset.costPrice = selected ? String(Number(selected.cost_price || 0)) : '';
        productSelect.dataset.perishable = selected ? String(Number(selected.est_perisable || 0)) : '0';
        const selectedUnit = selected ? units.find(item => Number(item.unite_mesure_id) === Number(selected.unite_de_mesure)) : null;
        productSearch.closest('form').elements.namedItem('quantity').closest('label').firstChild.textContent = selected ? `Quantité (${selectedUnit?.symbole || selectedUnit?.name || 'unité'})` : 'Quantité';
        expirationInput.value = '';
        refreshPerishableFields();
        const useSavedCost = modal.querySelector('#purchase-use-product-cost');
        if (selected && Number(selected.cost_price || 0) === 0 && useSavedCost.checked) {
          useSavedCost.checked = false;
          useSavedCost.dispatchEvent(new Event('change'));
          showToast('Le coût enregistré vaut 0. Saisissez le coût de cette entrée.');
        }
      };
      productSearch.addEventListener('input', syncSelectedPurchaseProduct);
      productSearch.addEventListener('change', syncSelectedPurchaseProduct);
      refreshPerishableFields();
      modal.querySelector('#purchase-use-product-cost').addEventListener('change', event => {
        if (event.target.checked && productSelect.value && Number(productSelect.dataset.costPrice) === 0) {
          event.target.checked = false;
          event.target.dispatchEvent(new Event('change'));
          showToast('Le coût du produit vaut 0. Choisissez un coût d’entrée spécifique.');
        }
      });
    }).catch(error => showToast(error.message));
  }
  if (type === 'category' && entity) form.elements.namedItem('name').value = entity.name || '';
  if (type === 'category' && entity) form.elements.namedItem('description').value = entity.description || '';
  if (type === 'branch' && entity) Object.entries(entity).forEach(([name, value]) => { const field = form.elements.namedItem(name); if (field) { if (field.type === 'checkbox') field.checked = Number(value) === 1; else field.value = value ?? ''; } });
  modal.querySelector('.modal-cancel').addEventListener('click', () => modal.remove());
  form.addEventListener('submit', async event => {
    event.preventDefault();
    const formData = new FormData(form);
    const data = Object.fromEntries(formData);
    if (type === 'purchase') {
      const outgoing = data.movement_type === 'OUT';
      if (outgoing && !String(data.motif_sortie || '').trim()) { showFormError('Indiquez le motif de la sortie de stock.'); return; }
      data.fournisseur_id = outgoing ? null : (data.fournisseur_id || null);
      data.unit_cost_mode = outgoing ? 'NONE' : (modal.querySelector('#purchase-use-product-cost').checked ? 'PRODUCT' : 'CUSTOM');
      if (outgoing) data.unit_cost = 0;
      if (!data.produit_id) { showFormError('Choisissez un produit dans les résultats proposés.'); return; }
      const selectedProductIsPerishable = Number(modal.querySelector('#purchase-product').dataset.perishable) === 1;
      if (selectedProductIsPerishable && !outgoing && !data.date_expiration) {
        expirationLabel.hidden = false;
        expirationLabel.style.display = 'flex';
        expirationInput.required = true;
        showFormError('Saisissez la date d’expiration de ce lot.');
        expirationInput.focus();
        return;
      }
      if (!outgoing && modal.querySelector('#purchase-supplier-search').value.trim() && !data.fournisseur_id) { showFormError('Choisissez un fournisseur dans les résultats ou laissez ce champ vide.'); return; }
    }
    if (type === 'role') data.permissions = formData.getAll('permissions');
    if (type === 'user') { data.succursale_id = data.succursale_id || null; data.is_active = form.elements.namedItem('is_active').checked ? 1 : 0; }
    if (type === 'branch') data.est_sucursal_mere = form.elements.namedItem('est_sucursal_mere').checked ? 1 : 0;
    if (type === 'product') { data.est_perisable = data.est_perisable ? 1 : 0; data.category_id = data.category_id || null; delete data.fournisseur_id; data.unite_de_mesure = Number(data.unite_de_mesure); }
    try {
      const primaryKeys = {unit: 'unite_mesure_id', product: 'produit_id', category: 'category_id', branch: 'succursale_id', supplier: 'fournisseur_id', user: 'user_id', role: 'role_id'};
      let endpoint = definition.endpoint;
      if (entity && type === 'user') endpoint = `../backend/public/auth.php?action=update-user&id=${encodeURIComponent(entity[primaryKeys[type]])}`;
      else if (entity && type === 'role') endpoint = `../backend/public/auth.php?action=update-role&id=${encodeURIComponent(entity[primaryKeys[type]])}`;
      else if (entity) endpoint = `${definition.endpoint}&id=${encodeURIComponent(entity[primaryKeys[type]])}`;
      const response = await fetch(endpoint, {method: entity ? 'PATCH' : 'POST', headers: {'Content-Type': 'application/json'}, credentials: 'include', body: JSON.stringify(data)});
      const result = await readJson(response);
      if (!response.ok || !result.success) throw new Error(result.message || 'Enregistrement impossible.');
      formMessage.hidden = true;
      modal.remove();
      showToast(entity ? 'Modifications enregistrées' : 'Enregistrement effectué'); if (type === 'product' || type === 'category' || type === 'unit') loadStock(); if (type === 'unit') refreshUnitManager?.(); if (type === 'role') loadRoleList(); if (type === 'user') loadUserRows(); if (type === 'purchase') loadPurchaseRows(); if (type === 'supplier') loadSupplierRows(); if (type === 'branch') loadSimpleRows('succursales', 'branch-rows', 6, row => `<tr><td>${escapeHtml(row.name)}</td><td>${escapeHtml(row.code)}</td><td>${Number(row.est_sucursal_mere) ? '<span class="status success">Principale</span>' : '—'}</td><td>${escapeHtml(row.address || '—')}</td><td>${escapeHtml(row.phone || '—')}</td><td><button class="text-button" data-branch-edit="${Number(row.succursale_id)}">Modifier</button> <button class="text-button" data-branch-delete="${Number(row.succursale_id)}">Supprimer</button></td></tr>`, 'Aucune succursale enregistrée.');
    } catch (error) { showFormError(error.message); }
  });
}
document.querySelectorAll('.nav-item').forEach(item => item.addEventListener('click', () => { navigate(item.dataset.view); document.getElementById('sidebar').classList.remove('open'); }));
document.querySelector('[data-logout]')?.addEventListener('click', async event => {
  const button = event.currentTarget;
  if (button.disabled) return;
  button.disabled = true;
  try {
    const response = await fetch('../backend/public/auth.php?action=logout', {method:'POST', credentials:'include'});
    const result = await readJson(response);
    if (!response.ok || !result.success) throw new Error(result.message || 'Déconnexion impossible.');
    window.location.replace('login.html');
  } catch (error) {
    button.disabled = false;
    showToast(error.message);
  }
});
async function deleteResource(resource, id, description, onSuccess) {
  if (!window.confirm(`Supprimer ${description} ? Cette action ne peut pas toujours être annulée.`)) return;
  try {
    const response = await fetch(`${apiUrl(resource)}&id=${encodeURIComponent(id)}`, {method:'DELETE', credentials:'include'});
    const result = await readJson(response);
    if (!response.ok || !result.success) throw new Error(result.message || 'Suppression impossible.');
    if (!result.data?.deleted) throw new Error('Aucun élément supprimé. Vérifiez les droits et les références associées.');
    showToast('Élément supprimé.');
    onSuccess();
  } catch (error) { showToast(error.message); }
}
async function fetchReportData(actionName, params = {}) {
  const query = new URLSearchParams({action:actionName, ...params});
  if (activeBranchId && !query.has('succursale_id')) query.set('succursale_id', activeBranchId);
  const response = await fetch(`../backend/public/report-data.php?${query}`, {credentials:'include'});
  const result = await readJson(response);
  if (!response.ok || !result.success) throw new Error(result.message || 'Chargement du rapport impossible.');
  return result.data;
}
async function fetchReportPage(actionName, page, params = {}) {
  const query = new URLSearchParams({action:actionName, ...params, page:String(page), per_page:String(PAGE_SIZE)});
  if (activeBranchId) query.set('succursale_id', activeBranchId);
  const response = await fetch(`../backend/public/report-data.php?${query}`, {credentials:'include'});
  const result = await readJson(response);
  if (!response.ok || !result.success) throw new Error(result.message || 'Chargement impossible.');
  return {rows:result.data || [], summary:result.summary || [], pagination:result.pagination || {page, per_page:PAGE_SIZE, total:(result.data || []).length, pages:1}};
}
function movementReportMarkup(report, from, to) {
  const period = from || to ? `du ${formatReportDate(from) || 'début'} au ${formatReportDate(to) || 'fin'}` : 'toutes périodes';
  const sections = report.products.map(product => {
    const rows = report.movements.filter(row => Number(row.produit_id) === Number(product.produit_id));
    const perishable = Number(product.est_perisable) === 1;
    const headers = ['Date', 'Référence', 'Origine / Motif', 'Quantité entrée'];
    if (perishable) headers.push('Lot', 'Date expiration');
    headers.push('Quantité sortie', 'Solde', 'P.U', 'P.T', 'Observation');
    const totals = {entries:{quantity:0, amount:0}, exits:{quantity:0, amount:0}};
    const body = rows.map(row => {
      const unit = row.unit_symbol || row.unit_name || '';
      const quantity = Number(row.quantity_moved);
      const adjustment = row.movement_type === 'AJUSTEMENT';
      const entry = row.movement_type === 'ENTREE' || (adjustment && Number(row.quantity_after) > Number(row.quantity_before));
      const exit = row.movement_type === 'SORTIE' || (adjustment && Number(row.quantity_after) < Number(row.quantity_before));
      const cost = Number(row.unit_cost || 0);
      const amount = cost * quantity;
      if (entry) { totals.entries.quantity += quantity; totals.entries.amount += amount; }
      if (exit) { totals.exits.quantity += quantity; totals.exits.amount += amount; }
      const cells = [dateLabel(row.movement_date), row.reference_label || '—', row.origin_motif || '—', entry ? `${quantity} ${unit}`.trim() : '—'];
      if (perishable) cells.push(row.lot_label || '—', row.expiration_dates || '—');
      cells.push(exit ? `${quantity} ${unit}`.trim() : '—', `${Number(row.quantity_after)} ${unit}`.trim(), moneyCurrencyLabel(cost, row.monais), moneyCurrencyLabel(amount, row.monais), row.observation || '—');
      return `<tr>${cells.map(value => `<td>${escapeHtml(value)}</td>`).join('')}</tr>`;
    }).join('');
    const unit = product.unit_symbol || product.unit_name || '';
    const combinedQuantity = totals.entries.quantity + totals.exits.quantity;
    const combinedAmount = totals.entries.amount + totals.exits.amount;
    const totalsMarkup = `<h2>Totaux — ${escapeHtml(product.name)}</h2><table class="report-table" data-skip-report-totals="true"><thead><tr><th>Type</th><th>Quantité totale</th><th>Valeur au coût d’achat</th></tr></thead><tbody><tr><td>Entrées</td><td>${totals.entries.quantity.toLocaleString('fr-FR')} ${escapeHtml(unit)}</td><td>${escapeHtml(moneyCurrencyLabel(totals.entries.amount, product.monais))}</td></tr><tr><td>Sorties</td><td>${totals.exits.quantity.toLocaleString('fr-FR')} ${escapeHtml(unit)}</td><td>${escapeHtml(moneyCurrencyLabel(totals.exits.amount, product.monais))}</td></tr><tr class="report-total-row"><td>Cumul des entrées + sorties</td><td>${combinedQuantity.toLocaleString('fr-FR')} ${escapeHtml(unit)}</td><td>${escapeHtml(moneyCurrencyLabel(combinedAmount, product.monais))}</td></tr></tbody></table>`;
    return `<h2>${escapeHtml(product.name)} (${escapeHtml(product.sku)}) — ${escapeHtml(period)}</h2><div style="overflow:auto"><table class="report-table" data-skip-report-totals="true"><thead><tr>${headers.map(header => `<th>${escapeHtml(header)}</th>`).join('')}</tr></thead><tbody>${body || `<tr><td colspan="${headers.length}">Aucun mouvement pour cette période.</td></tr>`}</tbody></table></div>${totalsMarkup}`;
  }).join('');
  return {period, content: sections};
}
async function openStockMovementsReport() {
  const modal = document.createElement('div');
  modal.className = 'entity-modal';
  modal.innerHTML = `<section class="entity-dialog movement-report-dialog"><div class="unit-manager-heading"><div><span class="kicker">RAPPORT DE STOCK</span><h2>Fiche de stock</h2><p>Choisissez un ou plusieurs produits et la période à analyser.</p></div><button type="button" class="modal-cancel" data-movement-close aria-label="Fermer">×</button></div><div class="movement-report-filters"><label>Date de début<input type="date" data-movement-from></label><label>Date de fin<input type="date" data-movement-to></label></div><label class="movement-product-search">Rechercher un produit<input type="search" data-movement-search placeholder="Nom ou référence"></label><div class="movement-product-list" data-movement-products><p>Chargement des produits…</p></div><div class="movement-report-actions"><button type="button" class="modal-cancel" data-movement-select-visible>Sélectionner les produits affichés</button><button type="button" class="modal-submit" data-movement-generate>Afficher la fiche</button></div><div data-movement-output hidden></div></section>`;
  document.body.appendChild(modal);
  modal.querySelector('[data-movement-generate]').textContent = 'Afficher fiche de stock';
  let latestReport = null;
  let latestTitle = '';
  const productsList = modal.querySelector('[data-movement-products]');
  const close = () => modal.remove();
  modal.querySelector('[data-movement-close]').addEventListener('click', close);
  modal.addEventListener('click', event => { if (event.target === modal) close(); });
  try {
    let products = [];
    const selectedProductIds = new Set();
    const renderProducts = () => {
      const term = modal.querySelector('[data-movement-search]').value.trim().toLocaleLowerCase('fr');
      const matches = products.filter(product => `${product.name} ${product.sku}`.toLocaleLowerCase('fr').includes(term));
      productsList.innerHTML = matches.length ? matches.map(product => {
        const label = `${product.name} — ${product.sku}${product.unit_symbol || product.unit_name ? ` (${product.unit_symbol || product.unit_name})` : ''}`;
        return `<label class="movement-product-option"><input type="checkbox" value="${Number(product.produit_id)}" ${selectedProductIds.has(String(product.produit_id)) ? 'checked' : ''}><span>${escapeHtml(label)}</span></label>`;
      }).join('') : '<p>Aucun produit trouvé.</p>';
    };
    const loadMovementProducts = async page => {
      const result = await fetchReportPage('stock-movements-products', page);
      products = result.rows;
      renderProducts();
      showPagination(productsList, 'movement-products', result.pagination, loadMovementProducts);
    };
    await loadMovementProducts(1);
    modal.querySelector('[data-movement-search]').addEventListener('input', renderProducts);
    productsList.addEventListener('change', event => {
      if (event.target.matches('input[type="checkbox"]')) {
        if (event.target.checked) selectedProductIds.add(event.target.value);
        else selectedProductIds.delete(event.target.value);
      }
    });
    modal.querySelector('[data-movement-select-visible]').addEventListener('click', () => {
      productsList.querySelectorAll('input[type="checkbox"]').forEach(input => { input.checked = true; selectedProductIds.add(input.value); });
    });
    modal.querySelector('[data-movement-generate]').addEventListener('click', async () => {
      const productIds = [...selectedProductIds];
      if (!productIds.length) { showToast('Sélectionnez au moins un produit.'); return; }
      const from = modal.querySelector('[data-movement-from]').value;
      const to = modal.querySelector('[data-movement-to]').value;
      if (from && to && from > to) { showToast('La date de début doit précéder la date de fin.'); return; }
      const params = {produits:productIds.join(','), date_debut:from, date_fin:to};
      const branch = document.getElementById('stock-branch')?.value;
      if (branch) params.succursale_id = branch;
      const button = modal.querySelector('[data-movement-generate]');
      button.disabled = true;
      try {
        latestReport = await fetchReportData('stock-movements-report', params);
        const rendered = movementReportMarkup(latestReport, from, to);
        latestTitle = latestReport.products.length === 1 ? `Fiche de stock — ${latestReport.products[0].name}` : 'Fiche de stock — plusieurs produits';
        const output = modal.querySelector('[data-movement-output]');
        output.hidden = false;
        output.innerHTML = `<div class="movement-report-result"><p><strong>Période :</strong> ${escapeHtml(rendered.period)} · <strong>Opérations :</strong> ${latestReport.totals.operations}</p>${rendered.content}<div class="movement-report-actions"><button type="button" class="modal-cancel" data-movement-export>Exporter vers Excel</button><button type="button" class="modal-cancel" data-movement-print>Imprimer</button><button type="button" class="modal-submit" data-movement-pdf>Exporter en PDF</button></div></div>`;
        removeBranchColumns(output);
        addReportTableTotals(output);
      } catch (error) { showToast(error.message); }
      finally { button.disabled = false; }
    });
    modal.addEventListener('click', event => {
      if (!latestReport) return;
      if (event.target.closest('[data-movement-print],[data-movement-pdf]')) {
        const printWindow = window.open('', '_blank');
        if (!printWindow) { showToast('Autorisez les fenêtres contextuelles pour imprimer le rapport.'); return; }
        const printable = modal.querySelector('.movement-report-result').cloneNode(true);
        printable.querySelectorAll('.movement-report-actions').forEach(actions => actions.remove());
        const content = printable.innerHTML;
        printReportInWindow(printWindow, latestTitle, content, `Période : ${modal.querySelector('[data-movement-from]').value || 'début'} au ${modal.querySelector('[data-movement-to]').value || 'fin'}`, 'landscape');
      }
      if (event.target.closest('[data-movement-export]')) {
        const lines = [[latestTitle], [`Période : ${modal.querySelector('[data-movement-from]').value || 'début'} au ${modal.querySelector('[data-movement-to]').value || 'fin'}`], []];
        latestReport.products.forEach(product => {
          lines.push([`${product.name} (${product.sku})`]);
          const headers = ['Date', 'Référence', 'Origine / Motif', 'Quantité entrée'];
          if (Number(product.est_perisable) === 1) headers.push('Lot', 'Date expiration');
          headers.push('Quantité sortie', 'Solde', 'P.U', 'P.T', 'Observation');
          lines.push(headers);
          latestReport.movements.filter(row => Number(row.produit_id) === Number(product.produit_id)).forEach(row => {
            const unit = row.unit_symbol || row.unit_name || '';
            const quantity = Number(row.quantity_moved);
            const adjustment = row.movement_type === 'AJUSTEMENT';
            const entry = row.movement_type === 'ENTREE' || (adjustment && Number(row.quantity_after) > Number(row.quantity_before));
            const exit = row.movement_type === 'SORTIE' || (adjustment && Number(row.quantity_after) < Number(row.quantity_before));
            const cost = Number(row.unit_cost || 0);
            const values = [dateLabel(row.movement_date), row.reference_label || '—', row.origin_motif || '—', entry ? `${quantity} ${unit}`.trim() : '—'];
            if (Number(product.est_perisable) === 1) values.push(row.lot_label || '—', row.expiration_dates || '—');
            values.push(exit ? `${quantity} ${unit}`.trim() : '—', `${Number(row.quantity_after)} ${unit}`.trim(), moneyCurrencyLabel(cost, row.monais), moneyCurrencyLabel(cost * quantity, row.monais), row.observation || '—');
            lines.push(values);
          });
          lines.push([]);
        });
        const csv = lines.map(line => line.map(value => `"${String(value ?? '').replace(/"/g, '""')}"`).join(';')).join('\r\n');
        const link = document.createElement('a'); link.href = URL.createObjectURL(new Blob(['\ufeff', csv], {type:'text/csv;charset=utf-8'})); link.download = 'fiche-mouvements-stock.csv'; link.click(); setTimeout(() => URL.revokeObjectURL(link.href), 1000);
      }
    });
  } catch (error) {
    productsList.innerHTML = `<p>${escapeHtml(error.message)}</p>`;
  }
}
function printReportInWindow(printWindow, title, content, note = '', orientation = 'portrait', centerContent = false) {
  const reportFragment = document.createElement('div');
  reportFragment.innerHTML = content;
  removeBranchColumns(reportFragment);
  addReportTableTotals(reportFragment);
  content = reportFragment.innerHTML;
  let printStarted = false;
  const startPrinting = async () => {
    if (printStarted || printWindow.closed) return;
    printStarted = true;
    const images = [...printWindow.document.images];
    await Promise.all(images.map(image => image.complete ? Promise.resolve() : new Promise(resolve => {
      image.addEventListener('load', resolve, {once:true});
      image.addEventListener('error', resolve, {once:true});
      window.setTimeout(resolve, 3000);
    })));
    if (printWindow.closed) return;
    printWindow.focus();
    window.setTimeout(() => {
      if (!printWindow.closed) printWindow.print();
    }, 300);
  };
  // L’écouteur doit être installé avant document.close(), qui peut déclencher load immédiatement.
  printWindow.addEventListener('load', startPrinting, {once:true});
  printWindow.document.open();
  let documentHtml = reportDocument(title, content, note, orientation);
  if (centerContent) documentHtml = documentHtml.replace('</style>', 'header{flex-direction:column;align-items:center;text-align:center}header>div,.report-meta{width:100%;text-align:center}main{text-align:center}main h2{margin-left:auto;margin-right:auto}</style>');
  if (orientation === 'landscape') documentHtml = documentHtml.replace('</style>', '@media print{.stock-card-report .dashboard-grid{grid-template-columns:repeat(3,minmax(0,1fr));gap:8px}.stock-card-report .stat-card{margin:0}.stock-card-report .report-table th,.stock-card-report .report-table td{padding:4px;font-size:9px}.stock-card-report .report-table{table-layout:fixed}.stock-card-report .report-table th,.stock-card-report .report-table td{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}.stock-card-page{display:flex;flex-direction:column;break-after:page;page-break-after:always;min-height:184mm;break-inside:avoid}.stock-card-page--first{min-height:126mm}.stock-card-page:last-child{break-after:auto;page-break-after:auto}.stock-page-footer{margin-top:auto;break-inside:avoid}.stock-page-footer p{margin:3px 0;padding:4px;background:#eaf3ee}.stock-carryover{padding:5px;background:#fff6dc}}</style>');
  const logo = companyLogoMarkup();
  if (logo) documentHtml = documentHtml.replace('<header>', `<header>${logo}`);
  documentHtml = documentHtml.replace('</style>', '.report-company-logo{width:76px;height:76px;object-fit:contain;flex:0 0 76px}.company-stamp-image{display:block;width:150px;height:90px;object-fit:contain;margin:10px 0 0}.stamp-signature{min-height:120px}</style>');
  printWindow.document.write(documentHtml);
  printWindow.document.close();
  // Certains navigateurs n’émettent pas load après l’écriture d’un document neuf.
  window.setTimeout(startPrinting, 800);
}
function purchaseVoucherMarkup(data) {
  const {purchase, details, allocations = []} = data;
  const movement = purchase.movement_type === 'OUT' ? 'BON DE SORTIE' : 'BON D’ENTRÉE';
  const stamp = sessionUser?.enterprise_cachet ? `<img class="company-stamp-image" src="${escapeHtml(companyImageUrl(sessionUser.enterprise_cachet))}" alt="Cachet ${escapeHtml(sessionUser.enterprise_name || 'entreprise')}">` : '';
  const perishable = details.some(row => row.date_expiration);
  const detailRows = details.map(row => {
    const unit = escapeHtml(row.unit_abbreviation || row.unit_name || '');
    const remaining = Math.max(0, Number(row.quantity || 0) - Number(row.quantity_out || 0));
    return `<tr><td>${escapeHtml(row.sku)}</td><td>${escapeHtml(row.product_name)}</td><td>${Number(row.quantity)} ${unit}</td>${perishable ? `<td>${escapeHtml(row.date_expiration || '—')}</td><td>${Number(row.quantity_out || 0)} ${unit}</td><td>${remaining} ${unit}</td>` : ''}<td>${moneyLabel(row.unit_cost)} ${escapeHtml(row.monais || '')}</td><td>${moneyLabel(row.subtotal)} ${escapeHtml(row.monais || '')}</td></tr>`;
  }).join('');
  const perishableHeaders = perishable ? '<th>Expiration du lot</th><th>Quantité sortie</th><th>Solde du lot</th>' : '';
  const detailColumnCount = perishable ? 8 : 5;
  const detailsHtml = `<table class="report-table"><thead><tr><th>Référence</th><th>Produit</th><th>Quantité</th>${perishableHeaders}<th>Coût unitaire</th><th>Total</th></tr></thead><tbody>${detailRows || `<tr><td colspan="${detailColumnCount}">Aucun détail disponible</td></tr>`}</tbody></table><h2>Total : ${moneyLabel(purchase.total_amount)} ${escapeHtml(details[0]?.monais || '')}</h2>${allocations.length ? `<h2>Lots consommés (expiration la plus proche en premier)</h2><table class="report-table"><thead><tr><th>Produit</th><th>Approvisionnement source</th><th>Date d’expiration</th><th>Quantité prélevée</th></tr></thead><tbody>${allocations.map(row => `<tr><td>${escapeHtml(row.product_name)} (${escapeHtml(row.sku)})</td><td>${escapeHtml(row.purchase_no)}</td><td>${escapeHtml(row.date_expiration || '—')}</td><td>${Number(row.quantity)} ${escapeHtml(row.unit_abbreviation || row.unit_name || '')}</td></tr>`).join('')}</tbody></table>` : ''}<div class="signature-row"><div class="stamp-signature">Signature et cachet${stamp}</div><div>Réceptionné / validé : signature</div></div>`;
  const party = purchase.movement_type === 'OUT'
    ? `<p><strong>Succursale :</strong> ${escapeHtml(purchase.branch_name)} | <strong>Motif de sortie :</strong> ${escapeHtml(purchase.motif_sortie || '-')}</p>`
    : `<p><strong>Succursale :</strong> ${escapeHtml(purchase.branch_name)} | <strong>Fournisseur :</strong> ${escapeHtml(purchase.supplier_name || 'Non renseigne')}</p><p><strong>Contact fournisseur :</strong> ${escapeHtml(purchase.supplier_contact || purchase.supplier_phone || '-')}</p>`;
  const content = `<p><strong>Reference :</strong> ${escapeHtml(purchase.purchase_no)} | <strong>Date :</strong> ${escapeHtml(dateLabel(purchase.purchase_date))}</p>${party}<p><strong>Statut :</strong> ${escapeHtml(purchase.status)}</p>${detailsHtml}`;
  return {title:movement, content};
}
async function printPurchaseVoucher(button) {
  if (button.disabled) return;
  const printWindow = window.open('', '_blank');
  if (!printWindow) { showToast('Autorisez les fenêtres contextuelles pour imprimer le bon.'); return; }
  const buttonLabel = button.querySelector('span');
  const originalLabel = buttonLabel?.textContent || 'Imprimer';
  button.disabled = true;
  button.setAttribute('aria-busy', 'true');
  if (buttonLabel) buttonLabel.textContent = 'Préparation…';
  try {
    const data = await fetchReportData('purchase-voucher', {achat_id:button.dataset.purchaseVoucher});
    const voucher = purchaseVoucherMarkup(data);
    printReportInWindow(printWindow, voucher.title, voucher.content);
    showToast('Bon prêt : impression lancée.');
  } catch (error) { printWindow.close(); showToast(`Impression du bon impossible : ${error.message}`); }
  finally {
    button.disabled = false;
    button.removeAttribute('aria-busy');
    if (buttonLabel) buttonLabel.textContent = originalLabel;
  }
}
async function startSalePayment({saleId,amount,currency,branchId,invoice}){
  await openPaymentEntry({title:'Payer la facture',amount,currency,branchId,referenceTitle:`Facture ${invoice}`,isInbound:true,submit:async payload=>{payload.vente_id=saleId;payload.monais=currency;payload.source='CASH';const response=await fetch('../backend/public/auth.php?action=collect-sale-payment',{method:'POST',headers:{'Content-Type':'application/json'},credentials:'include',body:JSON.stringify(payload)});const result=await readJson(response);if(!response.ok||!result.success)throw new Error(result.message||'Validation du paiement impossible.');showToast(result.message||'Paiement de vente enregistré.');loadSalesRows();loadCashRows();loadPendingSales();}});
}
async function confirmSalePayment(button){
  const saleId=Number(button.dataset.salePayCash),branchId=Number(button.dataset.saleBranch),invoice=button.dataset.saleInvoiceNo||'';
  let balances=[];
  try{balances=JSON.parse(button.dataset.saleBalances||'[]').filter(balance=>Number(balance.due)>0&&String(balance.monais||'').trim()!=='');}catch{showToast('Les monnaies dues de cette facture sont invalides.');return;}
  if(!saleId||!branchId||!balances.length){showToast('Aucun montant ne reste à payer sur cette facture.');return;}
  if(balances.length===1){await startSalePayment({saleId,amount:Number(balances[0].due),currency:balances[0].monais,branchId,invoice});return;}
  const modal=document.createElement('div');modal.className='entity-modal';modal.innerHTML=`<section class="entity-dialog"><h2>Payer la facture ${escapeHtml(invoice)}</h2><p class="panel-subtitle">Sélectionnez le total dans la monnaie que le client règle.</p><form class="entity-form"><label class="full">Monnaie à régler<select name="monais" required>${balances.map(balance=>`<option value="${escapeHtml(balance.monais)}" data-due="${Number(balance.due)}">${escapeHtml(balance.monais)} · Reste ${moneyCurrencyLabel(balance.due,balance.monais)}</option>`).join('')}</select></label><div class="entity-modal-actions full"><button type="button" class="modal-cancel">Annuler</button><button class="modal-submit">Continuer vers la caisse</button></div></form></section>`;document.body.appendChild(modal);
  const form=modal.querySelector('form'),currencySelect=form.elements.namedItem('monais');modal.querySelector('.modal-cancel').addEventListener('click',()=>modal.remove());form.addEventListener('submit',async event=>{event.preventDefault();const balance=balances.find(item=>item.monais===currencySelect.value);if(!balance)return;modal.remove();await startSalePayment({saleId,amount:Number(balance.due),currency:balance.monais,branchId,invoice});});
}
async function viewPendingSale(button) {
  try {
    const data = await fetchReportData('sale-receipt', {vente_id:button.dataset.saleView});
    const sale = data.sale;
    const rows = data.details.map(item => `<tr><td>${escapeHtml(item.product_name)}</td><td>${Number(item.quantity)}</td><td>${moneyCurrencyLabel(item.unit_price, item.monais)}</td><td>${moneyCurrencyLabel(item.subtotal, item.monais)}</td></tr>`).join('');
    const currencyBalances = Array.isArray(sale.currency_totals) && sale.currency_totals.length ? sale.currency_totals : [sale];
    const due = currencyBalances.map(balance => moneyCurrencyLabel(Math.max(0, Number(balance.total_amount) - Number(balance.amount_paid)), balance.monais)).join(' · ');
    const modal = document.createElement('div');
    modal.className = 'entity-modal';
    modal.innerHTML = `<section class="entity-dialog"><h2>Vente ${escapeHtml(sale.invoice_no)}</h2><p class="panel-subtitle">${escapeHtml(sale.client_name || 'Client comptoir')} · ${escapeHtml(dateLabel(sale.sale_date))}</p><div style="overflow:auto"><table class="data-table"><thead><tr><th>Article</th><th>Quantité</th><th>Prix</th><th>Total</th></tr></thead><tbody>${rows}</tbody></table></div><p><strong>Total par monnaie :</strong> ${saleCurrencyAmounts(sale,'total_amount')}<br><strong>Déjà payé :</strong> ${saleCurrencyAmounts(sale,'amount_paid')}<br><strong>Reste à payer :</strong> ${due}</p><div class="entity-modal-actions"><button type="button" class="modal-cancel">Fermer</button></div></section>`;
    document.body.appendChild(modal);
    modal.querySelector('.modal-cancel').addEventListener('click', () => modal.remove());
  } catch (error) {
    showToast(error.message);
  }
}
async function printSaleInvoice(button){
  const printWindow=window.open('','_blank');if(!printWindow){showToast('Autorisez les fenêtres contextuelles pour imprimer la facture.');return;}
  try{
    const data=await fetchReportData('sale-receipt',{vente_id:button.dataset.saleInvoice});
    const sale=data.sale;
    const rows=data.details.map(row=>{
      const unit=row.unit_symbol||row.unit_name||'';
      const discount=Number(row.discount_amount||0);
      return `<tr><td>${escapeHtml(row.sku)}</td><td>${escapeHtml(row.product_name)}</td><td>${Number(row.quantity)} ${escapeHtml(unit)}</td><td>${moneyCurrencyLabel(row.unit_price,row.monais)}</td><td>${discount>0?moneyCurrencyLabel(discount,row.monais):'—'}</td><td>${moneyCurrencyLabel(row.subtotal,row.monais)}</td></tr>`;
    }).join('');
    const due=(sale.currency_totals||[]).map(balance=>moneyCurrencyLabel(Math.max(0,Number(balance.total_amount)-Number(balance.amount_paid)),balance.monais)).join(' · ')||moneyCurrencyLabel(Math.max(0,Number(sale.total_amount)-Number(sale.amount_paid)),sale.monais);
    const content=`<p><strong>Facture :</strong> ${escapeHtml(sale.invoice_no)} · <strong>Date :</strong> ${escapeHtml(dateLabel(sale.sale_date))}</p><p><strong>Client :</strong> ${escapeHtml(sale.client_name||'Client comptoir')} · <strong>Succursale :</strong> ${escapeHtml(sale.branch_name)} · <strong>Vendeur :</strong> ${escapeHtml(sale.cashier||'—')}</p><table class="report-table"><thead><tr><th>Référence</th><th>Produit</th><th>Quantité</th><th>Prix de vente</th><th>Réduction</th><th>Total ligne</th></tr></thead><tbody>${rows}</tbody></table><h2>Totaux facture : ${saleCurrencyAmounts(sale,'total_amount')}</h2><p><strong>Montants payés :</strong> ${saleCurrencyAmounts(sale,'amount_paid')} · <strong>Restes à payer :</strong> ${due}</p><p><strong>Statut :</strong> ${escapeHtml(sale.status)}</p>`;
    printReportInWindow(printWindow,`Facture ${sale.invoice_no}`,content);
  }catch(error){printWindow.close();showToast(`Impression de la facture impossible : ${error.message}`);}
}
async function printSalePaymentReceipt(button){
  const printWindow=window.open('','_blank');if(!printWindow){showToast('Autorisez les fenêtres contextuelles pour imprimer le reçu.');return;}
  try{
    const saleId=Number(button.dataset.salePaymentReceipt);
    const amount=Number(button.dataset.salePaymentAmount);
    if(saleId<1||amount<=0)throw new Error('Les informations de ce paiement sont invalides.');
    const data=await fetchReportData('sale-receipt',{vente_id:saleId});
    const sale=data.sale;
    const currency=button.dataset.salePaymentCurrency||sale.monais||'';
    const currencyBalances=Array.isArray(sale.currency_totals)&&sale.currency_totals.length?sale.currency_totals:[sale];
    const balanceRows=currencyBalances.map(balance=>{
      const balanceCurrency=balance.monais||'';
      const currencyTotal=Number(balance.total_amount||0);
      const currencyPaid=Number(balance.amount_paid||0);
      const due=Math.max(0,currencyTotal-currencyPaid);
      return `<tr><td>${escapeHtml(balanceCurrency)}</td><td>${moneyCurrencyLabel(currencyTotal,balanceCurrency)}</td><td>${moneyCurrencyLabel(currencyPaid,balanceCurrency)}</td><td>${moneyCurrencyLabel(due,balanceCurrency)}</td></tr>`;
    }).join('');
    const payments=data.payments||[];
    const paymentRows=payments.map(payment=>{const invoiceCurrency=payment.monais_facture||payment.monais;const converted=invoiceCurrency!==payment.monais;const rate=Number(payment.exchange_rate||1);const inverse=rate>0?1/rate:0;return `<tr><td>${escapeHtml(dateLabel(payment.payment_date))}</td><td>${escapeHtml(payment.payment_type==='REFUND'?'Remboursement':'Paiement')}</td><td>${escapeHtml(payment.payment_mode||'—')}</td><td>${escapeHtml(payment.reference||'—')}</td><td>${moneyCurrencyLabel(payment.amount,payment.monais)}${converted?`<br><small>Imputé : ${moneyCurrencyLabel(payment.amount_applied??payment.amount,invoiceCurrency)} · Taux : 1 ${escapeHtml(payment.monais)} = ${rate.toLocaleString('fr-FR',{maximumFractionDigits:10})} ${escapeHtml(invoiceCurrency)} · Inverse : ${inverse.toLocaleString('fr-FR',{maximumFractionDigits:10})} ${escapeHtml(payment.monais)} = 1 ${escapeHtml(invoiceCurrency)}</small>`:''}</td></tr>`;}).join('');
    const selectedPayment=payments.find(payment=>Number(payment.paiement_id)===Number(button.dataset.salePaymentId));
    const selectedInvoiceCurrency=selectedPayment?.monais_facture||selectedPayment?.monais||currency;
    const selectedAmountApplied=Number(selectedPayment?.amount_applied??amount);
    const selectedRate=Number(selectedPayment?.exchange_rate||1);
    const inverseSelectedRate=selectedRate>0?1/selectedRate:0;
    const conversionSummary=selectedInvoiceCurrency!==currency?`<p><strong>Montant imputé à la facture :</strong> ${moneyCurrencyLabel(selectedAmountApplied,selectedInvoiceCurrency)} · <strong>Taux appliqué :</strong> 1 ${escapeHtml(currency)} = ${selectedRate.toLocaleString('fr-FR',{maximumFractionDigits:10})} ${escapeHtml(selectedInvoiceCurrency)} · <strong>Inverse :</strong> ${inverseSelectedRate.toLocaleString('fr-FR',{maximumFractionDigits:10})} ${escapeHtml(currency)} = 1 ${escapeHtml(selectedInvoiceCurrency)}</p>`:'';
    const receiptNumber=button.dataset.salePaymentNumber||`${sale.invoice_no}-${String(button.dataset.salePaymentDate||'').replace(/\D/g,'')}`;
    const reference=button.dataset.salePaymentReference;
    const content=`<section><h2>REÇU DE PAIEMENT</h2><p><strong>Reçu n° :</strong> ${escapeHtml(receiptNumber)}</p><p><strong>Date :</strong> ${escapeHtml(dateLabel(button.dataset.salePaymentDate||new Date().toISOString()))}</p><p><strong>Facture :</strong> ${escapeHtml(sale.invoice_no)}</p><p><strong>Client :</strong> ${escapeHtml(sale.client_name||'Client comptoir')}</p><p><strong>Succursale :</strong> ${escapeHtml(sale.branch_name)}</p><p><strong>Caissier :</strong> ${escapeHtml(sale.cashier||'—')}</p><p><strong>Mode de paiement :</strong> ${escapeHtml(button.dataset.salePaymentMode||'Caisse')}</p>${reference?`<p><strong>Référence de paiement :</strong> ${escapeHtml(reference)}</p>`:''}<h2>Montant reçu : ${moneyCurrencyLabel(amount,currency)}</h2>${conversionSummary}<h3>Situation de la facture par monnaie</h3><table class="report-table"><thead><tr><th>Monnaie</th><th>Total facture</th><th>Total payé</th><th>Reste dû</th></tr></thead><tbody>${balanceRows}</tbody></table>${paymentRows?`<h3>Historique des règlements</h3><table class="report-table"><thead><tr><th>Date</th><th>Opération</th><th>Mode</th><th>Référence</th><th>Montant</th></tr></thead><tbody>${paymentRows}</tbody></table>`:''}</section>`;
    printReportInWindow(printWindow,`Reçu de paiement ${sale.invoice_no}`,content,'','portrait',true);
  }catch(error){printWindow.close();showToast(`Impression du reçu impossible : ${error.message}`);}
}
async function printSaleReceipt(button){
  const printWindow=window.open('','_blank');if(!printWindow){showToast('Autorisez les fenêtres contextuelles pour imprimer le reçu.');return;}
  try {
    const data=await fetchReportData('sale-receipt',{vente_id:button.dataset.saleReceipt});
    const sale=data.sale;
    const payments=data.payments||[];
    const paymentSummary=payments.length?`<h2>Règlements reçus</h2><table class="report-table"><thead><tr><th>Date</th><th>Mode</th><th>Référence</th><th>Montant</th></tr></thead><tbody>${payments.map(payment=>{const invoiceCurrency=payment.monais_facture||payment.monais;const converted=invoiceCurrency!==payment.monais;const rate=Number(payment.exchange_rate||1);const inverse=rate>0?1/rate:0;return `<tr><td>${escapeHtml(dateLabel(payment.payment_date))}</td><td>${escapeHtml(payment.payment_type==='REFUND'?`Remboursement — ${payment.payment_mode}`:payment.payment_mode)}</td><td>${escapeHtml(payment.reference||'—')}</td><td>${moneyCurrencyLabel(payment.amount,payment.monais)}${converted?`<br><small>Imputé : ${moneyCurrencyLabel(payment.amount_applied??payment.amount,invoiceCurrency)} · Taux : 1 ${escapeHtml(payment.monais)} = ${rate.toLocaleString('fr-FR',{maximumFractionDigits:10})} ${escapeHtml(invoiceCurrency)} · Inverse : ${inverse.toLocaleString('fr-FR',{maximumFractionDigits:10})} ${escapeHtml(payment.monais)} = 1 ${escapeHtml(invoiceCurrency)}</small>`:''}</td></tr>`;}).join('')}</tbody></table>`:'';
    const rows=data.details.map(row=>{const unit=row.unit_symbol||row.unit_name||'';return `<tr><td>${escapeHtml(row.sku)}</td><td>${escapeHtml(row.product_name)}</td><td>${Number(row.quantity)} ${escapeHtml(unit)}</td><td>${moneyCurrencyLabel(row.unit_price,row.monais)}</td><td>${Number(row.discount_percent)>0?moneyCurrencyLabel(row.discount_amount,row.monais):'—'}</td><td>${moneyCurrencyLabel(row.subtotal,row.monais)}</td></tr>`;}).join('');
    const balances=sale.currency_totals||[];
    const due=balances.map(balance=>moneyCurrencyLabel(Math.max(0,Number(balance.total_amount)-Number(balance.amount_paid)),balance.monais)).join(' · ')||moneyCurrencyLabel(Math.max(0,Number(sale.total_amount)-Number(sale.amount_paid)),sale.monais);
    const content=`<p><strong>Facture :</strong> ${escapeHtml(sale.invoice_no)} · <strong>Date :</strong> ${escapeHtml(dateLabel(sale.sale_date))}</p><p><strong>Client :</strong> ${escapeHtml(sale.client_name||'Client comptoir')} · <strong>Succursale :</strong> ${escapeHtml(sale.branch_name)} · <strong>Caissier :</strong> ${escapeHtml(sale.cashier||'—')}</p><table class="report-table"><thead><tr><th>Référence</th><th>Produit</th><th>Quantité</th><th>Prix unitaire</th><th>Réduction</th><th>Total ligne</th></tr></thead><tbody>${rows}</tbody></table><h2>Totaux facture : ${saleCurrencyAmounts(sale,'total_amount')}</h2><p><strong>Montants payés :</strong> ${saleCurrencyAmounts(sale,'amount_paid')} · <strong>Restes à payer :</strong> ${due}</p><p><strong>Statut :</strong> ${escapeHtml(sale.status)}</p>${paymentSummary}`;
    printReportInWindow(printWindow,`Reçu de vente — ${sale.invoice_no}`,content,'Les marchandises vendues ne peuvent pas être reprises.');
  }catch(error){printWindow.close();showToast(`Impression du reçu impossible : ${error.message}`);}
}
async function printStockCard(button) {
  const printWindow = window.open('', '_blank');
  if (!printWindow) { showToast('Autorisez les fenêtres contextuelles pour imprimer la fiche de stock.'); return; }
  try {
    const select = document.getElementById('stock-branch');
    const branchId = select?.value || (sessionUser?.succursale_id && !sessionUser?.is_company_admin ? sessionUser.succursale_id : '');
    const params = {produit_id:button.dataset.stockCard};
    const filters = reportFilterValues();
    if (filters.from) params.date_debut = filters.from;
    if (filters.to) params.date_fin = filters.to;
    if (filters.search) params.recherche = filters.search;
    if (branchId) params.succursale_id = branchId;
    const data = await fetchReportData('stock-card', params);
    const product = data.product;
    const unit = product.unit_abbreviation || product.unit_name || '';
    const movements = data.movements;
    const entries = movements.filter(row => row.movement_type === 'ENTREE');
    const exits = movements.filter(row => row.movement_type === 'SORTIE');
    const movementTotals = rows => rows.reduce((total, row) => {
      const quantity = Number(row.quantity_moved || 0);
      total.quantity += quantity;
      total.amount += quantity * Number(row.unit_cost ?? product.cost_price ?? 0);
      return total;
    }, {quantity:0, amount:0});
    const entryTotals = movementTotals(entries);
    const exitTotals = movementTotals(exits);
    const periodStart = filters.from || movements[0]?.movement_date?.slice(0, 10);
    const periodEnd = filters.to || movements[movements.length - 1]?.movement_date?.slice(0, 10);
    const periodDays = periodStart && periodEnd
      ? Math.max(1, Math.floor((Date.parse(`${periodEnd}T00:00:00Z`) - Date.parse(`${periodStart}T00:00:00Z`)) / 86400000) + 1)
      : 1;
    const averageConsumption = exitTotals.quantity / periodDays;
    const minimumStock = data.balances.reduce((sum, row) => sum + Number(row.min_stock_level || 0), 0);
    const movementRows = movements;
    const pageGroups = [];
    let movementOffset = 0;
    while (movementOffset < movementRows.length) {
      const pageSize = pageGroups.length === 0 ? 8 : 18;
      pageGroups.push(movementRows.slice(movementOffset, movementOffset + pageSize));
      movementOffset += pageSize;
    }
    if (!pageGroups.length) pageGroups.push([]);
    const totalsForRows = rows => rows.reduce((totals, row) => {
      if (row.movement_type !== 'ENTREE' && row.movement_type !== 'SORTIE') return totals;
      const quantity = Number(row.quantity_moved || 0);
      const amount = quantity * Number(row.unit_cost ?? product.cost_price ?? 0);
      const movementKind = row.movement_type === 'ENTREE' ? 'entries' : 'exits';
      totals[movementKind].quantity += quantity;
      totals[movementKind].amount += amount;
      return totals;
    }, {entries:{quantity:0, amount:0}, exits:{quantity:0, amount:0}});
    const formatRunningTotals = totals => `Entrées : ${totals.entries.quantity.toLocaleString('fr-FR')} ${escapeHtml(unit)} · ${escapeHtml(moneyCurrencyLabel(totals.entries.amount, product.monais))} | Sorties : ${totals.exits.quantity.toLocaleString('fr-FR')} ${escapeHtml(unit)} · ${escapeHtml(moneyCurrencyLabel(totals.exits.amount, product.monais))}`;
    let runningTotals = {entries:{quantity:0, amount:0}, exits:{quantity:0, amount:0}};
    const pageSections = pageGroups.map((pageRows, pageIndex) => {
      const pageTotals = totalsForRows(pageRows);
      const previousTotals = runningTotals;
      runningTotals = {
        entries:{quantity:previousTotals.entries.quantity + pageTotals.entries.quantity, amount:previousTotals.entries.amount + pageTotals.entries.amount},
        exits:{quantity:previousTotals.exits.quantity + pageTotals.exits.quantity, amount:previousTotals.exits.amount + pageTotals.exits.amount}
      };
      const firstPage = pageIndex === 0;
      const lastPage = pageIndex === pageGroups.length - 1;
      const rowsMarkup = pageRows.map(row => {
        const quantity = Number(row.quantity_moved || 0);
        const amount = quantity * Number(row.unit_cost ?? product.cost_price ?? 0);
        return `<tr><td>${escapeHtml(row.reference_id ? `#${Number(row.reference_id)}` : row.reference_type || '—')}</td><td>${escapeHtml(row.note || '—')}</td><td>${escapeHtml(dateLabel(row.movement_date))}</td><td>${quantity} ${escapeHtml(unit)}</td><td>${row.movement_type === 'SORTIE' ? `${quantity} ${escapeHtml(unit)}` : '—'}</td><td>${row.movement_type === 'ENTREE' ? `${quantity} ${escapeHtml(unit)}` : '—'}</td><td>${Number(row.quantity_after)} ${escapeHtml(unit)}</td><td>${escapeHtml(moneyCurrencyLabel(row.unit_cost ?? product.cost_price, product.monais))}</td><td>${escapeHtml(moneyCurrencyLabel(amount, product.monais))}</td><td>${escapeHtml(row.movement_type)}</td></tr>`;
      }).join('') || '<tr><td colspan="10">Aucun mouvement historique enregistré depuis l’activation du suivi.</td></tr>';
      const carryover = firstPage ? '' : `<p class="stock-carryover"><strong>Cumul reporté des pages précédentes :</strong> ${formatRunningTotals(previousTotals)}</p>`;
      const summary = firstPage ? `<p><strong>Produit :</strong> ${escapeHtml(product.name)} · <strong>Référence :</strong> ${escapeHtml(product.sku)} · <strong>Unité :</strong> ${escapeHtml(unit || '—')}</p><div class="dashboard-grid"><div class="stat-card"><span class="stat-label">Consommation moyenne / jour</span><div class="stat-value">${averageConsumption.toLocaleString('fr-FR', {maximumFractionDigits:2})} ${escapeHtml(unit)}</div></div><div class="stat-card"><span class="stat-label">Stock maximum observé</span><div class="stat-value">${Number(data.stock_max || 0).toLocaleString('fr-FR')} ${escapeHtml(unit)}</div></div><div class="stat-card"><span class="stat-label">Stock minimum (seuil configuré)</span><div class="stat-value">${minimumStock.toLocaleString('fr-FR')} ${escapeHtml(unit)}</div></div></div><p class="report-note">Les stocks antérieurs à l’activation du suivi figurent dans la situation actuelle, sans détail. Le maximum est calculé sur l’historique disponible; le minimum correspond au seuil configuré.</p>` : `<p><strong>Fiche de stock — ${escapeHtml(product.name)} (${escapeHtml(product.sku)})</strong></p>`;
      const overallTotals = lastPage ? `<h2>Total général</h2><table class="report-table stock-grand-total" data-skip-report-totals="true"><thead><tr><th>Type</th><th>Quantité totale</th><th>Valeur totale au coût d’achat</th></tr></thead><tbody><tr><td>Entrées</td><td>${entryTotals.quantity.toLocaleString('fr-FR')} ${escapeHtml(unit)}</td><td>${escapeHtml(moneyCurrencyLabel(entryTotals.amount, product.monais))}</td></tr><tr><td>Sorties</td><td>${exitTotals.quantity.toLocaleString('fr-FR')} ${escapeHtml(unit)}</td><td>${escapeHtml(moneyCurrencyLabel(exitTotals.amount, product.monais))}</td></tr><tr class="report-total-row"><td>Cumul des entrées + sorties</td><td>${(entryTotals.quantity + exitTotals.quantity).toLocaleString('fr-FR')} ${escapeHtml(unit)}</td><td>${escapeHtml(moneyCurrencyLabel(entryTotals.amount + exitTotals.amount, product.monais))}</td></tr></tbody></table>` : '';
      return `<section class="stock-card-page${firstPage ? ' stock-card-page--first' : ''}"><div class="stock-card-page-content stock-card-report">${summary}${carryover}<h2>Historique des mouvements${firstPage ? '' : ' (suite)'}</h2><table class="report-table" data-skip-report-totals="true"><thead><tr><th>Référence</th><th>Motif</th><th>Date</th><th>Quantité</th><th>Quantité sortie</th><th>Quantité entrée</th><th>Solde du stock</th><th>Coût unitaire</th><th>Total mouvement</th><th>Statut</th></tr></thead><tbody>${rowsMarkup}</tbody></table></div><footer class="stock-page-footer"><p><strong>Sous-total page ${pageIndex + 1} :</strong> ${formatRunningTotals(pageTotals)}</p><p><strong>Cumul après page ${pageIndex + 1} :</strong> ${formatRunningTotals(runningTotals)}</p>${overallTotals}</footer></section>`;
    }).join('');
    const content = `<div class="stock-card-report">${pageSections}</div>`;
    printReportInWindow(printWindow, `Fiche de stock ${stockReportPeriod(filters, movements)} · ${product.name}`, content, '', 'landscape');
  } catch (error) { printWindow.close(); showToast(error.message); }
}
document.addEventListener('click', async event => {
  const accountingDraftEdit = event.target.closest('[data-accounting-draft-edit]');
  if (accountingDraftEdit) {
    await openAccountingEntryForm(Number(accountingDraftEdit.dataset.accountingDraftEdit));
    return;
  }
  const accountingDraftDelete = event.target.closest('[data-accounting-draft-delete]');
  if (accountingDraftDelete) {
    if (!window.confirm('Supprimer définitivement ce brouillon comptable ?')) return;
    try {
      const response = await fetch(`../backend/public/report-data.php?action=accounting-draft&ecriture_id=${encodeURIComponent(accountingDraftDelete.dataset.accountingDraftDelete)}`, {method: 'DELETE', credentials: 'include'});
      const result = await readJson(response);
      if (!response.ok || !result.success) throw new Error(result.message || 'Suppression du brouillon impossible.');
      await loadAccountingDrafts();
      showToast('Brouillon comptable supprimé.');
    } catch (error) {
      showToast(error.message);
    }
    return;
  }
  const accountingDraftValidate = event.target.closest('[data-accounting-draft-validate]');
  if (accountingDraftValidate) {
    if (!window.confirm('Valider cette écriture la rendra définitive et l’ajoutera aux états comptables. Continuer ?')) return;
    try {
      const response = await fetch('../backend/public/report-data.php?action=accounting-draft-validate', {method: 'POST', headers: {'Content-Type': 'application/json'}, credentials: 'include', body: JSON.stringify({ecriture_id: Number(accountingDraftValidate.dataset.accountingDraftValidate)})});
      const result = await readJson(response);
      if (!response.ok || !result.success) throw new Error(result.message || 'Validation du brouillon impossible.');
      await Promise.all([loadAccountingDrafts(), loadAccountingEntryRows(), loadAccountingReport()]);
      showToast('Brouillon comptable validé.');
    } catch (error) {
      showToast(error.message);
    }
    return;
  }
  const accountingEntryButton = event.target.closest('[data-account-entry-open]');
  if (accountingEntryButton) { await openAccountingEntryForm(); return; }
  const entryCancellationButton = event.target.closest('[data-entry-cancellation-request]');
  if (entryCancellationButton) { openEntryCancellationRequest(Number(entryCancellationButton.dataset.entryCancellationRequest)); return; }
  const cancellationDecisionButton = event.target.closest('[data-entry-cancellation-decision]');
  if (cancellationDecisionButton) {
    const decision = cancellationDecisionButton.dataset.entryCancellationDecision;
    const approve = decision === 'APPROUVER';
    if (!window.confirm(approve ? 'Approuver cette demande annulera définitivement l’écriture des états comptables. Continuer ?' : 'Refuser cette demande d’annulation ?')) return;
    try {
      const response = await fetch('../backend/public/report-data.php?action=accounting-cancellation-decision', {method: 'POST', headers: {'Content-Type': 'application/json'}, credentials: 'include', body: JSON.stringify({demande_id: Number(cancellationDecisionButton.dataset.cancellationRequestId), decision})});
      const result = await readJson(response);
      if (!response.ok || !result.success) throw new Error(result.message || 'Décision impossible.');
      await Promise.all([loadEntryCancellationRequests(), loadAccountingEntryRows()]);
      showToast(approve ? 'Écriture annulée.' : 'Demande refusée.');
    } catch (error) {
      showToast(error.message);
    }
    return;
  }
  const accountingCreateButton = event.target.closest('[data-account-create-open]');
  if (accountingCreateButton) { await openAccountingAccountForm(); return; }
  const accountingEditButton = event.target.closest('[data-account-edit]');
  if (accountingEditButton) { await openAccountingAccountForm(Number(accountingEditButton.dataset.accountEdit)); return; }
  const accountingDeleteButton = event.target.closest('[data-account-delete]');
  if (accountingDeleteButton) {
    if (!window.confirm('Supprimer ce compte comptable ? Les comptes système, parents ou utilisés dans des écritures ne peuvent pas être supprimés.')) return;
    try {
      const response = await fetch(`../backend/public/report-data.php?action=accounting-account&compte_id=${encodeURIComponent(accountingDeleteButton.dataset.accountDelete)}`, {method: 'DELETE', credentials: 'include'});
      const result = await readJson(response);
      if (!response.ok || !result.success) throw new Error(result.message || 'Suppression du compte impossible.');
      await loadAccountingAccounts();
      showToast('Compte comptable supprimé.');
    } catch (error) {
      showToast(error.message);
    }
    return;
  }
  const accountingReportButton = event.target.closest('[data-account-report-load]');
  if (accountingReportButton) { await loadAccountingReport(); return; }
  const accountingPrintButton = event.target.closest('[data-account-report-print]');
  if (accountingPrintButton) {
    const output = document.getElementById('accounting-report-result');
    const content = output?.innerHTML.trim();
    if (!content || output.textContent.trim() === 'Aucun état généré.') return;
    const title = document.getElementById('accounting-report-title')?.textContent || 'État financier';
    const meta = document.getElementById('accounting-report-meta')?.textContent || '';
    await printCurrentReport(title, `<p><strong>Période et monnaie :</strong> ${escapeHtml(meta)}</p>${content}`);
    return;
  }
  const supplierPaymentButton=event.target.closest('[data-supplier-payment]');if(supplierPaymentButton){await openSupplierPayment(supplierPaymentButton);return;}
  const pendingSaleViewButton = event.target.closest('[data-sale-view]');
  if (pendingSaleViewButton) { await viewPendingSale(pendingSaleViewButton); return; }
  const reportAction = event.target.closest('[data-report-action]');
  if (reportAction) {
    if (reportAction.dataset.reportAction === 'preview') openReportPreview();
    if (reportAction.dataset.reportAction === 'print' || reportAction.dataset.reportAction === 'pdf') printCurrentReport();
    if (reportAction.dataset.reportAction === 'excel') exportReportExcel();
    return;
  }
  if (event.target.closest('[data-report-close]')) { event.target.closest('.report-modal')?.remove(); return; }
  const cashSalePayButton=event.target.closest('[data-sale-pay-cash]');if(cashSalePayButton){await confirmSalePayment(cashSalePayButton);return;}
  const saleInvoiceButton=event.target.closest('[data-sale-invoice],[data-sale-receipt]');
  if(saleInvoiceButton){await printSaleInvoice(saleInvoiceButton);return;}
  const salePaymentReceiptButton=event.target.closest('[data-sale-payment-receipt]');
  if(salePaymentReceiptButton){await printSalePaymentReceipt(salePaymentReceiptButton);return;}
  const cashMovementButton=event.target.closest('[data-cash-movement-open]');if(cashMovementButton){openCashMovementForm(cashMovementButton.dataset.cashMovementOpen);return;}
  const cashCancellationRequestButton = event.target.closest('[data-cash-cancellation-request]');
  if (cashCancellationRequestButton) { openCashMovementCancellationRequest(Number(cashCancellationRequestButton.dataset.cashCancellationRequest)); return; }
  const cashCancellationDecisionButton = event.target.closest('[data-cash-cancellation-decision]');
  if (cashCancellationDecisionButton) {
    const decision = cashCancellationDecisionButton.dataset.cashCancellationDecision;
    const approve = decision === 'APPROUVER';
    if (!window.confirm(approve ? 'Approuver cette annulation créera une contre-opération et ajustera le solde de la caisse. Continuer ?' : 'Refuser cette demande d’annulation ?')) return;
    try {
      const response = await fetch('../backend/public/report-data.php?action=cash-cancellation-decision', {method: 'POST', headers: {'Content-Type': 'application/json'}, credentials: 'include', body: JSON.stringify({demande_id: Number(cashCancellationDecisionButton.dataset.cancellationRequestId), decision})});
      const result = await readJson(response);
      if (!response.ok || !result.success) throw new Error(result.message || 'Décision impossible.');
      await Promise.all([loadCashMovementCancellationRequests(), loadCashRows()]);
      showToast(approve ? 'Opération de caisse annulée.' : 'Demande refusée.');
    } catch (error) {
      showToast(error.message);
    }
    return;
  }
  const cashReopenButton=event.target.closest('[data-cash-reopen]');
  if(cashReopenButton){openCashForm({name:cashReopenButton.dataset.cashName,succursale_id:Number(cashReopenButton.dataset.cashBranch),monais:cashReopenButton.dataset.cashCurrency,mode_paiement_id:Number(cashReopenButton.dataset.cashMode),banque_id:Number(cashReopenButton.dataset.cashBank||0)});return;}
  const cashDeleteButton=event.target.closest('[data-cash-delete]');if(cashDeleteButton){if(!window.confirm('Supprimer cette caisse clôturée ? Les caisses avec des opérations ne peuvent pas être supprimées.'))return;try{const response=await fetch('../backend/public/auth.php?action=delete-cash',{method:'POST',headers:{'Content-Type':'application/json'},credentials:'include',body:JSON.stringify({caisse_id:Number(cashDeleteButton.dataset.cashDelete)})});const result=await readJson(response);if(!response.ok||!result.success)throw new Error(result.message||'Suppression impossible.');showToast('Caisse supprimée.');loadCashRows();}catch(error){showToast(error.message);}return;}
  const saleCancelButton=event.target.closest('[data-sale-cancel]');
  if(saleCancelButton){if(!window.confirm('Annuler cette vente ? Le stock sera rétabli et les éventuels paiements régularisés.'))return;try{const response=await fetch('../backend/public/auth.php?action=cancel-sale',{method:'POST',headers:{'Content-Type':'application/json'},credentials:'include',body:JSON.stringify({vente_id:Number(saleCancelButton.dataset.saleCancel)})});const result=await readJson(response);if(!response.ok||!result.success)throw new Error(result.message||'Annulation impossible.');showToast('Vente annulée et stock rétabli.');loadSalesRows();loadPendingSales();loadCashRows();loadStock();}catch(error){showToast(error.message);}return;}
  const cashCloseButton=event.target.closest('[data-cash-close]');
  if(cashCloseButton){const amount=window.prompt('Saisissez le solde compté à la clôture :','0');if(amount===null)return;const closing=Number(amount.replace(',','.'));if(!Number.isFinite(closing)||closing<0){showToast('Saisissez un montant valide.');return;}try{const response=await fetch('../backend/public/auth.php?action=close-cash',{method:'POST',headers:{'Content-Type':'application/json'},credentials:'include',body:JSON.stringify({caisse_id:Number(cashCloseButton.dataset.cashClose),solde_fermeture:closing})});const result=await readJson(response);if(!response.ok||!result.success)throw new Error(result.message||'Clôture impossible.');showToast('Caisse clôturée.');loadCashRows();}catch(error){showToast(error.message);}return;}
  const cancelPurchaseButton = event.target.closest('[data-purchase-cancel]');
  const validatePurchaseButton = event.target.closest('[data-purchase-validate]');
  if (cancelPurchaseButton || validatePurchaseButton) {
    const purchaseId = Number(cancelPurchaseButton?.dataset.purchaseCancel || validatePurchaseButton?.dataset.purchaseValidate);
    const nextStatus = cancelPurchaseButton ? 'CANCELLED' : 'RECEIVED';
    if (!window.confirm(cancelPurchaseButton ? 'Annuler cet approvisionnement ?' : 'Valider cet approvisionnement et appliquer le mouvement au stock ?')) return;
    try {
      const response = await fetch('../backend/public/auth.php?action=update-purchase-status', {method:'PATCH', headers:{'Content-Type':'application/json'}, credentials:'include', body:JSON.stringify({achat_id:purchaseId, status:nextStatus})});
      const result = await readJson(response);
      if (!response.ok || !result.success) throw new Error(result.message || 'Modification du statut impossible.');
      showToast('Statut de l’approvisionnement modifié.');
      loadPurchaseRows();
      loadStock();
    } catch (error) { showToast(error.message); loadPurchaseRows(); }
    return;
  }
  const purchaseVoucherButton = event.target.closest('[data-purchase-voucher]');
  if (purchaseVoucherButton) { await printPurchaseVoucher(purchaseVoucherButton); return; }
  const stockCardButton = event.target.closest('[data-stock-card]');
  if (stockCardButton) { await printStockCard(stockCardButton); return; }
  const stockSectionButton = event.target.closest('[data-stock-section]');
  if (stockSectionButton) { selectStockSection(stockSectionButton.dataset.stockSection); return; }
  const toggleCategories = event.target.closest('[data-toggle-categories]');
  if (toggleCategories) {
    selectStockSection('categories');
    renderCategoryRows();
    return;
  }
  if (event.target.closest('[data-create-supplier]')) { openEntityForm('supplier'); return; }
  if (event.target.closest('[data-create-purchase]')) { openEntityForm('purchase'); return; }
  const unitEdit = event.target.closest('[data-unit-edit]');
  if (unitEdit) {
    const units = await apiGet('unites_mesure');
    const unit = units.find(item => Number(item.unite_mesure_id) === Number(unitEdit.dataset.unitEdit));
    if (unit) openEntityForm('unit', unit);
    return;
  }
  const unitDelete = event.target.closest('[data-unit-delete]');
  if (unitDelete) {
    await deleteResource('unites_mesure', unitDelete.dataset.unitDelete, 'cette unité', async () => {
      await loadStock();
      await refreshUnitManager?.();
    });
    return;
  }
  const productEdit = event.target.closest('[data-product-edit]');
  if (productEdit) { const row = stockData.products.find(item => Number(item.produit_id) === Number(productEdit.dataset.productEdit)); if (row) openEntityForm('product', row); return; }
  const productDelete = event.target.closest('[data-product-delete]');
  if (productDelete) { await deleteResource('produits', productDelete.dataset.productDelete, 'ce produit', loadStock); return; }
  const categoryEdit = event.target.closest('[data-category-edit]');
  if (categoryEdit) { const row = stockData.categories.find(item => Number(item.category_id) === Number(categoryEdit.dataset.categoryEdit)); if (row) openEntityForm('category', row); return; }
  const categoryDelete = event.target.closest('[data-category-delete]');
  if (categoryDelete) { await deleteResource('categories', categoryDelete.dataset.categoryDelete, 'cette catégorie', loadStock); return; }
  const branchEdit = event.target.closest('[data-branch-edit]');
  if (branchEdit) { const rows = await apiGet('succursales'); const row = rows.find(item => Number(item.succursale_id) === Number(branchEdit.dataset.branchEdit)); if (row) openEntityForm('branch', row); return; }
  const branchDelete = event.target.closest('[data-branch-delete]');
  if (branchDelete) { await deleteResource('succursales', branchDelete.dataset.branchDelete, 'cette succursale', () => loadSimpleRows('succursales', 'branch-rows', 6, row => `<tr><td>${escapeHtml(row.name)}</td><td>${escapeHtml(row.code)}</td><td>${Number(row.est_sucursal_mere) ? '<span class="status success">Principale</span>' : '—'}</td><td>${escapeHtml(row.address || '—')}</td><td>${escapeHtml(row.phone || '—')}</td><td><button class="text-button" data-branch-edit="${Number(row.succursale_id)}">Modifier</button> <button class="text-button" data-branch-delete="${Number(row.succursale_id)}">Supprimer</button></td></tr>`, 'Aucune succursale enregistrée.')); return; }
  const supplierEdit = event.target.closest('[data-supplier-edit]');
  if (supplierEdit) { const rows = await apiGet('fournisseurs'); const supplier = rows.find(item => Number(item.fournisseur_id) === Number(supplierEdit.dataset.supplierEdit)); if (supplier) openEntityForm('supplier', supplier); return; }
  const supplierDelete = event.target.closest('[data-supplier-delete]');
  if (supplierDelete) { await deleteResource('fournisseurs', supplierDelete.dataset.supplierDelete, 'ce fournisseur', loadSupplierRows); return; }
  const roleEdit = event.target.closest('[data-role-edit]');
  if (roleEdit) { const role = roleData.find(item => Number(item.role_id) === Number(roleEdit.dataset.roleEdit)); if (role) openEntityForm('role', role); return; }
  const roleDelete = event.target.closest('[data-role-delete]');
  if (roleDelete) {
    if (!window.confirm('Supprimer ce rôle ? Un rôle encore assigné à des utilisateurs ne pourra pas être supprimé.')) return;
    try {
      const response = await fetch(`../backend/public/auth.php?action=delete-role&id=${encodeURIComponent(roleDelete.dataset.roleDelete)}`, {method:'DELETE', credentials:'include'});
      const result = await readJson(response);
      if (!response.ok || !result.success) throw new Error(result.message || 'Suppression du rôle impossible.');
      if (!result.data.deleted) throw new Error('Rôle introuvable.');
      showToast('Rôle supprimé.'); loadRoleList();
    } catch (error) { showToast(error.message); }
    return;
  }
  const userEdit = event.target.closest('[data-user-edit]');
  if (userEdit) { const user = userData.find(item => Number(item.user_id) === Number(userEdit.dataset.userEdit)); if (user) openEntityForm('user', user); return; }
  const userDelete = event.target.closest('[data-user-delete]');
  if (userDelete) {
    if (!window.confirm('Supprimer cet utilisateur ? Ses ventes ou achats existants peuvent empêcher la suppression.')) return;
    try {
      const response = await fetch(`../backend/public/auth.php?action=delete-user&id=${encodeURIComponent(userDelete.dataset.userDelete)}`, {method:'DELETE', credentials:'include'});
      const result = await readJson(response);
      if (!response.ok || !result.success) throw new Error(result.message || 'Suppression de l’utilisateur impossible.');
      if (!result.data.deleted) throw new Error('Utilisateur introuvable.');
      showToast('Utilisateur supprimé.'); loadUserRows();
    } catch (error) { showToast(error.message); }
    return;
  }
});
document.addEventListener('input', event => {
  if (event.target.matches('[data-report-from],[data-report-to],[data-report-search]')) filterCurrentReport();
});
document.addEventListener('change', event => {
  if (event.target.matches('#accounting-report-type, #accounting-from, #accounting-to, #accounting-currency, #accounting-account')) {
    const printButton = document.querySelector('[data-account-report-print]');
    if (printButton) printButton.disabled = true;
  }
  if (event.target.matches('#accounting-report-type')) {
    toggleAccountingAccountFilter();
  }
  if (event.target.matches('#accounting-from, #accounting-to, #accounting-currency')) {
    loadAccountingEntryRows();
  }
});
document.addEventListener('submit', async event => {
  const companyForm = event.target.closest('#company-profile-form');
  if (!companyForm) return;
  event.preventDefault();
  const submitButton = companyForm.querySelector('button[type="submit"],button:not([type])');
  if (submitButton) submitButton.disabled = true;
  try {
    const response = await fetch('../backend/public/auth.php?action=company-profile', {
      method: 'POST',
      credentials: 'include',
      body: new FormData(companyForm)
    });
    const result = await readJson(response);
    if (!response.ok || !result.success) throw new Error(result.message || 'Enregistrement du profil entreprise impossible.');
    sessionUser = result.data;
    document.querySelectorAll('[data-session-enterprise],[data-context-company],[data-enterprise-name],[data-settings-company]').forEach(node => {
      node.textContent = sessionUser.enterprise_name || '—';
    });
    showToast('Profil entreprise enregistré.');
    renderView('settings');
  } catch (error) {
    showToast(error.message);
  } finally {
    if (submitButton) submitButton.disabled = false;
  }
});
document.addEventListener('submit', async event => {
  const profileForm = event.target.closest('#profile-form');
  const passwordForm = event.target.closest('#password-form');
  if (!profileForm && !passwordForm) return;
  event.preventDefault();
  try {
    const isProfile = Boolean(profileForm);
    const response = await fetch(`../backend/public/auth.php?action=${isProfile ? 'profile' : 'change-password'}`, {
      method: isProfile ? 'PATCH' : 'POST',
      headers: {'Content-Type': 'application/json'},
      credentials: 'include',
      body: JSON.stringify(Object.fromEntries(new FormData(event.target)))
    });
    const result = await readJson(response);
    if (!response.ok || !result.success) throw new Error(result.message || 'Enregistrement impossible.');
    if (isProfile) {
      sessionUser = result.data;
      await loadSession();
      showToast('Profil mis à jour.');
    } else {
      passwordForm.reset();
      showToast('Mot de passe modifié.');
    }
  } catch (error) { showToast(error.message); }
});
action.addEventListener('click', () => { if (currentViewName === 'stock') openEntityForm('product'); else if (currentViewName === 'users') openEntityForm('user'); else if (currentViewName === 'branches') openEntityForm('branch'); else if (currentViewName === 'procurement') openEntityForm('purchase'); else if (currentViewName === 'sales') openSaleForm(); else if (currentViewName === 'cash') openCashForm(); else if (action.textContent.trim()) showToast(`${action.textContent.trim()} : fenêtre prête à être connectée`); });
document.addEventListener('change', event => {
  const pageSizeSelect = event.target.closest('[data-page-size-key]');
  if (!pageSizeSelect) return;
  const pageSize = Number(pageSizeSelect.value);
  if (!PAGE_SIZE_OPTIONS.includes(pageSize)) return;
  PAGE_SIZE = pageSize;
  localStorage.setItem('alba-stock-page-size', String(pageSize));
  paginationLoaders.get(pageSizeSelect.dataset.pageSizeKey)?.(1);
});
document.addEventListener('click', event => { const pageButton = event.target.closest('[data-page-key]'); if (pageButton && !pageButton.disabled) { const loader = paginationLoaders.get(pageButton.dataset.pageKey); if (loader) loader(Number(pageButton.dataset.page)); return; } if (event.target.closest('[data-create-role]')) openEntityForm('role'); if (event.target.closest('[data-create-category]')) openEntityForm('category'); if (event.target.closest('[data-create-unit]') && sessionUser?.is_company_admin) openUnitManager(); if (event.target.closest('[data-stock-movement-report]')) openStockMovementsReport(); });
document.addEventListener('click', event => { if (event.target.closest('.text-button') && !event.target.closest('[data-product-edit],[data-product-delete],[data-category-edit],[data-category-delete],[data-branch-edit],[data-branch-delete],[data-stock-edit],[data-stock-card],[data-role-edit],[data-role-delete],[data-user-edit],[data-user-delete],[data-stock-section],[data-toggle-categories],[data-create-unit],[data-create-category],[data-create-supplier],[data-create-purchase],[data-supplier-edit],[data-supplier-delete],[data-purchase-voucher],[data-report-action],[data-report-close],[data-bank-form-open],[data-account-create-open],[data-account-edit],[data-account-delete],[data-account-report-print],#accounting-entry-add-line,#purchase-add-supplier')) showToast('Rapport mis à jour'); });
document.addEventListener('click', event => {
  const stockButton = event.target.closest('[data-stock-edit]');
  if (stockButton) {
    const branchId = document.getElementById('stock-branch').value || sessionUser?.succursale_id;
    if (!branchId) { showToast('Choisissez une succursale pour ajuster son stock.'); return; }
    const productId = Number(stockButton.dataset.stockEdit);
    const stock = stockData.stocks.find(item => Number(item.produit_id) === productId && Number(item.succursale_id) === Number(branchId));
    const unit = stock?.unit_abbreviation || stock?.unit_name || '';
    const nextQuantity = window.prompt(`Nouvelle quantité en stock${unit ? ` (${unit})` : ''} :`, String(stock?.quantity ?? 0));
    if (nextQuantity === null) return;
    if (!/^\d+$/.test(nextQuantity)) { showToast('Saisissez une quantité entière positive ou nulle.'); return; }
    const payload = {produit_id:productId, succursale_id:Number(branchId), operation:'set', quantity:Number(nextQuantity), min_stock_level:Number(stock?.min_stock_level ?? 5)};
    fetch('../backend/public/stock.php', {method:'POST', headers:{'Content-Type':'application/json'}, credentials:'include', body:JSON.stringify(payload)})
      .then(async response => { const result = await readJson(response); if (!response.ok || !result.success) throw new Error(result.message || 'Mise à jour impossible.'); showToast('Stock mis à jour.'); await loadStock(); })
      .catch(error => showToast(error.message));
    return;
  }
  const acceptButton = event.target.closest('[data-accept-request]');
  if (!acceptButton) return;
  const requestId = acceptButton.dataset.acceptRequest;
  const row = document.querySelector(`[data-request-row="${requestId}"]`);
  if (!row) return;
  acceptButton.outerHTML = '<span class="status success">Commande confirmée</span>';
  row.querySelector('td:first-child small').textContent = 'Commande créée';
  showToast(`${requestId} est devenue une commande`);
});
document.getElementById('mobile-menu').addEventListener('click', () => document.getElementById('sidebar').classList.toggle('open'));
themeButton.addEventListener('click', event => { event.stopPropagation(); const isOpen = themePanel.classList.toggle('open'); themeButton.setAttribute('aria-expanded', isOpen); });
themeChoices.forEach(option => option.addEventListener('click', () => { localStorage.setItem(themeStorageKey, option.dataset.themeChoice); applyTheme(option.dataset.themeChoice); themePanel.classList.remove('open'); themeButton.setAttribute('aria-expanded', 'false'); showToast(`Thème ${option.textContent.trim()} activé`); }));
document.addEventListener('click', event => { if (!event.target.closest('.theme-control')) { themePanel.classList.remove('open'); themeButton.setAttribute('aria-expanded', 'false'); } });
setInterval(()=>{if(currentViewName==='cash'&&hasAccess('modifier_caisse'))loadPendingSales();},20000);
window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => { if ((localStorage.getItem(themeStorageKey) || 'light') === 'auto') applyTheme('auto'); });
window.addEventListener('hashchange', () => renderView(routeFromHash()));
loadTheme();
navigate(routeFromHash(), true);
loadSession();

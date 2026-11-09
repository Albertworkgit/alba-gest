const enterpriseList = document.getElementById('enterprise-list');
const registrationNotificationForm = document.getElementById('registration-notification-form');
const superAdminList = document.getElementById('super-admin-list');
const superAdminForm = document.getElementById('super-admin-form');
const superAdminPagination = document.getElementById('super-admin-pagination');
const superAdminEditModal = document.getElementById('super-admin-edit-modal');
const superAdminEditForm = document.getElementById('super-admin-edit-form');
const moduleAccessForm = document.getElementById('module-access-form');
const moduleAccessEnterprise = document.getElementById('module-access-enterprise');
const moduleAccessList = document.getElementById('module-access-list');
const currencyList = document.getElementById('currency-list');
const currencyForm = document.getElementById('currency-form');
const currencyCancel = document.getElementById('currency-cancel');
const datasetForm = document.getElementById('dataset-form');
const datasetList = document.getElementById('dataset-list');
const datasetItemRows = document.getElementById('dataset-item-rows');
const datasetPreviewMessage = document.getElementById('dataset-preview-message');
const message = document.getElementById('admin-message');
const adminPageTitle = document.getElementById('admin-page-title');
const adminPageDescription = document.getElementById('admin-page-description');
let editingCurrencyCode = null;
let superAdminPage = 1;
let superAdminPageSize = 10;
let currentSuperAdminId = 0;

// Affiche le module choisi dans le menu du super administrateur.
function setAdminView(viewName, updateAddress = true) {
  const views = {
    enterprises: ['Gestion des entreprises', 'Activez ou désactivez les comptes inscrits sur la plateforme.'],
    notifications: ['Notifications email', 'Gérez les adresses qui reçoivent les nouvelles demandes de création d’entreprise.'],
    'super-admins': ['Super administrateurs', 'Créez et consultez les comptes de super administration.'],
    modules: ['Droits des modules', 'Définissez les modules accessibles à chaque entreprise.'],
    currencies: ['Monnaies disponibles', 'Gérez les monnaies proposées lors de la création des produits.'],
    datasets: ['Gestion des jeux de données', 'Constituez et publiez des modèles sectoriels réutilisables par les entreprises.'],
    profile: ['Mon profil', 'Modifiez votre identité et votre mot de passe super administrateur.']
  };
  if (!views[viewName]) viewName = 'enterprises';
  document.querySelectorAll('.admin-view').forEach(view => { view.hidden = view.id !== `admin-view-${viewName}`; });
  document.querySelectorAll('[data-admin-view]').forEach(button => button.classList.toggle('active', button.dataset.adminView === viewName));
  adminPageTitle.textContent = views[viewName][0];
  adminPageDescription.textContent = views[viewName][1];
  if (updateAddress) window.history.replaceState({}, document.title, `${window.location.pathname}#${viewName}`);
  if (viewName === 'datasets') loadDatasets();
}

const datasetSectors = {
  commerce_general:'Commerce général',pharmacie:'Pharmacie',alimentation_boissons:'Alimentation et boissons',
  quincaillerie:'Quincaillerie',materiaux_construction:'Matériaux de construction',agriculture:'Agriculture',
  informatique_electronique:'Informatique et électronique',habillement:'Habillement',
  transport_logistique:'Transport et logistique',industrie:'Industrie',autres:'Autres secteurs',all:'Tous secteurs',
  pharmaceutical:'Pharmaceutique',commercial:'Commerce général',other:'Autres secteurs'
};
const datasetTypes = {
  category:'Catégorie',unit:'Unité',product:'Produit',service:'Service',supplier:'Fournisseur type',
  subcategory:'Sous-catégorie',brand:'Marque',product_type:'Type de produit',common:'Information commune'
};
let datasets = [];

function datasetApiUrl(query = '') {
  return `../backend/public/datasets.php${query ? `?${query}` : ''}`;
}

function clearDatasetForm() {
  datasetForm.reset();
  datasetForm.elements.namedItem('jeu_donnees_id').value = '';
  datasetItemRows.replaceChildren();
  datasetPreviewMessage.textContent = 'Ajoutez des lignes ou importez le modèle CSV pour prévisualiser les données.';
  document.getElementById('dataset-save').textContent = 'Enregistrer le jeu de données';
  appendDatasetRow();
}

function appendDatasetRow(item = {}) {
  datasetItemRows.querySelector('[data-dataset-empty]')?.remove();
  const row = document.createElement('tr');
  if (item._error) {
    row.classList.add('dataset-invalid');
    row.title = item._error;
  }
  row.innerHTML = `<td><select name="type">${Object.entries(datasetTypes).map(([value,label]) => `<option value="${value}">${label}</option>`).join('')}</select></td>
    <td><input name="name" maxlength="150" value="${escapeHtml(item.name || '')}" required></td>
    <td><input name="reference" maxlength="100" value="${escapeHtml(item.reference || '')}"></td>
    <td><input name="category" value="${escapeHtml(item.category || '')}"></td>
    <td><input name="unit" value="${escapeHtml(item.unit || '')}"></td>
    <td><input name="unit_symbol" maxlength="15" value="${escapeHtml(item.unit_symbol || '')}"></td>
    <td><input name="sale_price" type="number" min="0" step="0.01" value="${escapeHtml(item.sale_price ?? '')}"></td>
    <td><input name="cost_price" type="number" min="0" step="0.01" value="${escapeHtml(item.cost_price ?? '')}"></td>
    <td><input name="currency" maxlength="10" value="${escapeHtml(item.currency || '')}"></td>
    <td><input name="perishable" type="checkbox" ${Number(item.perishable) ? 'checked' : ''}></td>
    <td><input name="description" value="${escapeHtml(item.description || '')}"></td>
    <td class="dataset-row-error">${escapeHtml(item._error || '')}</td>
    <td><button type="button" class="delete-super-admin" data-dataset-row-delete aria-label="Supprimer la ligne">×</button></td>`;
  row.querySelector('[name="type"]').value = datasetTypes[item.type] ? item.type : 'category';
  row.querySelector('[data-dataset-row-delete]').addEventListener('click', () => {
    row.remove();
    if (!datasetItemRows.querySelector('tr')) datasetItemRows.innerHTML = '<tr data-dataset-empty><td colspan="13">Aucune ligne ajoutée.</td></tr>';
  });
  row.querySelectorAll('input,select').forEach(input => input.addEventListener('input', () => {
    row.classList.remove('dataset-invalid');
    row.querySelector('.dataset-row-error').textContent = '';
  }));
  datasetItemRows.append(row);
}

function readDatasetRows() {
  return [...datasetItemRows.querySelectorAll('tr')].filter(row => row.querySelector('[name="type"]')).map(row => ({
    type:row.querySelector('[name="type"]').value,
    name:row.querySelector('[name="name"]').value.trim(),
    reference:row.querySelector('[name="reference"]').value.trim(),
    category:row.querySelector('[name="category"]').value.trim(),
    unit:row.querySelector('[name="unit"]').value.trim(),
    unit_symbol:row.querySelector('[name="unit_symbol"]').value.trim(),
    sale_price:row.querySelector('[name="sale_price"]').value,
    cost_price:row.querySelector('[name="cost_price"]').value,
    currency:row.querySelector('[name="currency"]').value.trim(),
    perishable:row.querySelector('[name="perishable"]').checked ? 1 : 0,
    description:row.querySelector('[name="description"]').value.trim()
  }));
}

async function loadDatasets() {
  if (!datasetList) return;
  try {
    const result = await requestJson(datasetApiUrl());
    datasets = result.data;
    renderDatasets();
  } catch (error) {
    datasetList.innerHTML = `<tr><td colspan="8">${escapeHtml(error.message)}</td></tr>`;
  }
}

function renderDatasets() {
  document.getElementById('dataset-stat-total').textContent = datasets.length.toLocaleString('fr-FR');
  document.getElementById('dataset-stat-active').textContent = datasets.filter(dataset => Number(dataset.is_active) === 1).length.toLocaleString('fr-FR');
  document.getElementById('dataset-stat-sectors').textContent = new Set(datasets.map(dataset => dataset.secteur_activite)).size.toLocaleString('fr-FR');
  const query = document.getElementById('dataset-search-admin').value.trim().toLocaleLowerCase();
  const sectorFilter = document.getElementById('dataset-sector-filter').value;
  const statusFilter = document.getElementById('dataset-status-filter').value;
  const rows = datasets.filter(dataset => (!query || `${dataset.name} ${dataset.description || ''} ${dataset.categorie}`.toLocaleLowerCase().includes(query))
    && (!sectorFilter || dataset.secteur_activite === sectorFilter)
    && (statusFilter === '' || Number(dataset.is_active) === Number(statusFilter)));
  datasetList.innerHTML = rows.length ? rows.map(dataset => `<tr><td><strong>${escapeHtml(dataset.name)}</strong></td><td>${escapeHtml(datasetSectors[dataset.secteur_activite] || dataset.secteur_activite)}</td><td>${escapeHtml(dataset.categorie)}</td><td>${dataset.version_number ? `v${Number(dataset.version_number)}` : '—'}</td><td>${Number(dataset.item_count || 0)}</td><td>${escapeHtml(dataset.creator_name || '—')}</td><td><span class="status ${Number(dataset.is_active) ? 'success' : 'danger'}">${Number(dataset.is_active) ? 'Actif' : 'Inactif'}</span></td><td><div class="super-admin-row-actions"><button type="button" data-dataset-edit="${Number(dataset.jeu_donnees_id)}">Modifier</button><a href="${datasetApiUrl(`action=export&id=${Number(dataset.jeu_donnees_id)}&version_id=${Number(dataset.jeu_donnees_version_id || 0)}`)}">Exporter</a><button type="button" class="${Number(dataset.is_active) ? 'delete-super-admin' : ''}" data-dataset-status="${Number(dataset.jeu_donnees_id)}" data-next-status="${Number(dataset.is_active) ? 0 : 1}">${Number(dataset.is_active) ? 'Désactiver' : 'Activer'}</button></div></td></tr>`).join('') : '<tr><td colspan="8">Aucun jeu de données enregistré.</td></tr>';
}

datasetForm?.addEventListener('submit', async event => {
  event.preventDefault();
  const submit = document.getElementById('dataset-save');
  submit.disabled = true;
  try {
    const data = Object.fromEntries(new FormData(datasetForm));
    data.jeu_donnees_id = Number(data.jeu_donnees_id || 0);
    data.items = readDatasetRows();
    if (!data.items.length) throw new Error('Ajoutez au moins une ligne au jeu de données.');
    const result = await requestJson(datasetApiUrl(), {
      method:data.jeu_donnees_id ? 'PUT' : 'POST',
      headers:{'Content-Type':'application/json'},
      body:JSON.stringify(data)
    });
    notify(`Jeu enregistré en version ${result.data.version_number}.`);
    clearDatasetForm();
    await loadDatasets();
  } catch (error) { notify(error.message); }
  finally { submit.disabled = false; }
});

document.getElementById('dataset-add-row')?.addEventListener('click', () => appendDatasetRow());
document.getElementById('dataset-reset')?.addEventListener('click', clearDatasetForm);
document.getElementById('dataset-template')?.addEventListener('click', () => { window.location.href = datasetApiUrl('action=template'); });
document.getElementById('dataset-search-admin')?.addEventListener('input', renderDatasets);
document.getElementById('dataset-sector-filter')?.addEventListener('change', renderDatasets);
document.getElementById('dataset-status-filter')?.addEventListener('change', renderDatasets);
datasetList?.addEventListener('click', async event => {
  const edit = event.target.closest('[data-dataset-edit]');
  const toggle = event.target.closest('[data-dataset-status]');
  if (edit) {
    try {
      const {data} = await requestJson(datasetApiUrl(`id=${encodeURIComponent(edit.dataset.datasetEdit)}`));
      datasetForm.elements.namedItem('jeu_donnees_id').value = data.jeu_donnees_id;
      datasetForm.elements.namedItem('name').value = data.name;
      datasetForm.elements.namedItem('description').value = data.description || '';
      datasetForm.elements.namedItem('secteur_activite').value = data.secteur_activite;
      datasetForm.elements.namedItem('categorie').value = data.categorie;
      datasetItemRows.replaceChildren();
      data.items.forEach(item => appendDatasetRow(item));
      document.getElementById('dataset-save').textContent = `Enregistrer une nouvelle version (actuelle : ${data.version_number})`;
      datasetForm.scrollIntoView({behavior:'smooth', block:'start'});
    } catch (error) { notify(error.message); }
  }
  if (toggle) {
    try {
      await requestJson(datasetApiUrl('action=status'), {
        method:'POST', headers:{'Content-Type':'application/json'},
        body:JSON.stringify({id:Number(toggle.dataset.datasetStatus),is_active:toggle.dataset.nextStatus === '1'})
      });
      notify('Statut du jeu de données mis à jour.');
      await loadDatasets();
    } catch (error) { notify(error.message); }
  }
});

document.getElementById('dataset-csv-file')?.addEventListener('change', async event => {
  const file = event.target.files[0];
  if (!file) return;
  const formData = new FormData();
  formData.append('file', file);
  datasetPreviewMessage.textContent = 'Analyse du fichier CSV…';
  try {
    const response = await fetch(datasetApiUrl('action=preview-csv'), {method:'POST',credentials:'include',body:formData});
    const result = await response.json();
    if (!response.ok || !result.success) throw new Error(result.message || 'Analyse CSV impossible.');
    const rows = result.data.items;
    datasetItemRows.replaceChildren();
    rows.forEach(item => appendDatasetRow(item));
    datasetPreviewMessage.textContent = `${rows.length} ligne(s) analysée(s), ${result.data.errors.length} anomalie(s). Corrigez les lignes avant l’enregistrement.`;
    if (result.data.errors.length) notify(result.data.errors.slice(0, 3).map(error => `Ligne ${error.row} : ${error.message}`).join(' · '));
  } catch (error) {
    datasetPreviewMessage.textContent = error.message;
    notify(error.message);
  } finally { event.target.value = ''; }
});
async function loadSuperAdmins(page = 1) {
  superAdminPage = page;
  try {
    const result = await requestJson(`../backend/public/auth.php?action=super-admin-admins&page=${page}&per_page=${superAdminPageSize}`);
    superAdminList.innerHTML = result.data.length ? result.data.map(admin => `<tr><td><strong>${escapeHtml(admin.full_name)}</strong></td><td>${escapeHtml(admin.email)}</td><td>${escapeHtml(admin.created_at)}</td><td><span class="status ${Number(admin.is_active) === 1 ? 'success' : 'danger'}">${Number(admin.is_active) === 1 ? 'Actif' : 'Inactif'}</span></td><td>${Number(admin.super_admin_id) === currentSuperAdminId ? 'Compte actuel · gérer dans Mon profil' : `<div class="super-admin-row-actions"><button type="button" data-super-admin-edit="${Number(admin.super_admin_id)}" data-full-name="${escapeHtml(admin.full_name)}" data-email="${escapeHtml(admin.email)}">Modifier</button><button type="button" class="delete-super-admin" data-super-admin-delete="${Number(admin.super_admin_id)}">Supprimer</button></div>`}</td></tr>`).join('') : '<tr><td colspan="5">Aucun super administrateur enregistré.</td></tr>';
    const info = result.pagination;
    superAdminPagination.innerHTML = `<span>Page ${info.page} sur ${info.pages} · ${Number(info.total).toLocaleString('fr-FR')} compte${Number(info.total) === 1 ? '' : 's'}</span><div><label>Lignes par page<select data-super-admin-page-size>${[5, 10, 20, 25, 100].map(size => `<option value="${size}"${superAdminPageSize === size ? ' selected' : ''}>${size}</option>`).join('')}</select></label><button type="button" data-super-admin-page="${info.page - 1}" ${info.page <= 1 ? 'disabled' : ''}>Précédent</button><button type="button" data-super-admin-page="${info.page + 1}" ${info.page >= info.pages ? 'disabled' : ''}>Suivant</button></div>`;
  } catch (error) {
    superAdminList.innerHTML = `<tr><td colspan="5">${escapeHtml(error.message)}</td></tr>`;
  }
}

superAdminForm.addEventListener('submit', async event => {
  event.preventDefault();
  const submitButton = superAdminForm.querySelector('[type="submit"]');
  submitButton.disabled = true;
  try {
    await requestJson('../backend/public/auth.php?action=super-admin-admins', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify(Object.fromEntries(new FormData(superAdminForm)))
    });
    superAdminForm.reset();
    notify('Super administrateur créé.');
    await loadSuperAdmins(1);
  } catch (error) {
    notify(error.message);
  } finally {
    submitButton.disabled = false;
  }
});

superAdminList.addEventListener('click', async event => {
  const editButton = event.target.closest('[data-super-admin-edit]');
  if (editButton) {
    superAdminEditForm.elements.namedItem('super_admin_id').value = editButton.dataset.superAdminEdit;
    superAdminEditForm.elements.namedItem('full_name').value = editButton.dataset.fullName;
    superAdminEditForm.elements.namedItem('email').value = editButton.dataset.email;
    superAdminEditForm.elements.namedItem('password').value = '';
    superAdminEditModal.hidden = false;
    superAdminEditForm.elements.namedItem('full_name').focus();
    return;
  }
  const deleteButton = event.target.closest('[data-super-admin-delete]');
  if (!deleteButton || !window.confirm('Supprimer définitivement ce compte super administrateur ?')) return;
  deleteButton.disabled = true;
  try {
    const id = deleteButton.dataset.superAdminDelete;
    await requestJson(`../backend/public/auth.php?action=super-admin-admins&id=${encodeURIComponent(id)}`, {method: 'DELETE'});
    notify('Super administrateur supprimé.');
    await loadSuperAdmins(superAdminPage);
  } catch (error) {
    notify(error.message);
    deleteButton.disabled = false;
  }
});

superAdminEditForm.addEventListener('submit', async event => {
  event.preventDefault();
  const submitButton = superAdminEditForm.querySelector('[type="submit"]');
  submitButton.disabled = true;
  try {
    const data = Object.fromEntries(new FormData(superAdminEditForm));
    const id = data.super_admin_id;
    delete data.super_admin_id;
    await requestJson(`../backend/public/auth.php?action=super-admin-admins&id=${encodeURIComponent(id)}`, {
      method: 'PATCH',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify(data)
    });
    superAdminEditModal.hidden = true;
    superAdminEditForm.reset();
    notify('Super administrateur modifié.');
    await loadSuperAdmins(superAdminPage);
  } catch (error) {
    notify(error.message);
  } finally {
    submitButton.disabled = false;
  }
});
document.getElementById('super-admin-edit-cancel').addEventListener('click', () => {
  superAdminEditModal.hidden = true;
  superAdminEditForm.reset();
});

superAdminPagination.addEventListener('click', event => {
  const button = event.target.closest('[data-super-admin-page]');
  if (button && !button.disabled) loadSuperAdmins(Number(button.dataset.superAdminPage));
});
superAdminPagination.addEventListener('change', event => {
  const select = event.target.closest('[data-super-admin-page-size]');
  if (!select) return;
  const pageSize = Number(select.value);
  if (![5, 10, 20, 25, 100].includes(pageSize)) return;
  superAdminPageSize = pageSize;
  loadSuperAdmins(1);
});

// Échappe les valeurs de la base avant leur insertion dans les tableaux HTML.
const escapeHtml = value => String(value ?? '').replace(/[&<>"']/g, character => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[character]));

// Affiche une confirmation ou une erreur dans la notification de la page.
function notify(text) {
  message.textContent = text;
  message.classList.add('visible');
  setTimeout(() => message.classList.remove('visible'), 3000);
}

async function loadRegistrationNotificationEmail() {
  const result = await requestJson('../backend/public/auth.php?action=super-admin-registration-notification');
  document.getElementById('registration-notification-emails').value = (result.data.emails || []).join('\n');
}

registrationNotificationForm.addEventListener('submit', async event => {
  event.preventDefault();
  const submitButton = registrationNotificationForm.querySelector('[type="submit"]');
  submitButton.disabled = true;
  try {
    const emails = new FormData(registrationNotificationForm).get('emails').split(/[\s,;]+/).filter(Boolean);
    await requestJson('../backend/public/auth.php?action=super-admin-registration-notification', {
      method: 'PUT',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({emails})
    });
    notify('Destinataires de notification mis à jour.');
  } catch (error) {
    notify(error.message);
  } finally {
    submitButton.disabled = false;
  }
});

// Lit une réponse JSON et transforme les erreurs API en erreurs JavaScript lisibles.
async function requestJson(url, options = {}) {
  const response = await fetch(url, {credentials: 'include', ...options});
  const result = await response.json();
  if (!response.ok || !result.success) throw new Error(result.message || 'La requête a échoué.');
  return result;
}

// Charge les entreprises et leurs boutons d'activation.
async function loadEnterprises() {
  const result = await requestJson('../backend/public/auth.php?action=super-admin-enterprises');
  const selectedEnterprise = moduleAccessEnterprise.value;
  moduleAccessEnterprise.innerHTML = '<option value="">Sélectionner une entreprise</option>' + result.data.map(enterprise => `<option value="${Number(enterprise.entreprise_id)}">${escapeHtml(enterprise.name)}</option>`).join('');
  if (result.data.some(enterprise => String(enterprise.entreprise_id) === selectedEnterprise)) moduleAccessEnterprise.value = selectedEnterprise;
  enterpriseList.innerHTML = result.data.length ? result.data.map(enterprise => `<tr><td><strong>${escapeHtml(enterprise.name)}</strong></td><td>${escapeHtml(datasetSectors[enterprise.activity_type] || 'Autres secteurs')}</td><td>${escapeHtml(enterprise.email || '—')}</td><td>${escapeHtml(enterprise.created_at)}</td><td><span class="status ${Number(enterprise.is_active) === 1 ? 'success' : 'danger'}">${Number(enterprise.is_active) === 1 ? 'Active' : 'Inactive'}</span></td><td><button class="status-button ${Number(enterprise.is_active) === 1 ? 'deactivate' : 'activate'}" data-enterprise-id="${Number(enterprise.entreprise_id)}" data-next-status="${Number(enterprise.is_active) === 1 ? 0 : 1}">${Number(enterprise.is_active) === 1 ? 'Désactiver' : 'Activer'}</button></td><td><form class="branch-limit-form" data-enterprise-limit-form="${Number(enterprise.entreprise_id)}"><span>${Number(enterprise.succursales_count)} /</span><input name="max_succursales" type="number" min="2" step="1" required aria-label="Nombre maximal de succursales pour ${escapeHtml(enterprise.name)}" value="${Math.max(2, Number(enterprise.max_succursales))}"><button type="submit">Enregistrer</button></form></td><td><button class="text-button" data-modules-enterprise="${Number(enterprise.entreprise_id)}">${enterprise.modules_autorises.length} modules autorisés</button></td><td class="enterprise-delete-column"><button class="status-button deactivate" data-enterprise-delete="${Number(enterprise.entreprise_id)}" data-enterprise-name="${escapeHtml(enterprise.name)}" aria-label="Supprimer l’entreprise ${escapeHtml(enterprise.name)}" title="Supprimer définitivement cette entreprise">Supprimer</button></td></tr>`).join('') : '<tr><td colspan="9">Aucune entreprise enregistrée.</td></tr>';
}

enterpriseList.addEventListener('submit', async event => {
  const form = event.target.closest('[data-enterprise-limit-form]');
  if (!form) return;
  event.preventDefault();
  const submitButton = form.querySelector('[type="submit"]');
  submitButton.disabled = true;
  try {
    await requestJson('../backend/public/auth.php?action=super-admin-enterprise-branch-limit', {
      method: 'PUT',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({
        entreprise_id: form.dataset.enterpriseLimitForm,
        max_succursales: Number(form.elements.namedItem('max_succursales').value)
      })
    });
    notify('Plafond de succursales mis à jour.');
    await loadEnterprises();
  } catch (error) {
    notify(error.message);
    submitButton.disabled = false;
  }
});

async function loadEnterpriseModules() {
  const enterpriseId = moduleAccessEnterprise.value;
  moduleAccessList.replaceChildren();
  moduleAccessList.disabled = !enterpriseId;
  moduleAccessForm.querySelector('[type="submit"]').disabled = true;
  if (!enterpriseId) return;
  try {
    const result = await requestJson(`../backend/public/auth.php?action=super-admin-enterprise-modules&entreprise_id=${encodeURIComponent(enterpriseId)}`);
    const selectedModules = new Set(result.data.modules_autorises);
    moduleAccessList.innerHTML = Object.entries(result.data.modules).map(([code, label]) => `<label><input type="checkbox" name="modules_autorises" value="${escapeHtml(code)}"${selectedModules.has(code) ? ' checked' : ''}>${escapeHtml(label)}</label>`).join('');
    moduleAccessForm.querySelector('[type="submit"]').disabled = false;
  } catch (error) {
    notify(error.message);
  }
}

moduleAccessEnterprise.addEventListener('change', loadEnterpriseModules);
moduleAccessForm.addEventListener('submit', async event => {
  event.preventDefault();
  const submitButton = moduleAccessForm.querySelector('[type="submit"]');
  submitButton.disabled = true;
  try {
    await requestJson('../backend/public/auth.php?action=super-admin-enterprise-modules', {
      method: 'PUT',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({
        entreprise_id: moduleAccessEnterprise.value,
        modules_autorises: [...moduleAccessForm.querySelectorAll('input[name="modules_autorises"]:checked')].map(input => input.value)
      })
    });
    notify('Droits des modules mis à jour.');
    await loadEnterprises();
  } catch (error) {
    notify(error.message);
  } finally {
    submitButton.disabled = !moduleAccessEnterprise.value;
  }
});

// Charge les monnaies créées par le super administrateur.
async function loadCurrencies() {
  const result = await requestJson('../backend/public/auth.php?action=super-admin-currencies');
  currencyList.innerHTML = result.data.length ? result.data.map(currency => `<tr><td>${escapeHtml(currency.type_monais)}</td><td>${escapeHtml(currency.description || '—')}</td><td><button class="text-button" data-currency-edit="${escapeHtml(currency.type_monais)}" data-currency-description="${escapeHtml(currency.description || '')}">Modifier</button> <button class="text-button" data-currency-delete="${escapeHtml(currency.type_monais)}">Supprimer</button></td></tr>`).join('') : '<tr><td colspan="3">Aucune monnaie enregistrée.</td></tr>';
}

// Charge les données du compte dans le module profil.
async function loadAdminProfile() {
  const result = await requestJson('../backend/public/auth.php?action=me');
  currentSuperAdminId = Number(result.data.id);
  const localLanguage = localStorage.getItem('westock-language');
  window.setInterfaceLanguage?.(localLanguage || result.data.preferred_language || 'fr');
  if (localLanguage && localLanguage !== result.data.preferred_language) {
    requestJson('../backend/public/auth.php?action=preferred-language', {
      method: 'PUT',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({language: localLanguage}),
    }).catch(error => console.error('Enregistrement différé de la langue impossible.', error));
  }
  document.getElementById('admin-profile-name').value = result.data.full_name || '';
  document.getElementById('admin-profile-email').value = result.data.email || '';
}

window.addEventListener('interface-language-change', async event => {
  try {
    await requestJson('../backend/public/auth.php?action=preferred-language', {
      method: 'PUT',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({language: event.detail.language}),
    });
    notify('Langue enregistrée dans votre compte.');
  } catch (error) {
    notify(error.message);
  }
});

// Modifie le nom et l'adresse email du super administrateur connecté.
document.getElementById('admin-profile-form').addEventListener('submit', async event => {
  event.preventDefault();
  try {
    await requestJson('../backend/public/auth.php?action=profile', {
      method: 'PATCH',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify(Object.fromEntries(new FormData(event.currentTarget)))
    });
    notify('Profil mis à jour.');
  } catch (error) { notify(error.message); }
});

// Modifie le mot de passe après validation de l'ancien mot de passe.
document.getElementById('admin-password-form').addEventListener('submit', async event => {
  event.preventDefault();
  try {
    await requestJson('../backend/public/auth.php?action=change-password', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify(Object.fromEntries(new FormData(event.currentTarget)))
    });
    event.currentTarget.reset();
    notify('Mot de passe modifié.');
  } catch (error) { notify(error.message); }
});

// Réinitialise le formulaire après création ou annulation d'une modification.
function resetCurrencyForm() {
  editingCurrencyCode = null;
  currencyForm.reset();
  currencyForm.querySelector('[type="submit"]').textContent = 'Enregistrer la monnaie';
  currencyCancel.hidden = true;
}

// Enregistre une nouvelle monnaie. Cette route vérifie aussi le rôle super administrateur côté serveur.
currencyForm.addEventListener('submit', async event => {
  event.preventDefault();
  const submitButton = currencyForm.querySelector('[type="submit"]');
  submitButton.disabled = true;
  try {
    // Marque l'envoi comme AJAX pour recevoir le JSON et rester sur le module monnaies.
    const wasEditing = Boolean(editingCurrencyCode);
    const data = Object.fromEntries(new FormData(currencyForm));
    await requestJson(`../backend/public/auth.php?action=super-admin-currencies${editingCurrencyCode ? `&code=${encodeURIComponent(editingCurrencyCode)}` : ''}`, {
      method: editingCurrencyCode ? 'PUT' : 'POST',
      headers: {'Content-Type': 'application/json', 'X-Requested-With': 'XMLHttpRequest'},
      body: JSON.stringify(data)
    });
    resetCurrencyForm();
    notify(wasEditing ? 'La monnaie a été modifiée.' : 'La monnaie a été enregistrée.');
    await loadCurrencies();
  } catch (error) {
    notify(error.message);
  } finally {
    submitButton.disabled = false;
  }
});

currencyCancel.addEventListener('click', resetCurrencyForm);

// Préremplit le formulaire pour modifier une monnaie existante.
currencyList.addEventListener('click', async event => {
  const editButton = event.target.closest('[data-currency-edit]');
  if (editButton) {
    editingCurrencyCode = editButton.dataset.currencyEdit;
    currencyForm.elements.namedItem('type_monais').value = editingCurrencyCode;
    currencyForm.elements.namedItem('description').value = editButton.dataset.currencyDescription;
    currencyForm.querySelector('[type="submit"]').textContent = 'Enregistrer les modifications';
    currencyCancel.hidden = false;
    currencyForm.elements.namedItem('type_monais').focus();
    return;
  }
  const deleteButton = event.target.closest('[data-currency-delete]');
  if (!deleteButton || !window.confirm(`Supprimer la monnaie ${deleteButton.dataset.currencyDelete} ?`)) return;
  try {
    await requestJson(`../backend/public/auth.php?action=super-admin-currencies&code=${encodeURIComponent(deleteButton.dataset.currencyDelete)}`, {method: 'DELETE'});
    notify('La monnaie a été supprimée.');
    await loadCurrencies();
  } catch (error) { notify(error.message); }
});

// Active ou désactive une entreprise après confirmation du serveur.
document.addEventListener('click', async event => {
  const moduleButton = event.target.closest('[data-modules-enterprise]');
  if (moduleButton) {
    moduleAccessEnterprise.value = moduleButton.dataset.modulesEnterprise;
    await loadEnterpriseModules();
    setAdminView('modules');
    return;
  }
  const deleteEnterpriseButton = event.target.closest('[data-enterprise-delete]');
  if (deleteEnterpriseButton) {
    const enterpriseName = deleteEnterpriseButton.dataset.enterpriseName;
    const confirmation = window.prompt(`Cette suppression est définitive. Saisissez le nom exact « ${enterpriseName} » pour confirmer.`);
    if (confirmation !== enterpriseName) return;
    deleteEnterpriseButton.disabled = true;
    try {
      const result = await requestJson(`../backend/public/auth.php?action=super-admin-enterprise-delete&entreprise_id=${encodeURIComponent(deleteEnterpriseButton.dataset.enterpriseDelete)}`, {method: 'DELETE'});
      notify(result.message);
      await loadEnterprises();
    } catch (error) {
      notify(error.message);
      deleteEnterpriseButton.disabled = false;
    }
    return;
  }
  const button = event.target.closest('[data-enterprise-id][data-next-status]');
  if (!button) return;
  try {
    await requestJson('../backend/public/auth.php?action=super-admin-enterprise-status', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({entreprise_id: button.dataset.enterpriseId, is_active: button.dataset.nextStatus === '1'})
    });
    notify('Statut de l’entreprise mis à jour.');
    await loadEnterprises();
  } catch (error) {
    notify(error.message);
  }
});

// Ferme la session super administrateur.
document.getElementById('logout').addEventListener('click', async () => {
  try { await requestJson('../backend/public/auth.php?action=logout', {method: 'POST'}); }
  finally { window.location.href = '../index.html'; }
});

// Les entrées du menu changent de module sans quitter la session super administrateur.
document.querySelectorAll('[data-admin-view]').forEach(button => {
  button.addEventListener('click', () => setAdminView(button.dataset.adminView));
});

// Une soumission classique revient directement sur le module des monnaies.
const savedCurrency = new URLSearchParams(window.location.search).get('monnaie') === 'enregistree';
setAdminView(savedCurrency ? 'currencies' : window.location.hash.slice(1) || 'enterprises', false);
if (savedCurrency) {
  notify('La monnaie a été enregistrée.');
  window.history.replaceState({}, document.title, `${window.location.pathname}#currencies`);
}

// Charge les deux listes au démarrage de la page d'administration.
loadEnterprises().catch(error => { enterpriseList.innerHTML = `<tr><td colspan="9">${escapeHtml(error.message)}</td></tr>`; });
loadRegistrationNotificationEmail().catch(error => notify(error.message));
loadAdminProfile().then(() => loadSuperAdmins()).catch(error => {
  superAdminList.innerHTML = `<tr><td colspan="5">${escapeHtml(error.message)}</td></tr>`;
  notify(error.message);
});
loadCurrencies().catch(error => { currencyList.innerHTML = `<tr><td colspan="3">${escapeHtml(error.message)}</td></tr>`; });

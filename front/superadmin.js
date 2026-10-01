const enterpriseList = document.getElementById('enterprise-list');
const moduleAccessForm = document.getElementById('module-access-form');
const moduleAccessEnterprise = document.getElementById('module-access-enterprise');
const moduleAccessList = document.getElementById('module-access-list');
const currencyList = document.getElementById('currency-list');
const currencyForm = document.getElementById('currency-form');
const currencyCancel = document.getElementById('currency-cancel');
const message = document.getElementById('admin-message');
const adminPageTitle = document.getElementById('admin-page-title');
const adminPageDescription = document.getElementById('admin-page-description');
let editingCurrencyCode = null;

// Affiche le module choisi dans le menu du super administrateur.
function setAdminView(viewName, updateAddress = true) {
  const views = {
    enterprises: ['Gestion des entreprises', 'Activez ou désactivez les comptes inscrits sur la plateforme.'],
    modules: ['Droits des modules', 'Définissez les modules accessibles à chaque entreprise.'],
    currencies: ['Monnaies disponibles', 'Gérez les monnaies proposées lors de la création des produits.'],
    profile: ['Mon profil', 'Modifiez votre identité et votre mot de passe super administrateur.']
  };
  if (!views[viewName]) viewName = 'enterprises';
  document.querySelectorAll('.admin-view').forEach(view => { view.hidden = view.id !== `admin-view-${viewName}`; });
  document.querySelectorAll('[data-admin-view]').forEach(button => button.classList.toggle('active', button.dataset.adminView === viewName));
  adminPageTitle.textContent = views[viewName][0];
  adminPageDescription.textContent = views[viewName][1];
  if (updateAddress) window.history.replaceState({}, document.title, `${window.location.pathname}#${viewName}`);
}

// Échappe les valeurs de la base avant leur insertion dans les tableaux HTML.
const escapeHtml = value => String(value ?? '').replace(/[&<>"']/g, character => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[character]));

// Affiche une confirmation ou une erreur dans la notification de la page.
function notify(text) {
  message.textContent = text;
  message.classList.add('visible');
  setTimeout(() => message.classList.remove('visible'), 3000);
}

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
  enterpriseList.innerHTML = result.data.length ? result.data.map(enterprise => `<tr><td><strong>${escapeHtml(enterprise.name)}</strong></td><td>${escapeHtml(enterprise.email || '—')}</td><td>${escapeHtml(enterprise.created_at)}</td><td><span class="status ${Number(enterprise.is_active) === 1 ? 'success' : 'danger'}">${Number(enterprise.is_active) === 1 ? 'Active' : 'Inactive'}</span></td><td><button class="status-button ${Number(enterprise.is_active) === 1 ? 'deactivate' : 'activate'}" data-enterprise-id="${Number(enterprise.entreprise_id)}" data-next-status="${Number(enterprise.is_active) === 1 ? 0 : 1}">${Number(enterprise.is_active) === 1 ? 'Désactiver' : 'Activer'}</button></td><td><button class="text-button" data-modules-enterprise="${Number(enterprise.entreprise_id)}">${enterprise.modules_autorises.length} modules autorisés</button></td><td><button class="status-button deactivate" data-enterprise-delete="${Number(enterprise.entreprise_id)}" data-enterprise-name="${escapeHtml(enterprise.name)}">Supprimer</button></td></tr>`).join('') : '<tr><td colspan="7">Aucune entreprise enregistrée.</td></tr>';
}

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
  document.getElementById('admin-profile-name').value = result.data.full_name || '';
  document.getElementById('admin-profile-email').value = result.data.email || '';
}

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
loadEnterprises().catch(error => { enterpriseList.innerHTML = `<tr><td colspan="6">${escapeHtml(error.message)}</td></tr>`; });
loadCurrencies().catch(error => { currencyList.innerHTML = `<tr><td colspan="3">${escapeHtml(error.message)}</td></tr>`; });
loadAdminProfile().catch(error => notify(error.message));

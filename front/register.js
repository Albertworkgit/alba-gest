const form = document.getElementById('register-form');
const message = document.getElementById('register-message');
const submitButton = form.querySelector('button[type="submit"], button:not([type])');
const submitLabel = submitButton.innerHTML;

form.addEventListener('submit', async event => {
  event.preventDefault();
  if (submitButton.disabled) return;
  message.className = 'register-message';
  message.textContent = 'Enregistrement en cours...';
  message.classList.add('visible');
  submitButton.disabled = true;
  submitButton.setAttribute('aria-busy', 'true');
  submitButton.innerHTML = '<span class="loading-spinner" aria-hidden="true"></span>Création du compte…';

  try {
    const response = await fetch('../backend/public/auth.php?action=register', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({
        ...Object.fromEntries(new FormData(form)),
        preferred_language: window.getInterfaceLanguage?.() || 'fr',
      }),
    });
    const result = await response.json();
    if (!response.ok || !result.success) throw new Error(result.message || 'Inscription impossible.');
    message.className = 'register-message success visible';
    message.textContent = result.message;
    form.reset();
  } catch (error) {
    message.className = 'register-message error visible';
    message.textContent = error.message;
  } finally {
    submitButton.disabled = false;
    submitButton.removeAttribute('aria-busy');
    submitButton.innerHTML = submitLabel;
  }
});

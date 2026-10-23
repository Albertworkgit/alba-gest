const form = document.getElementById('login-form');
const errorBox = document.getElementById('login-error');
const submitButton = form.querySelector('button[type="submit"]');
const submitLabel = submitButton.innerHTML;

form.addEventListener('submit', async event => {
  event.preventDefault();
  if (submitButton.disabled) return;
  errorBox.classList.remove('visible');
  const data = Object.fromEntries(new FormData(form));
  submitButton.disabled = true;
  submitButton.setAttribute('aria-busy', 'true');
  submitButton.innerHTML = '<span class="loading-spinner" aria-hidden="true"></span>Connexion en cours…';

  try {
    const response = await fetch('../backend/public/auth.php?action=user-login', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      credentials: 'include',
      body: JSON.stringify(data),
    });
    const result = await response.json();
    if (!response.ok || !result.success) {
      throw new Error(result.message || 'Connexion impossible.');
    }
    window.location.href = 'index.html#/dashboard';
  } catch (error) {
    errorBox.textContent = error.message;
    errorBox.classList.add('visible');
  } finally {
    submitButton.disabled = false;
    submitButton.removeAttribute('aria-busy');
    submitButton.innerHTML = submitLabel;
  }
});

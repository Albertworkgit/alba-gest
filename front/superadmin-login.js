const form = document.getElementById('admin-login-form');
const errorBox = document.getElementById('admin-error');

form.addEventListener('submit', async event => {
  event.preventDefault();
  errorBox.classList.remove('visible');
  try {
    const response = await fetch('../backend/public/auth.php?action=super-admin-login', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      credentials: 'include',
      body: JSON.stringify(Object.fromEntries(new FormData(form))),
    });
    const result = await response.json();
    if (!response.ok || !result.success) throw new Error(result.message || 'Connexion impossible.');
    window.location.href = 'superadmin.html';
  } catch (error) {
    errorBox.textContent = error.message;
    errorBox.classList.add('visible');
  }
});

const form = document.getElementById('register-form');
const message = document.getElementById('register-message');

form.addEventListener('submit', async event => {
  event.preventDefault();
  message.className = 'register-message';
  message.textContent = 'Enregistrement en cours...';
  message.classList.add('visible');

  try {
    const response = await fetch('../backend/public/auth.php?action=register', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify(Object.fromEntries(new FormData(form))),
    });
    const result = await response.json();
    if (!response.ok || !result.success) throw new Error(result.message || 'Inscription impossible.');
    message.className = 'register-message success visible';
    message.textContent = result.message;
    form.reset();
  } catch (error) {
    message.className = 'register-message error visible';
    message.textContent = error.message;
  }
});

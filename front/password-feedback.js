function updatePasswordFeedback(input) {
  const label = input.closest('label');
  if (!label) return;
  let feedback = label.querySelector('.password-feedback');
  if (!feedback) {
    feedback = document.createElement('small');
    feedback.className = 'password-feedback';
    feedback.setAttribute('aria-live', 'polite');
    input.insertAdjacentElement('afterend', feedback);
  }

  const password = input.value;
  const criteria = [
    {label: '8 caractères', met: password.length >= 8},
    {label: 'une minuscule', met: /[a-z]/.test(password)},
    {label: 'une majuscule', met: /[A-Z]/.test(password)},
    {label: 'un chiffre', met: /\d/.test(password)},
    {label: 'un caractère spécial', met: /[^A-Za-z0-9]/.test(password)},
  ];
  const score = criteria.filter(criterion => criterion.met).length;
  const strength = password.length === 0 ? 'non-evaluee' : score <= 2 ? 'faible' : score <= 4 ? 'moyen' : 'fort';
  const criteriaText = criteria.map(criterion => `${criterion.met ? '✓' : '○'} ${criterion.label}`).join(' · ');

  feedback.dataset.strength = strength;
  feedback.textContent = password.length === 0
    ? `Critères conseillés : ${criteria.map(criterion => criterion.label).join(', ')}.`
    : `Force : ${strength} (${score}/5). Critères : ${criteriaText}.`;
}

document.addEventListener('input', event => {
  const input = event.target.closest('input[data-password-feedback]');
  if (input) updatePasswordFeedback(input);
});

document.addEventListener('reset', event => {
  window.setTimeout(() => {
    event.target.querySelectorAll('input[data-password-feedback]').forEach(updatePasswordFeedback);
  }, 0);
});

document.querySelectorAll('input[data-password-feedback]').forEach(updatePasswordFeedback);

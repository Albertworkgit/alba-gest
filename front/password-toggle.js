(() => {
  const addToggle = input => {
    if (!(input instanceof HTMLInputElement) || input.type !== 'password' || input.dataset.passwordToggleReady) return;
    const label = input.closest('label');
    if (!label) return;
    input.dataset.passwordToggleReady = 'true';
    label.classList.add('password-field');
    const button = document.createElement('button');
    button.className = 'password-toggle';
    button.type = 'button';
    button.innerHTML = '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M2.5 12s3.4-6 9.5-6 9.5 6 9.5 6-3.4 6-9.5 6-9.5-6-9.5-6Z"/><circle cx="12" cy="12" r="2.5"/></svg>';
    button.setAttribute('aria-label', 'Afficher le mot de passe');
    button.title = 'Afficher le mot de passe';
    button.setAttribute('aria-pressed', 'false');
    button.addEventListener('click', () => {
      const visible = input.type === 'password';
      input.type = visible ? 'text' : 'password';
      button.setAttribute('aria-label', `${visible ? 'Masquer' : 'Afficher'} le mot de passe`);
      button.title = `${visible ? 'Masquer' : 'Afficher'} le mot de passe`;
      button.setAttribute('aria-pressed', String(visible));
      button.innerHTML = visible
        ? '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="m3 3 18 18"/><path d="M10.6 6.2A10.5 10.5 0 0 1 12 6c6.1 0 9.5 6 9.5 6a16 16 0 0 1-3.1 3.6"/><path d="M6.2 6.2C3.9 7.7 2.5 12 2.5 12s3.4 6 9.5 6a10 10 0 0 0 4-.8"/><path d="M9.9 9.9a3 3 0 0 0 4.2 4.2"/></svg>'
        : '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M2.5 12s3.4-6 9.5-6 9.5 6 9.5 6-3.4 6-9.5 6-9.5-6-9.5-6Z"/><circle cx="12" cy="12" r="2.5"/></svg>';
    });
    input.insertAdjacentElement('afterend', button);
  };

  const scan = node => {
    if (node instanceof HTMLInputElement) addToggle(node);
    if (node.querySelectorAll) node.querySelectorAll('input[type="password"]').forEach(addToggle);
  };

  scan(document);
  new MutationObserver(records => {
    records.forEach(record => record.addedNodes.forEach(scan));
  }).observe(document.documentElement, {childList: true, subtree: true});
})();

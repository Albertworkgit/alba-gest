import {useEffect} from 'react';
import {createRoot} from 'react-dom/client';

function SuperadminLoginPage() {
  useEffect(() => {
    const initializeLegacyInteractions = async () => {
      await import('../password-toggle.js');
      await import('../interface-language.js');
      await import('../superadmin-login.js');
    };

    initializeLegacyInteractions().catch(error => {
      console.error('Impossible de charger les interactions d’administration.', error);
      const errorBox = document.getElementById('admin-error');
      errorBox.textContent = 'La page de connexion n’a pas pu être initialisée. Veuillez actualiser la page.';
      errorBox.classList.add('visible');
    });
  }, []);

  return (
    <main className="auth-simple-layout auth-simple-admin">
      <header className="auth-simple-header">
        <a className="auth-simple-brand" href="login.html" aria-label="ALBA-GEST">
          <span className="auth-brand-mark">A</span>
          <span>ALBA-GEST<span className="brand-dot">.</span></span>
        </a>
        <div className="auth-simple-heading">
          <h1>Administration</h1>
          <p>Connectez-vous à votre espace sécurisé.</p>
        </div>
      </header>
      <section className="auth-simple-card" aria-label="Connexion à l’administration">
        <div className="admin-error" id="admin-error" role="alert" />
        <form id="admin-login-form">
          <label className="admin-field">
            Email
            <span className="auth-input-icon" aria-hidden="true">
              <svg viewBox="0 0 24 24">
                <rect x="3" y="5" width="18" height="14" rx="2" />
                <path d="m4 7 8 6 8-6" />
              </svg>
            </span>
            <input type="email" name="email" autoComplete="username" placeholder="Votre adresse email" required />
          </label>
          <label className="admin-field">
            Mot de passe
            <span className="auth-input-icon" aria-hidden="true">
              <svg viewBox="0 0 24 24">
                <rect x="4.5" y="10" width="15" height="11" rx="2" />
                <path d="M8 10V7a4 4 0 0 1 8 0v3m-4 5v2" />
              </svg>
            </span>
            <input type="password" name="password" autoComplete="current-password" placeholder="Votre mot de passe" required />
          </label>
          <button className="admin-submit">
            Se connecter <span aria-hidden="true">→</span>
          </button>
        </form>
      </section>
      <p className="auth-simple-footer"><a href="login.html">Retour à la connexion</a></p>
    </main>
  );
}

createRoot(document.getElementById('superadmin-login-root')).render(<SuperadminLoginPage />);

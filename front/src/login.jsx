import {useEffect} from 'react';
import {createRoot} from 'react-dom/client';

function LoginPage() {
  useEffect(() => {
    const initializeLegacyInteractions = async () => {
      await import('../password-toggle.js');
      await import('../interface-language.js');
      await import('../login.js');
    };

    initializeLegacyInteractions().catch(error => {
      console.error('Impossible de charger les interactions de connexion.', error);
      const errorBox = document.getElementById('login-error');
      errorBox.textContent = 'La page de connexion n’a pas pu être initialisée. Veuillez actualiser la page.';
      errorBox.classList.add('visible');
    });
  }, []);

  return (
    <main className="auth-login-layout">
      <section className="auth-login-content">
        <div className="auth-login-content-inner">
          <header className="auth-simple-header auth-login-topline">
            <a className="auth-login-brand" href="index.html" aria-label="ALBA-GEST">
              <span className="auth-login-mark">A</span>
              <span>ALBA-GEST<span>.</span></span>
            </a>
          </header>
          <div className="auth-login-heading">
            <h1>Connexion</h1>
            <p>Accédez à votre espace de gestion.</p>
          </div>
          <div className="login-error" id="login-error" role="alert" />
          <form className="auth-login-form" id="login-form" aria-label="Formulaire de connexion">
            <label className="login-field">
              <span className="auth-input-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24">
                  <circle cx="12" cy="8" r="3.5" />
                  <path d="M4.8 20c.7-3.2 3.3-5 7.2-5s6.5 1.8 7.2 5" />
                </svg>
              </span>
              <input
                name="login"
                autoComplete="username"
                aria-label="Email ou nom d’utilisateur"
                placeholder="Votre identifiant"
                required
              />
            </label>
            <label className="login-field">
              <span className="auth-input-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24">
                  <rect x="4.5" y="10" width="15" height="11" rx="2" />
                  <path d="M8 10V7a4 4 0 0 1 8 0v3m-4 5v2" />
                </svg>
              </span>
              <input
                name="password"
                type="password"
                autoComplete="current-password"
                aria-label="Mot de passe"
                placeholder="Votre mot de passe"
                required
              />
            </label>
            <button className="login-submit" type="submit">
              Se connecter
              <span aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none">
                  <path d="M14 4h5a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-5" />
                  <path d="M3 12h12m-5-5 5 5-5 5" />
                </svg>
              </span>
            </button>
          </form>
          <p className="auth-login-register">
            Vous n’avez pas encore d’espace ? <a href="register.html">Créer une entreprise <span>↗</span></a>
          </p>
        </div>
      </section>
    </main>
  );
}

createRoot(document.getElementById('login-root')).render(<LoginPage />);

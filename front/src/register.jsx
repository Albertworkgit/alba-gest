import {useEffect} from 'react';
import {createRoot} from 'react-dom/client';

function RegisterPage() {
  useEffect(() => {
    const initializeLegacyInteractions = async () => {
      await import('../password-toggle.js');
      await import('../password-feedback.js');
      await import('../interface-language.js');
      await import('../register.js');
    };

    initializeLegacyInteractions().catch(error => {
      console.error('Impossible de charger les interactions d’inscription.', error);
      const message = document.getElementById('register-message');
      message.textContent = 'Le formulaire n’a pas pu être initialisé. Veuillez actualiser la page.';
      message.classList.add('visible', 'error');
    });
  }, []);

  return (
    <main className="auth-layout register-layout">
      <section className="auth-showcase">
        <a className="auth-brand" href="login.html">
          <span className="auth-brand-mark">A</span>
          <span>ALBA-GEST<span className="brand-dot">.</span></span>
        </a>
        <div className="auth-showcase-copy">
          <span className="auth-eyebrow">DÉMARREZ SIMPLEMENT</span>
          <h1>Une gestion plus claire,<br /><em>dès aujourd’hui.</em></h1>
          <p>Créez l’espace de votre entreprise et centralisez le suivi de vos activités dans un outil unique.</p>
        </div>
        <div className="auth-feature-list">
          <div>
            <span>01</span>
            <p><strong>Votre espace professionnel</strong><small>Un environnement dédié à votre entreprise et à votre équipe.</small></p>
          </div>
          <div>
            <span>02</span>
            <p><strong>Activation accompagnée</strong><small>Votre demande est examinée avant l’ouverture de l’accès.</small></p>
          </div>
        </div>
        <p className="auth-copyright">ALBERT WORK · Solution de gestion</p>
      </section>
      <section className="register-card">
        <div className="register-brand"><span>A</span>ALBA-GEST</div>
        <h1>Créer votre entreprise</h1>
        <p>Renseignez vos informations pour envoyer une demande d’accès.</p>
        <div className="register-message" id="register-message" role="status" aria-live="polite" />
        <form id="register-form">
          <div className="register-grid">
            <label className="register-field full">
              Nom de l'entreprise
              <input name="enterprise_name" autoComplete="organization" required />
            </label>
            <label className="register-field">
              Téléphone de l'entreprise
              <input name="phone" type="tel" autoComplete="tel" />
            </label>
            <label className="register-field">
              Adresse de l'entreprise
              <input name="address" autoComplete="street-address" />
            </label>
            <label className="register-field">
              Nom complet
              <input name="full_name" autoComplete="name" required />
            </label>
            <label className="register-field">
              Nom utilisateur
              <input name="username" autoComplete="username" required />
            </label>
            <label className="register-field">
              Email
              <input name="email" type="email" autoComplete="email" required />
            </label>
            <label className="register-field">
              Mot de passe
              <input
                name="password"
                type="password"
                minLength={6}
                autoComplete="new-password"
                data-password-feedback
                required
              />
            </label>
          </div>
          <button className="register-submit">
            Envoyer la demande <span aria-hidden="true">→</span>
          </button>
        </form>
        <p className="auth-form-footer">Vous avez déjà un compte ? <a href="login.html">Se connecter</a></p>
      </section>
    </main>
  );
}

createRoot(document.getElementById('register-root')).render(<RegisterPage />);

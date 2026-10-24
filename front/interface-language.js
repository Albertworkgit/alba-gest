(() => {
  const languages = {
    fr: {label: 'Français', html: 'fr'},
    en: {label: 'English', html: 'en'},
    sw: {label: 'Kiswahili', html: 'sw'},
    ln: {label: 'Lingála', html: 'ln'},
    kn: {label: 'Kinande', html: 'kn'},
  };
  const rows = [
    ["Connexion", "Sign in", "Ingia", "Kota", "Injira"],
    ["Accédez à votre espace de gestion.", "Access your management space.", "Fungua nafasi yako ya usimamizi.", "Kota na esika na yo ya mosala.", "Injira mu mwanya wawe w'obulongozi."],
    ["Se connecter", "Sign in", "Ingia", "Kota", "Injira"],
    ["Email ou nom d’utilisateur", "Email or username", "Barua pepe au jina la mtumiaji", "Email to kombo ya mosaleli", "Email erina ly'omukozesa"],
    ["Votre identifiant", "Your username", "Jina lako la mtumiaji", "Kombo na yo ya mosaleli", "Erina lyo ly'omukozesa"],
    ["Mot de passe", "Password", "Nenosiri", "Mot de passe", "Akabiri"],
    ["Créer une entreprise", "Create a company", "Unda kampuni", "Sala kompanyi", "Kola ekitongole"],
    ["Créer votre entreprise", "Create your company", "Unda kampuni yako", "Sala kompanyi na yo", "Kola ekitongole ky'obe"],
    ["Renseignez vos informations pour envoyer une demande d’accès.", "Enter your details to submit an access request.", "Jaza taarifa zako kutuma ombi la ufikiaji.", "Tondisa makambo na yo mpo na kotinda bosengi ya kokota.", "Yingiza ebikwatako oyitume obusabe bw'okwingira."],
    ["Nom de l'entreprise", "Company name", "Jina la kampuni", "Kombo ya kompanyi", "Erina ly'ekitongole"],
    ["Téléphone de l'entreprise", "Company phone", "Simu ya kampuni", "Telefone ya kompanyi", "Telefone y'ekitongole"],
    ["Adresse de l'entreprise", "Company address", "Anwani ya kampuni", "Adrɛsi ya kompanyi", "Adrɛsi y'ekitongole"],
    ["Nom complet", "Full name", "Jina kamili", "Kombo mobimba", "Erina lyose"],
    ["Nom utilisateur", "Username", "Jina la mtumiaji", "Kombo ya mosaleli", "Erina ly'omukozesa"],
    ["Email", "Email", "Barua pepe", "Email", "Email"],
    ["Envoyer la demande", "Submit request", "Tuma ombi", "Tinda bosengi", "Yituma obusabe"],
    ["Vous avez déjà un compte ?", "Already have an account?", "Tayari una akaunti?", "Ozali na compte déjà?", "Olina akawunti?"],
    ["Se déconnecter", "Sign out", "Toka", "Bima", "Fuluka"],
    ["Vue d'ensemble", "Overview", "Muhtasari", "Botali ya mobimba", "Okulengera hamwe"],
    ["Stock", "Inventory", "Hifadhi", "Stock", "Ebintu ebiri mu sito"],
    ["Approvisionnements", "Purchases", "Manunuzi", "Biloko bisombami", "Ebyagulibwa"],
    ["Ventes", "Sales", "Mauzo", "Boteki", "Ebyagulibwa"],
    ["Caisse", "Cash register", "Kasha", "Kasa", "Kasa"],
    ["Comptabilité", "Accounting", "Uhasibu", "Mokomisi", "Ebibalo bya mali"],
    ["Succursales", "Branches", "Matawi", "Bafiliale", "Amatabi"],
    ["Clients", "Customers", "Wateja", "Bakiliya", "Bakiliya"],
    ["Portail client", "Customer portal", "Tovuti ya mteja", "Portal ya bakiliya", "Portal ya bakiliya"],
    ["Utilisateurs & rôles", "Users & roles", "Watumiaji na majukumu", "Bosaleli mpe mikumba", "Abakozesa n'emirimo"],
    ["Demandes reçues", "Requests received", "Maombi yaliyopokelewa", "Bansengi oyo ezwami", "Obusabe obwayingire"],
    ["Vue de la succursale", "Branch overview", "Muhtasari wa tawi", "Botali ya filiale", "Okulengera itabi"],
    ["Mon profil", "My profile", "Wasifu wangu", "Profil na ngai", "Profili yange"],
    ["Besoin d'aide ?", "Need help?", "Unahitaji msaada?", "Olingi lisalisi?", "Oyagala obuyambi?"],
    ["Centre de support", "Support center", "Kituo cha msaada", "Esika ya lisalisi", "Esika y'obuyambi"],
    ["Rechercher", "Search", "Tafuta", "Luka", "Londera"],
    ["Thème", "Theme", "Mandhari", "Motindo", "Endabika"],
    ["Dans ce module", "In this module", "Katika moduli hii", "Na module oyo", "Mu module eri"],
    ["Vue générale", "Overview", "Muhtasari", "Botali ya mobimba", "Okulengera hamwe"],
    ["Mode clair", "Light mode", "Mwanga", "Polele", "Omusana"],
    ["Mode sombre", "Dark mode", "Giza", "Molili", "Omwirima"],
    ["Automatique", "Automatic", "Kiotomatiki", "Na ndenge ya masini", "Eky'obwangu"],
    ["TABLEAU DE BORD", "DASHBOARD", "DASHIBODI", "TABLEAU DE BORD", "EKIFO KY'OKULENGERA"],
    ["GESTION DES ARTICLES", "ITEM MANAGEMENT", "USIMAMIZI WA BIDHAA", "BOSALELI YA BILOKO", "OBULONGOZI BW'EBINTU"],
    ["ACTIVITÉ COMMERCIALE", "BUSINESS ACTIVITY", "SHUGHULI ZA BIASHARA", "MISALA YA MOMBONGO", "EMIRIMO GY'OBUSUBUZI"],
    ["TRÉSORERIE", "TREASURY", "HAZINA", "MOSOLO", "EBY'OBUGAGGA"],
    ["ADMINISTRATION", "ADMINISTRATION", "USIMAMIZI", "BOSALELI", "OBULONGOZI"],
    ["CONFIGURATION", "SETTINGS", "MIPANGILIO", "BOBONGISI", "EBITEGEKANYI"],
    ["Bonjour, voici votre activité.", "Hello, here is your activity.", "Habari, hizi hapa shughuli zako.", "Mbote, talá misala na yo.", "Mbote, emirimo gyo eyi."],
    ["Votre stock, toujours maîtrisé.", "Your inventory, always under control.", "Hifadhi yako inadhibitiwa kila wakati.", "Stock na yo ezali ntango nyonso na bokonzi.", "Ebintu byo biri mu bulongozi bulungi."],
    ["Vos ventes.", "Your sales.", "Mauzo yako.", "Boteki na yo.", "Ebyagulibwa byo."],
    ["Vos caisses.", "Your cash registers.", "Makasha yako.", "Bakasa na yo.", "Bakasa bo."],
    ["Vos états financiers.", "Your financial statements.", "Taarifa zako za fedha.", "Raporo ya mosolo na yo.", "Ebibalo bya mali byo."],
    ["Créer un produit", "Create a product", "Unda bidhaa", "Sala biloko", "Kola ekintu"],
    ["Créer une catégorie", "Create a category", "Unda kategoria", "Sala lolenge", "Kola ekika"],
    ["Créer un client", "Create a customer", "Unda mteja", "Bakisa mokiliya", "Yongera omukiliya"],
    ["Créer un fournisseur", "Create a supplier", "Unda msambazaji", "Sala mopesi", "Kola omuwa"],
    ["Créer un utilisateur", "Create a user", "Unda mtumiaji", "Sala mosaleli", "Kola omukozesa"],
    ["Créer un rôle", "Create a role", "Unda jukumu", "Sala mokumba", "Kola omulimo"],
    ["Créer une succursale", "Create a branch", "Unda tawi", "Sala filiale", "Kola itabi"],
    ["Créer un approvisionnement", "Create a purchase", "Unda ununuzi", "Sala bosombi", "Kola okugula"],
    ["Enregistrer", "Save", "Hifadhi", "Bomba", "Bika"],
    ["Modifier", "Edit", "Hariri", "Bongola", "Kyusa"],
    ["Supprimer", "Delete", "Futa", "Longola", "Sangula"],
    ["Annuler", "Cancel", "Ghairi", "Kanga", "Sazaamu"],
    ["Précédent", "Previous", "Iliyotangulia", "Oyo eleki", "Ekyabanje"],
    ["Suivant", "Next", "Inayofuata", "Oyo elandi", "Ekinakola"],
    ["Chargement…", "Loading…", "Inapakia…", "Ezali kokɔta…", "Birimo kutwala…"],
    ["Chargement des utilisateurs…", "Loading users…", "Inapakia watumiaji…", "Bosaleli ezali kokɔta…", "Abakozesa barikutwala…"],
    ["Aucun client enregistré.", "No customers recorded.", "Hakuna wateja waliosajiliwa.", "Mokiliya moko te akomami.", "Tihali bakiliya bandikibwa."],
    ["Aucune succursale enregistrée.", "No branches recorded.", "Hakuna matawi yaliyosajiliwa.", "Filiale moko te ekomami.", "Tihali matabi bandikibwa."],
    ["Aucun utilisateur enregistré.", "No users recorded.", "Hakuna watumiaji waliosajiliwa.", "Mosaleli moko te akomami.", "Tihali bakozesa bandikibwa."],
    ["Actif", "Active", "Hai", "Polele", "Muli mulamu"],
    ["Inactif", "Inactive", "Haifanyi kazi", "Ezali kosala te", "Tiri mulamu"],
    ["Succursale mère", "Main branch", "Tawi kuu", "Filiale ya monene", "Itabi ery'enkulu"],
    ["Toutes les succursales", "All branches", "Matawi yote", "Bafiliale nyonso", "Amatabi gona"],
    ["Toute l’entreprise", "Entire company", "Kampuni nzima", "Kompanyi mobimba", "Ekitongole kyose"],
    ["Succursale (facultatif)", "Branch (optional)", "Tawi (si lazima)", "Filiale (na bolingi)", "Itabi (si ky'obuwaze)"],
    ["Rôle d’accès", "Access role", "Jukumu la ufikiaji", "Mokumba ya kokota", "Omulimo gw'okwingira"],
    ["Compte actif", "Active account", "Akaunti hai", "Compte ezali kosala", "Akawunti eri mulamu"],
    ["Administration", "Administration", "Usimamizi", "Bosaleli", "Obulongozi"],
    ["Gestion des accès", "Access management", "Usimamizi wa ufikiaji", "Bokonzi ya kokota", "Obulongozi bw'okwingira"],
    ["Nom complet", "Full name", "Jina kamili", "Kombo mobimba", "Erina lyose"],
    ["Adresse électronique", "Email address", "Anwani ya barua pepe", "Adrɛsi ya email", "Adrɛsi ya email"],
    ["Prix de vente", "Selling price", "Bei ya kuuza", "Ntalo ya koteka", "Omuwendo gw'okutunda"],
    ["Prix d’achat", "Purchase price", "Bei ya kununua", "Ntalo ya kosomba", "Omuwendo gw'okugula"],
    ["Quantité", "Quantity", "Kiasi", "Motango", "Obungi"],
    ["Date", "Date", "Tarehe", "Mokolo", "Olunaku"],
    ["Statut", "Status", "Hali", "Ezaleli", "Embeera"],
    ["Succursale de destination", "Destination branch", "Tawi lengwa", "Filiale ya kokende", "Itabi ery'okugendamu"],
    ["Paramètres", "Settings", "Mipangilio", "Bobongisi", "Ebitegekanisibwa"],
    ["Votre entreprise", "Your company", "Kampuni yako", "Kompanyi na yo", "Ekitongole ky'obe"],
    ["Créer une unité de mesure", "Create a unit of measure", "Unda kipimo", "Sala unité ya mesure", "Kola ekipimo"],
    ["Monnaie du prix", "Price currency", "Sarafu ya bei", "Mbongo ya ntalo", "Ssente z'omuwendo"],
    ["Description", "Description", "Maelezo", "Ndimbola", "Ennyinyonnyola"],
    ["Adresse", "Address", "Anwani", "Adrɛsi", "Adrɛsi"],
    ["Téléphone", "Phone", "Simu", "Telefone", "Telefone"],
    ["Thème activé", "Theme enabled", "Mandhari imewashwa", "Motindo efungwami", "Endabika ekole"],
    ["Langue d’affichage", "Display language", "Lugha ya kuonyesha", "Lokota ya kolakisa", "Olulimi olw'okulaga"],
    ["Connexion | ALBA-GEST", "Sign in | ALBA-GEST", "Ingia | ALBA-GEST", "Kota | ALBA-GEST", "Injira | ALBA-GEST"],
    ["Créer une entreprise | ALBA-GEST", "Create a company | ALBA-GEST", "Unda kampuni | ALBA-GEST", "Sala kompanyi | ALBA-GEST", "Kola ekitongole | ALBA-GEST"],
    ["Super administration | ALBA-GEST", "Super administration | ALBA-GEST", "Usimamizi mkuu | ALBA-GEST", "Bokonzi monene | ALBA-GEST", "Obulongozi obukulu | ALBA-GEST"],
    ["DÉMARREZ SIMPLEMENT", "GET STARTED EASILY", "ANZA KWA URAHISI", "BANDA NA LOLENGE YA PETEE", "TANDIKA MU BWANGU"],
    ["Une gestion plus claire,", "Clearer management,", "Usimamizi ulio wazi zaidi,", "Bokonzi ya polele koleka,", "Obulongozi obulengefu,"],
    ["dès aujourd’hui.", "starting today.", "kuanzia leo.", "kobanda lelo.", "okuva leero."],
    ["Créez l’espace de votre entreprise et centralisez le suivi de vos activités dans un outil unique.", "Create your company workspace and manage all your activities in one tool.", "Unda nafasi ya kampuni yako na ufuatilie shughuli zako zote katika zana moja.", "Salá esika ya kompanyi na landela misala na yo nyonso na esaleli moko.", "Kola ekifo ky'ekitongole kyo era olondole emirimo gyo mu kyuma kimu."],
    ["Votre espace professionnel", "Your professional workspace", "Nafasi yako ya kazi", "Esika na yo ya mosala", "Ekifo kyo eky'emirimo"],
    ["Un environnement dédié à votre entreprise et à votre équipe.", "A workspace dedicated to your company and your team.", "Mazingira maalum kwa kampuni na timu yako.", "Esika ebongisami mpo na kompanyi mpe ekipi na yo.", "Ekifo ekyategekebwa ekitongole kyo n'ekibinja kyo."],
    ["Activation accompagnée", "Guided activation", "Uwezeshaji unaosaidiwa", "Lisungi ya kofungola", "Obuyambi mu kufungula"],
    ["Votre demande est examinée avant l’ouverture de l’accès.", "Your request is reviewed before access is enabled.", "Ombi lako hukaguliwa kabla ya kufungua ufikiaji.", "Bosengi na yo ekotalama liboso ya kofungola nzela.", "Obusabe bwo bukenguzibwa nga tinnafungula."],
    ["ALBERT WORK · Solution de gestion", "ALBERT WORK · Management solution", "ALBERT WORK · Suluhisho la usimamizi", "ALBERT WORK · Esaleli ya bokonzi", "ALBERT WORK · Ekyuma ky'obulongozi"],
    ["Une gestion plus claire,", "Clearer management,", "Usimamizi ulio wazi zaidi,", "Bokonzi ya polele koleka,", "Obulongozi obulengefu,"],
    ["Créer votre entreprise", "Create your company", "Unda kampuni yako", "Sala kompanyi na yo", "Kola ekitongole ky'obe"],
    ["Votre demande a été enregistrée. Le super administrateur doit activer votre entreprise.", "Your request has been submitted. A super administrator must activate your company.", "Ombi lako limetumwa. Msimamizi mkuu lazima awashe kampuni yako.", "Bosengi na yo etindami. Mokambi monene asengeli kofungola kompanyi na yo.", "Obusabe bwo butumiddwa. Omukulu asaanidde okufungula ekitongole kyo."],
    ["Nom de l’entreprise", "Company name", "Jina la kampuni", "Kombo ya kompanyi", "Erina ly'ekitongole"],
    ["Email ou nom d’utilisateur", "Email or username", "Barua pepe au jina la mtumiaji", "Email to kombo ya mosaleli", "Email oba erina ly'omukozesa"],
    ["ALBA-GEST · Gestion de stock", "ALBA-GEST · Inventory management", "ALBA-GEST · Usimamizi wa hifadhi", "ALBA-GEST · Bokonzi ya stock", "ALBA-GEST · Obulongozi bwa stock"],
    ["NOUVEAUTÉS", "WHAT'S NEW", "HABARI MPYA", "MAKAMBO YA SIKA", "EBIPYA"],
    ["Les dernières améliorations", "Latest improvements", "Maboresho ya hivi karibuni", "Bobongisi ya sika", "Ebikyusiddwa ebipya"],
    ["Des outils conçus pour rendre votre gestion plus claire et plus fiable.", "Tools designed to make your management clearer and more reliable.", "Zana zilizoundwa kufanya usimamizi wako uwe wazi na wa kuaminika zaidi.", "Bisaleli ebongisami mpo na kosala ete bokonzi na yo ezala polele mpe ya kotyela motema.", "Ebikozesebwa okukola obulongozi bwo obulengefu era obwesigwa."],
    ["Rapports complets", "Complete reports", "Ripoti kamili", "Raporo mobimba", "Lipoota enzijuvu"],
    ["Totaux mieux séparés", "Clearer totals", "Jumla zilizotenganishwa vizuri", "Mitango ekabwani malamu", "Emibalirira egyawuddwamu bulungi"],
    ["Impression optimisée", "Optimized printing", "Uchapishaji ulioboreshwa", "Impression ebongisami", "Okufulumya empapula okulungi"],
    ["Stock sous le seuil minimum", "Stock below minimum threshold", "Hifadhi chini ya kiwango cha chini", "Stock na nse ya ndelo ya nse", "Stock eri wansi w'ekkomo"],
    ["Produit", "Product", "Bidhaa", "Eloko", "Ekintu"],
    ["Succursale", "Branch", "Tawi", "Filiale", "Itabi"],
    ["Quantité", "Quantity", "Kiasi", "Motango", "Obungi"],
    ["Seuil", "Threshold", "Kiwango", "Ndelo", "Ekkomo"],
    ["Référence", "Reference", "Rejea", "Référence", "Namba y'okulaga"],
    ["Catégorie", "Category", "Kategoria", "Lolenge", "Ekika"],
    ["Unité", "Unit", "Kipimo", "Unité", "Ekipimo"],
    ["État", "Condition", "Hali", "Ezaleli", "Embeera"],
    ["Actions", "Actions", "Vitendo", "Misala", "Emirimo"],
    ["Aucune catégorie enregistrée.", "No categories recorded.", "Hakuna kategoria zilizosajiliwa.", "Lolenge moko te ekomami.", "Tihali bika byandikibwa."],
    ["Aucun produit enregistré.", "No products recorded.", "Hakuna bidhaa zilizosajiliwa.", "Eloko moko te ekomami.", "Tihali bintu byandikibwa."],
    ["Aucun rôle enregistré.", "No roles recorded.", "Hakuna majukumu yaliyosajiliwa.", "Mokumba moko te ekomami.", "Tihali mirimo gyandikibwa."],
    ["Aucun approvisionnement enregistré.", "No purchases recorded.", "Hakuna manunuzi yaliyosajiliwa.", "Bosombi moko te ekomami.", "Tihali bigulibwa byandikibwa."],
    ["Aucune vente enregistrée.", "No sales recorded.", "Hakuna mauzo yaliyosajiliwa.", "Boteki moko te ekomami.", "Tihali bigulibwa byandikibwa."],
    ["Aucune caisse enregistrée.", "No cash registers recorded.", "Hakuna makasha yaliyosajiliwa.", "Kasa moko te ekomami.", "Tihali bakasa bandikibwa."],
    ["Toutes les succursales", "All branches", "Matawi yote", "Bafiliale nyonso", "Amatabi gona"],
    ["Rechercher un article ou une référence", "Search for an item or reference", "Tafuta bidhaa au rejea", "Luka eloko to référence", "Londera ekintu oba namba"],
    ["Catalogue produits", "Product catalog", "Orodha ya bidhaa", "Liste ya biloko", "Olukalala lw'ebintu"],
    ["Alerte de stock", "Stock alert", "Tahadhari ya hifadhi", "Likebisi ya stock", "Okulabula kwa stock"],
    ["Nouvelle vente", "New sale", "Mauzo mapya", "Boteki ya sika", "Ekyagulibwa ekipya"],
    ["Nouvelle écriture", "New journal entry", "Ingizo jipya", "Ekomami ya sika", "Ekiwandiiko ekipya"],
    ["Créer un compte", "Create an account", "Unda akaunti", "Sala compte", "Kola akawunti"],
    ["Générer un état", "Generate a report", "Tengeneza ripoti", "Bimisa raporo", "Kola lipoota"],
    ["Rapports complets", "Complete reports", "Ripoti kamili", "Raporo mobimba", "Lipoota enzijuvu"],
    ["Enregistrer une dette", "Record a debt", "Rekodi deni", "Komisa nyongo", "Wandiika ebbanja"],
    ["Ouvrir une caisse", "Open a cash register", "Fungua kasha", "Fungola kasa", "Fungula kasa"],
    ["Entrée manuelle", "Manual entry", "Ingizo la mkono", "Kokɔtisa na maboko", "Okuyingiza n'engalo"],
    ["Sortie manuelle", "Manual withdrawal", "Toleo la mkono", "Kobimisa na maboko", "Okufulumya n'engalo"],
    ["Périmètre", "Scope", "Wigo", "Ndelo", "Ekkomo"],
    ["Toute l’entreprise", "Entire company", "Kampuni nzima", "Kompanyi mobimba", "Ekitongole kyose"],
    ["Rechercher un espace…", "Search a section…", "Tafuta sehemu…", "Luka eteni…", "Londera ekifo…"],
    ["Aucun espace correspondant.", "No matching section.", "Hakuna sehemu inayolingana.", "Eteni oyo ekokani ezali te.", "Tihali kifo ekwatana."],
    ["Langue enregistrée dans votre compte.", "Language saved to your account.", "Lugha imehifadhiwa kwenye akaunti yako.", "Lokota ebombami na compte na yo.", "Olulimi lubikiddwa mu akawunti yo."],
    ["La langue ne peut pas être enregistrée.", "The language could not be saved.", "Lugha haikuweza kuhifadhiwa.", "Lokota ekokaki kobombama te.", "Olulimi terwasobose kubikkibwa."],
    ["Critères conseillés : 8 caractères, une minuscule, une majuscule, un chiffre, un caractère spécial.", "Suggested criteria: 8 characters, one lowercase letter, one uppercase letter, one number, and one special character.", "Vigezo vinavyopendekezwa: herufi 8, herufi ndogo, herufi kubwa, nambari na alama maalum.", "Makambo ya malamu: bilembo 8, lɛtre ya mike, ya minene, nimero mpe elembo ya sipesiale.", "Ebyetaagisa: ennukuta 8, ennukuta entono, ennene, namba n'akabonero ak'enjawulo."],
    ["Force : faible", "Strength: weak", "Nguvu: dhaifu", "Makasi: moke", "Amaani: matono"],
    ["Force : moyen", "Strength: medium", "Nguvu: wastani", "Makasi: ya katikati", "Amaani: ga wakati"],
    ["Force : fort", "Strength: strong", "Nguvu: imara", "Makasi: makasi", "Amaani: mangi"],
    ["Se connecter à votre espace sécurisé.", "Sign in to your secure space.", "Ingia kwenye nafasi yako salama.", "Kota na esika na yo ya libateli.", "Injira mu kifo kyo ekikuumire."],
    ["Activer", "Activate", "Washa", "Fungola", "Fungula"],
    ["Désactiver", "Deactivate", "Zima", "Fungola te", "Zikiza"],
    ["Entreprise", "Company", "Kampuni", "Kompanyi", "Ekitongole"],
    ["Nom utilisateur", "Username", "Jina la mtumiaji", "Kombo ya mosaleli", "Erina ly'omukozesa"],
    ["Date d’expiration du lot", "Lot expiration date", "Tarehe ya mwisho wa kundi", "Mokolo ya suka ya lot", "Olunaku lw'okuggwako kw'ekintu"],
    ["Ajouter un client", "Add a customer", "Ongeza mteja", "Bakisa mokiliya", "Yongera omukiliya"],
    ["Enregistrer le client", "Save customer", "Hifadhi mteja", "Bomba mokiliya", "Bika omukiliya"],
    ["Motif de sortie", "Withdrawal reason", "Sababu ya kutoa", "Ntina ya kobimisa", "Ensonga y'okufulumya"],
    ["Choisir un produit", "Choose a product", "Chagua bidhaa", "Pona eloko", "Londa ekintu"],
    ["Choisir un rôle", "Choose a role", "Chagua jukumu", "Pona mokumba", "Londa omulimo"],
    ["Choisir une unité", "Choose a unit", "Chagua kipimo", "Pona unité", "Londa ekipimo"],
    ["Sans catégorie", "No category", "Bila kategoria", "Lolenge te", "Tihali kika"],
    ["Sans succursale", "No branch", "Bila tawi", "Filiale te", "Tihali tabi"],
    ["Définir comme succursale mère", "Set as main branch", "Weka kama tawi kuu", "Poná yango filiale ya monene", "Tegeka libe itabi ery'enkulu"],
    ["Modifier le profil entreprise", "Edit company profile", "Hariri wasifu wa kampuni", "Bongola profil ya kompanyi", "Kyusa profili y'ekitongole"],
    ["Enregistrer le profil entreprise", "Save company profile", "Hifadhi wasifu wa kampuni", "Bomba profil ya kompanyi", "Bika profili y'ekitongole"],
    ["Se connecter", "Sign in", "Ingia", "Kota", "Injira"],
    ["Email", "Email", "Barua pepe", "Email", "Email"],
    ["Tout sélectionner", "Select all", "Chagua zote", "Pona nyonso", "Londa byonna"],
    ["Aucune donnée disponible.", "No data available.", "Hakuna data inayopatikana.", "Donnée ezali te.", "Tihali data."],
    ["Profil mis à jour.", "Profile updated.", "Wasifu umesasishwa.", "Profil ebongisami.", "Profili etereezeddwa."],
    ["Modifications enregistrées", "Changes saved", "Mabadiliko yamehifadhiwa", "Bobongisi ebombami", "Enkyukakyuka zibikiddwa"],
    ["Enregistrement effectué", "Saved successfully", "Imehifadhiwa", "Ebombami malamu", "Bikiddwa bulungi"],
    ["Élément supprimé.", "Item deleted.", "Kipengee kimefutwa.", "Eloko elongolami.", "Ekintu kisanguddwa."],
    ["Aucune notification disponible pour votre compte.", "No notifications are available for your account.", "Hakuna arifa zinazopatikana kwenye akaunti yako.", "Notification ezali te na compte na yo.", "Tihali bubaka bwa kulabula mu akawunti yo."],
    ["Ouvrir le menu", "Open menu", "Fungua menyu", "Fungola menu", "Fungula menu"],
    ["Fermer le menu", "Close menu", "Funga menyu", "Kanga menu", "Gala menu"],
    ["Paramètres", "Settings", "Mipangilio", "Bobongisi", "Ebitegekanisibwa"],
    ["Gestion des utilisateurs", "User management", "Usimamizi wa watumiaji", "Bokonzi ya basaleli", "Obulongozi bw'abakozesa"],
    ["Accès limité à votre succursale.", "Access limited to your branch.", "Ufikiaji umewekewa tawi lako.", "Kokota kaka na filiale na yo.", "Okuyingira kukoma ku tabi lyo."],
    ["ALBA-GEST | Pilotage intelligent", "ALBA-GEST | Smart business management", "ALBA-GEST | Usimamizi mahiri wa biashara", "ALBA-GEST | Bokonzi ya mayele ya mombongo", "ALBA-GEST | Obulongozi bw'obusuubuzi obw'amagezi"],
    ["Bonjour, ", "Hello, ", "Habari, ", "Mbote, ", "Mwasuze mutya, "],
    ["voici votre activité.", "here is your business overview.", "hizi hapa shughuli zako.", "talá misala na yo.", "laba emirimo gyo."],
    ["Indicateurs calculés depuis les données de votre entreprise.", "Metrics calculated from your company data.", "Vipimo vilivyokokotolewa kutoka data ya kampuni yako.", "Baindicateur etangami uta na ba données ya kompanyi na yo.", "Ebiraga ebibaliddwa okuva mu data y'ekitongole kyo."],
    ["Votre stock, ", "Your inventory, ", "Hifadhi yako, ", "Stock na yo, ", "Ebintu byo, "],
    ["toujours maîtrisé.", "always under control.", "inadhibitiwa kila wakati.", "ezali ntango nyonso na bokonzi.", "biri mu bulongozi bulungi."],
    ["Suivez les niveaux et les alertes de vos produits.", "Track your product levels and alerts.", "Fuatilia viwango na tahadhari za bidhaa zako.", "Landela motango ya biloko mpe makebisi na yango.", "Londoola obungi bw'ebintu byo n'okulabula kwabyo."],
    ["Vos ", "Your ", " ", " ", " "],
    ["ventes.", "sales.", "mauzo yako.", "boteki na yo.", "eby'obutunzi byo."],
    ["Créez des factures multi-produits avec remise et suivi des lots.", "Create multi-product invoices with discounts and batch tracking.", "Tengeneza ankara za bidhaa nyingi zenye punguzo na ufuatiliaji wa makundi.", "Sala ba facture ya biloko mingi na réduction mpe bolandi ya ba lot.", "Kola invoice ez'ebintu ebingi nga zirina ekisa n'okulondoola ebibinja."],
    ["caisses.", "cash registers.", "makasha yako.", "bakasa na yo.", "bakasa zo."],
    ["Ouvrez, suivez et clôturez les caisses de vos succursales.", "Open, monitor, and close your branch cash registers.", "Fungua, fuatilia na funga makasha ya matawi yako.", "Fungola, landela mpe kangá bakasa ya bafiliale na yo.", "Ggulawo, londoola era oggalewo bakasa z'amatabi go."],
    ["COMPTABILITÉ SYSCOHADA", "SYSCOHADA ACCOUNTING", "UHASIBU WA SYSCOHADA", "MOKOMISI SYSCOHADA", "EBIBALO BYA SYSCOHADA"],
    ["états financiers.", "financial statements.", "taarifa za fedha.", "raporo ya mosolo.", "ebibalo bya mali."],
    ["Consultez les états à partir des écritures comptables validées.", "Review statements based on validated accounting entries.", "Angalia taarifa kulingana na maingizo ya uhasibu yaliyothibitishwa.", "Talá ba rapport oyo euti na ba écritures ya mokomisi endimami.", "Kebera ebibalo ebiva mu biwandiiko by'ebyensimbi ebikkiriziddwa."],
    ["GESTION DES ACCÈS", "ACCESS MANAGEMENT", "USIMAMIZI WA UFIKIAJI", "BOKONZI YA KOKOTA", "OBULONGOZI BW'OKUYINGIRA"],
    ["Les bonnes personnes, ", "The right people, ", "Watu sahihi, ", "Bato oyo babongi, ", "Abantu abatuufu, "],
    ["les bons accès.", "the right access.", "ufikiaji sahihi.", "nzela oyo ebongi.", "n'obuyingizi obutuufu."],
    ["Gérez les comptes utilisateurs et leurs droits d’accès.", "Manage user accounts and their access permissions.", "Simamia akaunti za watumiaji na ruhusa zao za ufikiaji.", "Tala ba compte ya basaleli mpe ndingisa na bango ya kokota.", "Ddukanya akawunti z'abakozesa n'obuyinza bwabwe obw'okuyingira."],
    ["Succursales enregistrées dans la base de données.", "Branches registered in the database.", "Matawi yaliyosajiliwa kwenye hifadhidata.", "Bafiliale ekomami na base de données.", "Amatabi agawandiikiddwa mu database."],
    ["Clients enregistrés dans la base de données.", "Customers registered in the database.", "Wateja waliosajiliwa kwenye hifadhidata.", "Bakiliya bakomami na base de données.", "Bakiliya abawandiikiddwa mu database."],
    ["Examinez et traitez les demandes transmises à votre entreprise.", "Review and process requests sent to your company.", "Kagua na uchakate maombi yaliyotumwa kwa kampuni yako.", "Talá mpe salá makambo ya bansengi batindeli kompanyi na yo.", "Kebera era okole ku busabe obutumiddwa eri ekitongole kyo."],
    ["Votre ", "Your ", " ", " ", " "],
    ["entreprise.", "company.", "kampuni yako.", "kompanyi na yo.", "ekitongole kyo."],
    ["Modifiez votre profil et votre mot de passe.", "Update your profile and password.", "Badilisha wasifu na nenosiri lako.", "Bongola profil na yo mpe mot de passe.", "Kyusa profili yo n'akabiri ko."],
    ["Enregistrez les entrées et sorties de stock fournisseur.", "Record stock received from and returned to suppliers.", "Rekodi bidhaa zinazoingia kutoka kwa wasambazaji na zinazorejeshwa.", "Komá biloko oyo ekoti mpe ebimi epai ya bapesi biloko.", "Wandiika ebintu ebiyingira okuva eri abagaba n'ebiddizibwa."],
    ["Gestion des entreprises", "Company management", "Usimamizi wa kampuni", "Bokonzi ya bakompanyi", "Obulongozi bw'ebitongole"],
    ["Activez ou désactivez les comptes inscrits sur la plateforme.", "Activate or deactivate accounts registered on the platform.", "Washa au zima akaunti zilizosajiliwa kwenye mfumo.", "Fungola to kangá ba compte oyo bakomami na plateforme.", "Fungula oba zikiza akawunti eziwandiisiddwa ku mukutu."],
    ["Notifications email", "Email notifications", "Arifa za barua pepe", "Mayebisi ya email", "Obubaka bwa email"],
    ["Gérez les adresses qui reçoivent les nouvelles demandes de création d’entreprise.", "Manage the addresses that receive new company registration requests.", "Simamia anwani zinazopokea maombi mapya ya usajili wa kampuni.", "Tala ba adresse oyo bazwaka bansengi ya sika ya bokomi ya kompanyi.", "Ddukanya endagiriro ezifuna obusabe obupya obw'okuwandiisa ekitongole."],
    ["Super administrateurs", "Super administrators", "Wasimamizi wakuu", "Bakambi minene", "Abakulira abakulu"],
    ["Créez et consultez les comptes de super administration.", "Create and view super administrator accounts.", "Unda na uangalie akaunti za wasimamizi wakuu.", "Sala mpe tala ba compte ya bakambi minene.", "Kola era olabe akawunti z'abakulira abakulu."],
    ["Droits des modules", "Module permissions", "Ruhusa za moduli", "Ndingisa ya ba module", "Obuyinza bw'ebitundu"],
    ["Définissez les modules accessibles à chaque entreprise.", "Set which modules each company can access.", "Weka moduli ambazo kila kampuni inaweza kutumia.", "Poná ba module oyo kompanyi moko na moko akoki kosalela.", "Tegeka ebitundu buli kitongole bye kiyinza okukozesa."],
    ["Monnaies disponibles", "Available currencies", "Sarafu zinazopatikana", "Ba mbongo oyo ezali", "Ssente eziriwo"],
    ["Gérez les monnaies proposées lors de la création des produits.", "Manage the currencies offered when creating products.", "Simamia sarafu zinazotolewa wakati wa kuunda bidhaa.", "Tala ba mbongo oyo epesamaka ntango ya kosala biloko.", "Ddukanya ssente eziteekebwawo ng'ebintu bikolebwa."],
    ["Mon profil", "My profile", "Wasifu wangu", "Profil na ngai", "Profili yange"],
    ["Modifiez votre identité et votre mot de passe super administrateur.", "Update your super administrator identity and password.", "Badilisha utambulisho na nenosiri lako la msimamizi mkuu.", "Bongola kombo mpe mot de passe na yo ya mokambi monene.", "Kyusa erinnya lyo n'akabiri k'omukulu."],
    ["Formulaire de connexion", "Sign-in form", "Fomu ya kuingia", "Formulaire ya kokota", "Foomu y'okuyingira"],
    ["Votre mot de passe", "Your password", "Nenosiri lako", "Mot de passe na yo", "Akabiri ko"],
    ["Vous n’avez pas encore d’espace ?", "Don’t have a workspace yet?", "Bado huna nafasi ya kazi?", "Ozali naino na esika te?", "Tonnafuna kifo ky'emirimo?"],
    ["Afficher le mot de passe", "Show password", "Onyesha nenosiri", "Lakisa mot de passe", "Laga akabiri"],
    ["Masquer le mot de passe", "Hide password", "Ficha nenosiri", "Bomba mot de passe", "Kweka akabiri"],
    ["ACHATS", "PURCHASES", "UNUNUZI", "BOSOMBI", "OKUGULA"],
    ["RELATION CLIENT", "CUSTOMER RELATIONS", "UHUSIANO NA WATEJA", "BOYOKANI NA BAKILIYA", "ENKOLAGANA N'ABAKILIYA"],
  ];
  const translations = Object.fromEntries(rows.map(([fr, en, sw, ln, kn]) => [
    fr,
    {en, sw, ln, kn},
  ]));
  const sourceText = new WeakMap();
  const sourceAttributes = new WeakMap();
  let language = localStorage.getItem('westock-language') || 'fr';

  function translatedValue(original) {
    if (language === 'fr') return original;
    const key = original.trim();
    if (!key) return original;
    const exactReplacement = translations[original]?.[language];
    const replacement = exactReplacement ?? translations[key]?.[language];
    if (replacement) return exactReplacement !== undefined ? replacement : original.replace(key, replacement);
    const prefixedAction = original.match(/^(\s*[+＋]\s*)(.+)$/);
    if (prefixedAction) {
      const translatedAction = translatedValue(prefixedAction[2]);
      if (translatedAction !== prefixedAction[2]) return `${prefixedAction[1]}${translatedAction}`;
    }
    return original;
  }

  function translateText(node) {
    const state = sourceText.get(node);
    const original = state && node.nodeValue === state.rendered ? state.original : node.nodeValue;
    const translated = translatedValue(original);
    sourceText.set(node, {original, rendered: translated});
    if (node.nodeValue !== translated) node.nodeValue = translated;
  }

  function translateElement(element) {
    const walker = document.createTreeWalker(element, NodeFilter.SHOW_TEXT);
    const textNodes = [];
    while (walker.nextNode()) textNodes.push(walker.currentNode);
    textNodes.forEach(translateText);
    const attributeElements = [
      ...(element.matches?.('[placeholder], [title], [aria-label]') ? [element] : []),
      ...element.querySelectorAll('[placeholder], [title], [aria-label]'),
    ];
    for (const attributeElement of attributeElements) {
      for (const attribute of ['placeholder', 'title', 'aria-label']) {
        if (!attributeElement.hasAttribute(attribute)) continue;
        let states = sourceAttributes.get(attributeElement);
        if (!states) {
          states = {};
          sourceAttributes.set(attributeElement, states);
        }
        const state = states[attribute];
        const current = attributeElement.getAttribute(attribute);
        const original = state && current === state.rendered ? state.original : current;
        const translated = translatedValue(original);
        states[attribute] = {original, rendered: translated};
        if (current !== translated) attributeElement.setAttribute(attribute, translated);
      }
    }
  }

  function applyLanguage(nextLanguage) {
    if (!Object.hasOwn(languages, nextLanguage)) nextLanguage = 'fr';
    language = nextLanguage;
    localStorage.setItem('westock-language', language);
    document.documentElement.lang = languages[language].html;
    document.querySelectorAll('[data-interface-language]').forEach(select => {
      select.value = language;
    });
    translateElement(document.body);
    const originalTitle = document.body.dataset.originalTitle || document.title;
    document.title = language === 'fr'
      ? originalTitle
      : translatedValue(originalTitle);
  }

  function addLanguageSelector() {
    if (document.querySelector('[data-interface-language]')) return;
    const select = document.createElement('select');
    select.dataset.interfaceLanguage = '';
    select.setAttribute('aria-label', 'Langue d’affichage');
    Object.entries(languages).forEach(([code, definition]) => {
      const option = document.createElement('option');
      option.value = code;
      option.textContent = definition.label;
      select.append(option);
    });
    const wrapper = document.createElement('label');
    wrapper.className = 'interface-language-control';
    wrapper.append(select);
    const topActions = document.querySelector('.top-actions');
    const adminTop = document.querySelector('.admin-top');
    const authHeader = document.querySelector('.auth-simple-header');
    const registerBrand = document.querySelector('.register-brand');
    if (topActions) topActions.prepend(wrapper);
    else if (adminTop) adminTop.insertBefore(wrapper, adminTop.querySelector('button'));
    else if (authHeader) authHeader.append(wrapper);
    else if (registerBrand) registerBrand.append(wrapper);
    else document.body.prepend(wrapper);
  }

  document.body.dataset.originalTitle = document.title;
  addLanguageSelector();
  applyLanguage(language);
  document.addEventListener('change', event => {
    if (event.target.matches('[data-interface-language]')) {
      applyLanguage(event.target.value);
      window.dispatchEvent(new CustomEvent('interface-language-change', {detail: {language}}));
    }
  });
  const observer = new MutationObserver(records => {
    records.forEach(record => {
      if (record.type === 'characterData') translateText(record.target);
      if (record.type === 'attributes') translateElement(record.target);
      record.addedNodes?.forEach(node => {
        if (node.nodeType === Node.TEXT_NODE) translateText(node);
        else if (node.nodeType === Node.ELEMENT_NODE) translateElement(node);
      });
    });
  });
  observer.observe(document.body, {
    subtree: true,
    childList: true,
    characterData: true,
    attributes: true,
    attributeFilter: ['placeholder', 'title', 'aria-label'],
  });
  window.setInterfaceLanguage = applyLanguage;
  window.translateInterface = (root = document.body) => translateElement(root);
  window.getInterfaceLanguage = () => language;
})();

INSERT INTO users (username, email, full_name)
VALUES 
    ('Laura',  'andrei@gmail.com',  'Laura Voic'),
    ('Maria',   'maria@gmail.com',   'Maria Bulgaru'),
    ('Edi',    'edi@gmail.com',    'Eduard Popa'),
    ('Claudian',    'claudian@gmail.com',    'Claudian Chirita');

INSERT INTO tasks (title, description, status, priority, due_date, assignee_id)
VALUES
    ('Implement login', 'Creare pagina de autentificare + validari', 'IN_PROGRESS', 'HIGH', '2025-03-01', 1),
    ('Setup baza de date', 'Crearea structurilor SQL si a migratiilor', 'DONE', 'MEDIUM', '2025-02-15', 1),

    ('Design homepage', 'Realizarea layout-ului initial pentru homepage', 'TODO', 'LOW', '2025-03-10', 2),
    ('Fix bug #12', 'Error la pagina de profil cand utilizatorul nu are avatar', 'IN_PROGRESS', 'HIGH', '2025-02-28', 2),

    ('Scrie documentatie', 'Documentatie tehnica pentru proiect', 'TODO', 'MEDIUM', '2025-03-05', 3),
    ('Refactorizare API', 'Curatare cod si optimizare endpoint-uri', 'CANCELLED', 'LOW', NULL, 3);


INSERT INTO tasks (title, description, status, priority, due_date, assignee_id, created_at) VALUES
-- 1. Authentication & Onboarding
('Implementare flow de înregistrare', 'Creare API endpoint pentru sign-up utilizatori noi cu validare email.', 'DONE', 'HIGH', '2023-10-01', 1, NOW() - INTERVAL '10 days'),
('Integrare serviciu KYC', 'Conectare la provider extern (ex: Onfido) pentru verificarea identității utilizatorilor.', 'IN_PROGRESS', 'HIGH', '2023-10-25', 2, NOW() - INTERVAL '5 days'),
('Design ecran Login', 'Creare wireframes și UI final pentru ecranul de autentificare în Figma.', 'DONE', 'MEDIUM', '2023-09-20', 3, NOW() - INTERVAL '15 days'),
('Implementare 2FA via SMS', 'Adăugare strat de securitate secundar folosind Twilio pentru SMS OTP.', 'TODO', 'HIGH', '2023-11-01', 4, NOW()),
('Resetare parolă flow', 'Implementare logică de "Forgot Password" cu token pe email.', 'TODO', 'MEDIUM', '2023-11-05', 1, NOW()),
('Validare biometrică Android', 'Integrare Fingerprint API pentru login rapid pe Android.', 'IN_PROGRESS', 'MEDIUM', '2023-10-30', 2, NOW() - INTERVAL '2 days'),
('Validare FaceID iOS', 'Implementare FaceID pentru autentificare pe dispozitivele Apple.', 'TODO', 'MEDIUM', '2023-11-10', 3, NOW()),
('Termeni și Condiții (GDPR)', 'Actualizare text legal în aplicație și checkbox obligatoriu la sign-up.', 'DONE', 'HIGH', '2023-10-05', 4, NOW() - INTERVAL '12 days'),
('Logare activitate utilizator', 'Creare tabel audit_logs pentru a stoca toate acțiunile de login.', 'IN_PROGRESS', 'LOW', '2023-10-28', 1, NOW() - INTERVAL '3 days'),
('Blocare cont după încercări eșuate', 'Limitare la 5 încercări greșite de parolă înainte de blocare temporară.', 'TODO', 'HIGH', '2023-11-02', 2, NOW()),

-- 2. Accounts & Core Banking
('Generare IBAN RO', 'Algoritm de generare IBAN unic pentru conturile noi create.', 'DONE', 'HIGH', '2023-09-30', 3, NOW() - INTERVAL '20 days'),
('Creare tabel solduri (Balances)', 'Design schema bază de date pentru a stoca soldurile în multiple valute.', 'DONE', 'HIGH', '2023-09-15', 4, NOW() - INTERVAL '25 days'),
('API Conversie Valutară', 'Integrare API extern pentru rate de schimb live (EUR/RON/USD).', 'IN_PROGRESS', 'HIGH', '2023-10-29', 1, NOW() - INTERVAL '4 days'),
('Setare limite tranzacționale', 'Implementare limite zilnice default pentru utilizatori noi.', 'TODO', 'MEDIUM', '2023-11-15', 2, NOW()),
('Deschidere cont economii', 'Feature pentru utilizatori să deschidă "Vaults" separate.', 'TODO', 'MEDIUM', '2023-11-20', 3, NOW()),
('Calcul dobândă lunară', 'Cron job care rulează la final de lună pentru conturile de economii.', 'TODO', 'LOW', '2023-12-01', 4, NOW()),
('Export extras de cont PDF', 'Generare PDF cu tranzacțiile lunare pentru utilizator.', 'IN_PROGRESS', 'MEDIUM', '2023-11-05', 1, NOW() - INTERVAL '1 day'),
('Feature: Ascundere sold', 'Opțiune în UI pentru a blura suma totală din dashboard.', 'DONE', 'LOW', '2023-10-10', 2, NOW() - INTERVAL '8 days'),
('Validare unicitate CNP', 'Asigurare că un singur CNP nu poate avea două conturi de bază.', 'DONE', 'HIGH', '2023-09-25', 3, NOW() - INTERVAL '18 days'),
('Sincronizare ledger', 'Sistem de reconciliere zilnică între baza de date internă și contul colector.', 'TODO', 'HIGH', '2023-11-12', 4, NOW()),

-- 3. Cards (Virtual & Physical)
('Design card virtual (SVG)', 'Creare asset-uri vizuale pentru cardul afișat în aplicație.', 'DONE', 'MEDIUM', '2023-10-12', 1, NOW() - INTERVAL '6 days'),
('Generare PAN (Card Number)', 'Integrare cu procesatorul de plăți pentru emitere numere card.', 'IN_PROGRESS', 'HIGH', '2023-10-31', 2, NOW() - INTERVAL '5 days'),
('Setare PIN card', 'API securizat pentru setarea inițială a PIN-ului.', 'TODO', 'HIGH', '2023-11-08', 3, NOW()),
('Blocare/Deblocare card', 'Toggle în aplicație pentru a îngheța instant cardul.', 'DONE', 'HIGH', '2023-10-15', 4, NOW() - INTERVAL '7 days'),
('Comandă card fizic', 'Flow de UI pentru introducerea adresei de livrare.', 'TODO', 'MEDIUM', '2023-11-18', 1, NOW()),
('Generare CVV dinamic', 'Feature de securitate: CVV care se schimbă în app la cerere.', 'TODO', 'LOW', '2023-12-05', 2, NOW()),
('Integrare Apple Pay', 'Configurare certificare și API pentru adăugare card în Apple Wallet.', 'IN_PROGRESS', 'HIGH', '2023-11-25', 3, NOW() - INTERVAL '10 days'),
('Integrare Google Pay', 'Configurare push provisioning pentru Google Wallet.', 'IN_PROGRESS', 'HIGH', '2023-11-25', 4, NOW() - INTERVAL '10 days'),
('Notificare expirare card', 'Sistem automat de email cu 30 de zile înainte de expirare.', 'TODO', 'LOW', '2024-01-10', 1, NOW()),
('Design ambalaj card', 'Concept grafic pentru plicul și cutia cardului fizic.', 'DONE', 'LOW', '2023-09-10', 2, NOW() - INTERVAL '30 days'),

-- 4. Payments & Transactions
('Plăți interne P2P', 'Transfer instant între utilizatorii aplicației folosind număr de telefon.', 'DONE', 'HIGH', '2023-10-20', 3, NOW() - INTERVAL '9 days'),
('Integrare SEPA Credit Transfer', 'Implementare standard XML pentru plăți în zona Euro.', 'IN_PROGRESS', 'HIGH', '2023-11-10', 4, NOW() - INTERVAL '15 days'),
('Plăți Instant (București)', 'Conectare la sistemul național de plăți instant (dacă este cazul).', 'TODO', 'HIGH', '2023-12-01', 1, NOW()),
('Scanare QR Code', 'Feature de plată prin scanarea unui cod QR standard.', 'TODO', 'MEDIUM', '2023-11-30', 2, NOW()),
('Categorisire automată tranzacții', 'Algoritm ML simplu pentru a eticheta cheltuielile (Mâncare, Transport).', 'IN_PROGRESS', 'MEDIUM', '2023-11-15', 3, NOW() - INTERVAL '2 days'),
('Istoric tranzacții - Backend', 'Query optimizat pentru a returna ultimele 50 tranzacții rapid.', 'DONE', 'HIGH', '2023-10-05', 4, NOW() - INTERVAL '14 days'),
('Istoric tranzacții - UI', 'Componentă React Native pentru lista infinită de tranzacții.', 'DONE', 'MEDIUM', '2023-10-08', 1, NOW() - INTERVAL '13 days'),
('Plăți recurente (Standing Orders)', 'Sistem pentru programarea plăților lunare (chirie, utilități).', 'TODO', 'MEDIUM', '2023-12-10', 2, NOW()),
('Bugfix: Decimal rounding', 'Corectare eroare rotunjire la a 3-a zecimală la schimb valutar.', 'DONE', 'HIGH', '2023-10-22', 3, NOW() - INTERVAL '3 days'),
('Implementare Request Money', 'Generare link de plată pentru a cere bani de la prieteni.', 'TODO', 'LOW', '2023-12-15', 4, NOW()),

-- 5. Infrastructure & DevOps
('Configurare Cluster Kubernetes', 'Setup inițial mediu de producție pe AWS EKS.', 'DONE', 'HIGH', '2023-09-01', 1, NOW() - INTERVAL '40 days'),
('Setup Pipeline CI/CD', 'Automatizare teste și deployment via GitHub Actions.', 'DONE', 'HIGH', '2023-09-05', 2, NOW() - INTERVAL '38 days'),
('Configurare PostgreSQL Replica', 'Setup read-replica pentru a reduce load-ul pe baza principală.', 'IN_PROGRESS', 'HIGH', '2023-10-28', 3, NOW() - INTERVAL '4 days'),
('Implementare Redis Caching', 'Cache pentru profilul utilizatorului și setări frecvente.', 'DONE', 'MEDIUM', '2023-10-15', 4, NOW() - INTERVAL '11 days'),
('Monitorizare cu Prometheus', 'Setup metrici infrastructură și dashboard Grafana.', 'TODO', 'MEDIUM', '2023-11-20', 1, NOW()),
('Centralizare Log-uri (ELK)', 'Configurare ElasticSearch pentru log-urile aplicației.', 'TODO', 'LOW', '2023-12-01', 2, NOW()),
('Backup automat S3', 'Script zilnic pentru dump bază de date și upload în S3.', 'DONE', 'HIGH', '2023-09-10', 3, NOW() - INTERVAL '35 days'),
('Securizare VPC', 'Review reguli firewall și access lists pentru baza de date.', 'IN_PROGRESS', 'HIGH', '2023-10-30', 4, NOW() - INTERVAL '1 day'),
('Dockerizare microservicii', 'Creare Dockerfiles optimizate pentru serviciile de payments și auth.', 'DONE', 'HIGH', '2023-09-12', 1, NOW() - INTERVAL '33 days'),
('Load Testing', 'Simulare 10k utilizatori concurenți folosind k6.', 'TODO', 'HIGH', '2023-11-30', 2, NOW()),

-- 6. Notifications & Support
('Setup Firebase Cloud Messaging', 'Configurare proiect Firebase pentru notificări push.', 'DONE', 'MEDIUM', '2023-10-01', 3, NOW() - INTERVAL '18 days'),
('Notificare: Salariu primit', 'Trigger notificare "Cha-ching!" când intră o sumă mare.', 'TODO', 'LOW', '2023-11-25', 4, NOW()),
('Centru de suport in-app', 'Integrare Intercom sau chat intern pentru suport clienți.', 'IN_PROGRESS', 'HIGH', '2023-11-05', 1, NOW() - INTERVAL '3 days'),
('Template-uri Email Tranzacționale', 'Design HTML pentru email-uri (Welcome, Reset Password).', 'DONE', 'MEDIUM', '2023-10-10', 2, NOW() - INTERVAL '12 days'),
('FAQ Section API', 'Endpoint pentru a servi lista de întrebări frecvente dinamic.', 'DONE', 'LOW', '2023-10-12', 3, NOW() - INTERVAL '10 days'),
('Sondaj feedback utilizatori', 'Popup după prima tranzacție reușită.', 'TODO', 'LOW', '2023-12-05', 4, NOW()),
('Alertă tranzacție suspectă', 'Notificare automată dacă locația plății diferă drastic de țară.', 'IN_PROGRESS', 'HIGH', '2023-11-10', 1, NOW() - INTERVAL '2 days'),
('Bugfix: Notificări duble', 'Rezolvare bug unde userii primeau două push-uri la o plată.', 'DONE', 'HIGH', '2023-10-25', 2, NOW() - INTERVAL '1 day'),
('Setări preferințe notificări', 'Ecran unde userul alege ce notificări vrea să primească.', 'TODO', 'MEDIUM', '2023-11-20', 3, NOW()),
('Chatbot flow inițial', 'Configurare răspunsuri automate pentru întrebări simple.', 'TODO', 'LOW', '2023-12-15', 4, NOW()),

-- 7. Analytics & Data
('Dashboard Admin', 'Panou intern pentru echipa de suport să vadă statusul conturilor.', 'IN_PROGRESS', 'HIGH', '2023-11-15', 1, NOW() - INTERVAL '6 days'),
('Tracking evenimente (Mixpanel)', 'Integrare analitice pentru a măsura conversia la sign-up.', 'DONE', 'MEDIUM', '2023-10-05', 2, NOW() - INTERVAL '17 days'),
('Raport zilnic lichiditate', 'Script SQL pentru CFO cu banii intrați vs ieșiți.', 'DONE', 'HIGH', '2023-10-20', 3, NOW() - INTERVAL '8 days'),
('Analiză churn rate', 'Identificare useri care nu au mai intrat de 30 de zile.', 'TODO', 'MEDIUM', '2023-12-01', 4, NOW()),
('Optimizare query dashboard', 'Adăugare index pe coloana created_at în tabelul transactions.', 'DONE', 'HIGH', '2023-10-28', 1, NOW() - INTERVAL '2 days'),
('Export date CSV Admin', 'Buton export date utilizatori pentru echipa de compliance.', 'TODO', 'MEDIUM', '2023-11-18', 2, NOW()),
('KPIs Dashboard', 'Vizualizare număr utilizatori activi zilnic (DAU).', 'IN_PROGRESS', 'LOW', '2023-11-08', 3, NOW() - INTERVAL '4 days'),
('ETL Pipeline', 'Setup pipeline de date către Data Warehouse (Snowflake/BigQuery).', 'TODO', 'HIGH', '2024-01-15', 4, NOW()),
('Segmentare clienți', 'Etichetare automată: Student, Professional, Business.', 'TODO', 'LOW', '2023-12-20', 1, NOW()),
('Verificare integritate date', 'Script check consistency pentru solduri negative.', 'DONE', 'HIGH', '2023-09-30', 2, NOW() - INTERVAL '25 days'),

-- 8. Compliance & Security (AML/Fraud)
('Integrare lista sancțiuni', 'Check automat la onboarding împotriva listelor teroriste (PEP/Sanctions).', 'DONE', 'HIGH', '2023-09-20', 3, NOW() - INTERVAL '28 days'),
('Regulă AML: Tranzacții > 10k', 'Flag automat pentru tranzacții care depășesc 10.000 EUR.', 'DONE', 'HIGH', '2023-10-01', 4, NOW() - INTERVAL '22 days'),
('Blocare IP-uri riscante', 'Integrare serviciu geo-ip pentru a bloca țări sancționate.', 'IN_PROGRESS', 'MEDIUM', '2023-11-01', 1, NOW() - INTERVAL '5 days'),
('Audit securitate extern', 'Pregătire documentație și mediu pentru pentest.', 'TODO', 'HIGH', '2023-11-30', 2, NOW()),
('Encryption at Rest', 'Verificare criptare date sensibile (CNP, Adresă) în DB.', 'DONE', 'HIGH', '2023-09-15', 3, NOW() - INTERVAL '35 days'),
('Logare acces date sensibile', 'Sistem de alertă când un admin accesează date personale.', 'TODO', 'HIGH', '2023-12-05', 4, NOW()),
('Formular raportare fraudă', 'Feature în app pentru ca userul să raporteze o tranzacție.', 'TODO', 'MEDIUM', '2023-11-25', 1, NOW()),
('Review manual conturi flaguite', 'Interfață pentru ofițerul de compliance.', 'IN_PROGRESS', 'HIGH', '2023-11-10', 2, NOW() - INTERVAL '2 days'),
('Actualizare Privacy Policy', 'Modificare text legal conform noilor directive UE.', 'TODO', 'LOW', '2023-12-10', 3, NOW()),
('Training Security', 'Sesiune de phishing awareness pentru angajați.', 'DONE', 'LOW', '2023-10-15', 4, NOW() - INTERVAL '10 days'),

-- 9. UI/UX Refinements
('Dark Mode', 'Implementare temă întunecată pentru toată aplicația.', 'IN_PROGRESS', 'MEDIUM', '2023-11-15', 1, NOW() - INTERVAL '7 days'),
('Animație splash screen', 'Design și implementare Lottie animation la deschiderea app.', 'DONE', 'LOW', '2023-10-05', 2, NOW() - INTERVAL '15 days'),
('Accesibilizare (a11y)', 'Adăugare label-uri pentru screen readers pe butoane.', 'TODO', 'LOW', '2023-12-01', 3, NOW()),
('Micro-interacțiuni butoane', 'Feedback haptic și vizual la apăsarea butoanelor.', 'DONE', 'LOW', '2023-10-20', 4, NOW() - INTERVAL '9 days'),
('Refactorizare CSS/Styles', 'Curățare cod stilizare duplicat în componentele React.', 'TODO', 'LOW', '2024-01-05', 1, NOW()),
('Widget iOS', 'Creare widget pentru ecranul principal cu soldul curent.', 'TODO', 'MEDIUM', '2023-12-15', 2, NOW()),
('Optimizare fonturi', 'Reducere dimensiune fișiere font pentru încărcare rapidă.', 'DONE', 'LOW', '2023-10-10', 3, NOW() - INTERVAL '14 days'),
('Ecran "Despre noi"', 'Pagină informativă cu versiunea aplicației și link-uri.', 'DONE', 'LOW', '2023-09-25', 4, NOW() - INTERVAL '26 days'),
('Skeleton loading screens', 'Implementare stări de încărcare pentru dashboard.', 'IN_PROGRESS', 'MEDIUM', '2023-11-05', 1, NOW() - INTERVAL '1 day'),
('Iconiță nouă aplicație', 'Design și update app icon pentru sărbători.', 'TODO', 'LOW', '2023-12-20', 2, NOW()),

-- 10. Miscellaneous & Bugs
('Fix crash Android 12', 'Rezolvare crash la pornire pe anumite modele Samsung.', 'DONE', 'HIGH', '2023-10-27', 3, NOW() - INTERVAL '2 days'),
('Update dependințe npm', 'Actualizare librării la ultimele versiuni stabile.', 'TODO', 'LOW', '2023-11-10', 4, NOW()),
('Curățare date test', 'Script pentru ștergerea conturilor de test din producție.', 'DONE', 'HIGH', '2023-09-01', 1, NOW() - INTERVAL '45 days'),
('Documentație API (Swagger)', 'Generare automată documentație pentru parteneri.', 'IN_PROGRESS', 'MEDIUM', '2023-11-12', 2, NOW() - INTERVAL '3 days'),
('Setup mediu Staging', 'Creare mediu identic cu prod pentru testare finală.', 'DONE', 'HIGH', '2023-09-15', 3, NOW() - INTERVAL '32 days'),
('Optimizare imagini CDN', 'Configurare redimensionare automată imagini în Cloudflare.', 'TODO', 'LOW', '2023-12-05', 4, NOW()),
('Review cod module vechi', 'Tech debt cleanup pentru modulul de notificări.', 'TODO', 'LOW', '2024-01-10', 1, NOW()),
('Fix typo în meniu', 'Corectare greșeală gramaticală în setări.', 'DONE', 'LOW', '2023-10-18', 2, NOW() - INTERVAL '11 days'),
('Testare pe tablete', 'Verificare layout pe iPad și tablete Android.', 'TODO', 'LOW', '2023-12-25', 3, NOW()),
('Planificare Q4', 'Meeting pentru roadmap-ul pe ultimele 3 luni.', 'DONE', 'MEDIUM', '2023-10-01', 4, NOW() - INTERVAL '25 days');


INSERT INTO tasks (title, description, status, priority, assignee_id, created_at, updated_at, due_date)
SELECT
    -- Generare Titlu (Combinăm Acțiuni + Subiecte + Context)
    (ARRAY[
        'Implementare', 'Refactorizare', 'Optimizare', 'Debugging', 'Testare', 'Audit', 'Design', 'Deploy', 'Monitorizare', 'Securizare'
    ])[floor(random() * 10 + 1)] || ' ' ||
    (ARRAY[
        'API SEPA', 'Microserviciu Auth', 'Flow KYC', 'Generare IBAN', 'Carduri Virtuale', 'Notificări Push', 
        'Dashboard React', 'Baza de date Transactională', 'Sistem Anti-Fraudă', 'Wallet Digital', 'Integrare Apple Pay', 
        'Curs Valutar', 'Export CSV', 'Login Biometric', 'Pipeline CI/CD', 'Cluster Kubernetes'
    ])[floor(random() * 16 + 1)] || ' ' ||
    (ARRAY[
        'v2.0', 'pentru iOS', 'pentru Android', 'Legacy', 'High Performance', 'GDPR Compliant', 'Hotfix', 'Backlog'
    ])[floor(random() * 8 + 1)] as title,

    --  Generare Descriere
    'Task generat automat pentru sprint-ul curent. Necesită verificare pe mediul de ' || 
    (ARRAY['Staging', 'Development', 'Production', 'QA'])[floor(random() * 4 + 1)] || 
    '. Prioritate axată pe ' || 
    (ARRAY['performanță', 'securitate', 'UX', 'scalabilitate', 'compliance'])[floor(random() * 5 + 1)] || '.',

    -- Status 
    (ARRAY['TODO', 'IN_PROGRESS', 'DONE']::task_status[])[floor(random() * 3 + 1)],

    -- Prioritate
    (ARRAY['LOW', 'MEDIUM', 'HIGH']::task_priority[])[floor(random() * 3 + 1)],

    -- Assignee ID 
    floor(random() * 4 + 1)::bigint,

    -- Created At 
    NOW() - (random() * (INTERVAL '365 days')),

    -- Updated At 
    NOW(),

    -- Due Date
    NOW() + (random() * (INTERVAL '60 days'))

FROM generate_series(1, 10000);
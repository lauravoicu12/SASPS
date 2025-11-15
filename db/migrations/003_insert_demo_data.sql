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

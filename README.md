# Descriere proiect
Studiu comparativ privind eficiența și mentenabilitatea între accesul direct la ORM și utilizarea Repository Pattern într-o aplicație web de tip Task Manager

Proiectul își propune să analizeze diferențele arhitecturale și de mentenabilitate între două abordări de acces la date folosite în aplicațiile Java moderne:
Acces direct la ORM – logica de business interacționează direct cu entitățile JPA și cu EntityManager, realizând operațiile CRUD prin apeluri directe 
Repository Pattern – un strat intermediar dedicat (Repository) este introdus între logica de business și ORM, separând complet detaliile de persistenta de logica aplicației

Se vor implementa două versiuni ale aceleiași aplicații de tip Task Manager, care permite autentificare, creare, modificare și ștergere de task-uri.
Cele două abordări comparate sunt:
Varianta A: acces direct la ORM (logica de business comunică direct cu SQLAlchemy);
Varianta B: folosirea Repository Pattern, care adaugă un strat intermediar între logică și ORM, pentru a obține o arhitectură mai clară și testabilă.

# Aspecte comparate
Claritatea codului
- ORM Direct: Logica de business și accesul la date sunt amestecate
- Repository Pattern: Logica de business este separată de persistenta datelor
Testabilitate
- ORM Direct: Testele unitare sunt greu de izolat
- Repository Pattern: Repository-urile pot fi simulate (mocked) ușor
Mentenabilitate
- ORM Direct: Modificările de ORM afectează toate componentele
- Repository Pattern: Doar repository-ul trebuie modificat
Performanță
- ORM Direct: Ușor mai eficient (fără strat intermediar)
- Repository Pattern: Mic overhead, dar arhitectură mai curată

Vor fi analizați următorii indicatori:
- Complexitatea ciclomatică a claselor Service și Controller (prin SonarLint / IntelliJ Metrics)
- Numărul de linii de cod și duplicări între versiuni
- Timpul de execuție pentru operații CRUD repetate (insert, update, query)
- Ușurința de testare (număr de teste unitare, cod acoperit, mocking posibil)

# Design patterns utilizate
Repository:	Separarea logicii de acces la date: Fiecare entitate are un repository dedicat (TaskRepository, UserRepository) cu metode CRUD
Service Layer: Logica de business:	Conține regulile de business și utilizează repository-urile pentru manipularea datelor
Dependency Injection (Spring):	Gestionarea dependențelor:	Permite injectarea automată a componentelor (Service / Repository) fără coupling puternic
Singleton (implicit în Spring Beans):	Gestionarea instanțelor de servicii și repository-uri: Spring gestionează ciclul de viață al componentelor

# Tehnologii propuse
- Limbaj: Java 17
- Framework web: Spring Boot
- ORM: Hibernate (JPA)
- Bază de date: PostgreSQL
- Testare:	JUnit 5 + Mockito
- Analiză cod:	SonarLint / IntelliJ Metrics Plugin
- Build & Dependency Management:	Maven

# Concluzii asteptate
- Demonstrată superioritatea structurală a Repository Pattern în proiecte de dimensiuni medii/mari
- Arătarea unui trade-off mic între claritate și performanță
- Repository Pattern → mai bun pentru mentenabilitate, testabilitate, extensibilitate

# Zensus 2022 - ETL- und Data Warehouse Projekt
## Projektbeschreibung
In diesem Projekt wurden die Zensusdaten 2022 aus Deutschland systematisch verarbeitet. Ziel war es, die Rohdaten aus Excel-Dateien zu bereinigen, in die zweite Normalform zu überführen und anschließend in ein Sternschema innerhalb einer PostgreSQL-Datenbank zu integrieren. Der Fokus lag auf der Schaffung einer stabilen, skalierbaren Basis für relationale und multidimensionale Analysen (ROLAP).

Projektstruktur
ETL-Prozess: Datenextraktion, Transformation und Laden in PostgreSQL

Normalisierung: Überführung der Daten in die zweite Normalform (2NF)

Datenmodellierung: Aufbau eines Sternschemas für OLAP-Abfragen

Technologie: Kombination relationaler und multidimensionaler Datenbankarchitektur

Verwendete Technologien
Python

pandas

SQLAlchemy

psycopg2

PostgreSQL

SQLTools (VS Code Plugin)

Visual Studio Code

Installation
Python-Umgebung einrichten

Abhängigkeiten installieren:

nginx
Kopieren
Bearbeiten
pip install pandas sqlalchemy psycopg2
PostgreSQL-Datenbank erstellen und konfigurieren

Skript zur Datenverarbeitung und -übertragung ausführen

Features
Vollständiger ETL-Prozess von Excel zu PostgreSQL

Umsetzung eines Sternschemas

Unterstützung relationaler und OLAP-basierter Analysen

Bereinigung fehlerhafter Werte und Behandlung fehlender Daten

Hinweise
Die Daten enthalten NA-Werte für einige Gemeinden ohne Zuordnung zu Gemeindeverbänden.

Aggregierte Werte können von den erwarteten Summen leicht abweichen.

Autor
Dennis Reimer – August 2024

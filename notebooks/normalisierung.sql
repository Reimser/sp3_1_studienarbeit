-- Tabelle Region erstellen
CREATE TABLE Region (
    region_id INTEGER PRIMARY KEY,
    Name TEXT,
    Regionalebene INTEGER
);

-- Tabelle Wirtschaftszweig erstellen
CREATE TABLE Wirtschaftszweig (
    wz_id INTEGER PRIMARY KEY,
    ET_WIRTSZWG_STP INTEGER,
    ET_WIRTSZWG_STP__M INTEGER,
    ET_WIRTSZWG_STP__W INTEGER
);

-- Faktentabelle Wirtschaftszweig_Region erstellen
CREATE TABLE Wirtschaftszweig_Region (
    bericht_id INTEGER PRIMARY KEY,
    Berichtszeitpunkt TEXT,
    region_id INTEGER,
    wz_id INTEGER,
    ET_WIRTSZWG_STP__1 INTEGER,
    -- Weitere Spalten hier
    FOREIGN KEY (region_id) REFERENCES Region(region_id),
    FOREIGN KEY (wz_id) REFERENCES Wirtschaftszweig(wz_id)
);
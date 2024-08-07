-- Sicherstellen, dass jede Dimensionstabelle einen Primärschlüssel hat
ALTER TABLE dim_bund ADD PRIMARY KEY (Bundschluessel);
ALTER TABLE dim_land ADD PRIMARY KEY (Landesschluessel);
ALTER TABLE dim_gemeinde ADD PRIMARY KEY (Gemeindeschluessel);
ALTER TABLE dim_gemeindeverband ADD PRIMARY KEY (Gemeindeverbandsschluessel);
ALTER TABLE dim_regierungsbezirk ADD PRIMARY KEY (RegBezirkschluessel);
ALTER TABLE dim_stadtkreiskreisfreiestadtlandkreis ADD PRIMARY KEY (Kreisschluessel);
ALTER TABLE dim_stadt_typen ADD PRIMARY KEY (Schluessel);

ALTER TABLE dim_klassenstufe ADD PRIMARY KEY (Schluessel);
ALTER TABLE dim_schulform ADD PRIMARY KEY (Schluessel);
ALTER TABLE dim_hoechster_schulabschluss ADD PRIMARY KEY (Schluessel);
ALTER TABLE dim_hoechster_berufl_abschluss ADD PRIMARY KEY (Schluessel);
ALTER TABLE dim_erwerbsstatus ADD PRIMARY KEY (Schluessel);
ALTER TABLE dim_et_alter ADD PRIMARY KEY (Schluessel);
ALTER TABLE dim_et_hoechst_berufl_abschl ADD PRIMARY KEY (Schluessel);
ALTER TABLE dim_et_stellung_im_beruf ADD PRIMARY KEY (Schluessel);
ALTER TABLE dim_et_beruf_hauptgr_isco08 ADD PRIMARY KEY (Schluessel);
ALTER TABLE dim_et_wirtschaftszweig ADD PRIMARY KEY (Schluessel);

#Faktentabelle erstellen
CREATE TABLE faktentabelle (
    Faktenschluessel INTEGER PRIMARY KEY AUTOINCREMENT,
    Bundschluessel INTEGER,
    Landesschluessel INTEGER,
    Gemeindeschluessel INTEGER,
    Gemeindeverbandsschluessel INTEGER,
    RegBezirkschluessel INTEGER,
    Kreisschluessel INTEGER,
    StadtTypSchluessel INTEGER,
    Gesamtbevölkerung INTEGER,
    Erwerbstätige INTEGER,
    Arbeitslose INTEGER,
    Schulabschlüsse INTEGER,
    BeruflicheAbschlüsse INTEGER,
    -- Fremdschlüssel-Beziehungen definieren
    FOREIGN KEY (Bundschluessel) REFERENCES dim_bund(Bundschluessel),
    FOREIGN KEY (Landesschluessel) REFERENCES dim_land(Landesschluessel),
    FOREIGN KEY (Gemeindeschluessel) REFERENCES dim_gemeinde(Gemeindeschluessel),
    FOREIGN KEY (Gemeindeverbandsschluessel) REFERENCES dim_gemeindeverband(Gemeindeverbandsschluessel),
    FOREIGN KEY (RegBezirkschluessel) REFERENCES dim_regierungsbezirk(RegBezirkschluessel),
    FOREIGN KEY (Kreisschluessel) REFERENCES dim_stadtkreiskreisfreiestadtlandkreis(Kreisschluessel),
    FOREIGN KEY (StadtTypSchluessel) REFERENCES dim_stadt_typen(Schluessel)
);


#Befuellen der Faktentabelle
-- Populieren der Faktentabelle
INSERT INTO faktentabelle (
    Bundschluessel, Landesschluessel, Gemeindeschluessel, 
    Gemeindeverbandsschluessel, RegBezirkschluessel, Kreisschluessel, 
    StadtTypSchluessel, Gesamtbevölkerung, Erwerbstätige, Arbeitslose, 
    Schulabschlüsse, BeruflicheAbschlüsse)
SELECT 
    l.Bundschluessel,
    l.Landesschluessel,
    g.Gemeindeschluessel,
    gv.Gemeindeverbandsschluessel,
    r.RegBezirkschluessel,
    k.Kreisschluessel,
    st.Schluessel AS StadtTypSchluessel,
    SUM(CASE WHEN kl.Schluessel IS NOT NULL THEN kl.SCHUELER_KLSS_STP ELSE 0 END) AS Gesamtbevölkerung,
    SUM(CASE WHEN e.Schluessel IS NOT NULL THEN e.ERWERBSTAT_KURZ_STP ELSE 0 END) AS Erwerbstätige,
    SUM(CASE WHEN e.Schluessel IS NOT NULL THEN e.ERWERBSTAT_KURZ_STP__12 ELSE 0 END) AS Arbeitslose,
    SUM(CASE WHEN hs.Schluessel IS NOT NULL THEN hs.SCHULABS_STP ELSE 0 END) AS Schulabschlüsse,
    SUM(CASE WHEN hb.Schluessel IS NOT NULL THEN hb.BERUFABS_AUSF_STP ELSE 0 END) AS BeruflicheAbschlüsse
FROM 
    dim_land l
    LEFT JOIN dim_gemeinde g ON l.Landesschluessel = g.Landesschluessel
    LEFT JOIN dim_gemeindeverband gv ON g.Gemeindeverbandsschluessel = gv.Gemeindeverbandsschluessel
    LEFT JOIN dim_regierungsbezirk r ON gv.Kreisschluessel = r.RegBezirkschluessel
    LEFT JOIN dim_stadtkreiskreisfreiestadtlandkreis k ON r.RegBezirkschluessel = k.RegBezirkschluessel
    LEFT JOIN dim_stadt_typen st ON g.Gemeindeschluessel = st.Schluessel
    LEFT JOIN dim_klassenstufe kl ON g.Gemeindeschluessel = kl.Schluessel
    LEFT JOIN dim_erwerbsstatus e ON g.Gemeindeschluessel = e.Schluessel
    LEFT JOIN dim_hoechster_schulabschluss hs ON g.Gemeindeschluessel = hs.Schluessel
    LEFT JOIN dim_hoechster_berufl_abschluss hb ON g.Gemeindeschluessel = hb.Schluessel
GROUP BY 
    l.Bundschluessel, l.Landesschluessel, g.Gemeindeschluessel, 
    gv.Gemeindeverbandsschluessel, r.RegBezirkschluessel, k.Kreisschluessel, st.Schluessel;

-- Überprüfen der Integrität und Konsistenz der Datenbank
PRAGMA foreign_keys = ON;

-- Überprüfen, ob alle Fremdschlüssel aktiviert und korrekt sind
PRAGMA foreign_key_check;
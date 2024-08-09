-- Dimensionstabellen erstellen und Primärschlüssel hinzufügen

-- 1 Teil der Dimensionstabellen
ALTER TABLE public.dim_land ADD PRIMARY KEY (landesschluessel);
ALTER TABLE public.dim_gemeinde ADD PRIMARY KEY (gemeindeschluessel);
ALTER TABLE public.dim_gemeindeverband ADD PRIMARY KEY (gemeindeverbandsschluessel);
ALTER TABLE public.dim_regierungsbezirk ADD PRIMARY KEY (regbezirkschluessel);
ALTER TABLE public.dim_stadtkreiskreisfreiestadtlandkreis ADD PRIMARY KEY (kreisschluessel);

-- Stadt-Typen-Tabelle (schluessel ist der Primärschlüssel)
ALTER TABLE public.dim_stadt_typen ADD PRIMARY KEY (schluessel);

-- Weitere Dimensionstabellen mit Primärschlüsseln
ALTER TABLE public.dim_klassenstufe ADD PRIMARY KEY (schluessel);
ALTER TABLE public.dim_schulform ADD PRIMARY KEY (schluessel);
ALTER TABLE public.dim_hoechster_schulabschluss ADD PRIMARY KEY (schluessel);
ALTER TABLE public.dim_hoechster_berufl_abschluss ADD PRIMARY KEY (schluessel);
ALTER TABLE public.dim_erwerbsstatus ADD PRIMARY KEY (schluessel);
ALTER TABLE public.dim_et_alter ADD PRIMARY KEY (schluessel);
ALTER TABLE public.dim_et_hoechst_berufl_abschl ADD PRIMARY KEY (schluessel);
ALTER TABLE public.dim_et_stellung_im_beruf ADD PRIMARY KEY (schluessel);
ALTER TABLE public.dim_et_beruf_hauptgr_isco08 ADD PRIMARY KEY (schluessel);
ALTER TABLE public.dim_et_wirtschaftszweig ADD PRIMARY KEY (schluessel);



-- Faktentabelle erstellen, die die zu analysierenden Daten enthält
-- Diese Tabelle enthält alle relevanten Fakten (z.B. Bevölkerungszahl, Erwerbstätige)
CREATE TABLE public.faktentabelle (
    faktenschluessel SERIAL PRIMARY KEY,  -- Eindeutiger Schlüssel für jede Faktentabelle
    landesschluessel CHAR(2),  -- Fremdschlüssel zur Verknüpfung mit der Landestabelle
    gemeindeschluessel CHAR(12),  -- Fremdschlüssel zur Verknüpfung mit der Gemeindetabelle
    gemeindeverbandsschluessel CHAR(9),  -- Fremdschlüssel zur Verknüpfung mit der Gemeindeverbandstabelle
    regbezirkschluessel CHAR(3),  -- Fremdschlüssel zur Verknüpfung mit der Regierungsbezirkstabelle
    kreisschluessel CHAR(5),  -- Fremdschlüssel zur Verknüpfung mit der Stadtkreis-, kreisfreie Stadt- und Landkreistabelle
    stadttypschluessel CHAR(12),  -- Fremdschlüssel zur Verknüpfung mit der Stadt-Typen-Tabelle
    gesamtbevölkerung INTEGER,  -- Spalte für die Gesamtbevölkerung
    erwerbstätige INTEGER,  -- Spalte für die Erwerbstätigen
    arbeitslose INTEGER,  -- Spalte für die Arbeitslosen
    schulabschlüsse INTEGER,  -- Spalte für die Schulabschlüsse
    beruflicheabschlüsse INTEGER,  -- Spalte für die beruflichen Abschlüsse
    -- Fremdschlüssel-Beziehungen definieren
    FOREIGN KEY (landesschluessel) REFERENCES public.dim_land(landesschluessel),
    FOREIGN KEY (gemeindeschluessel) REFERENCES public.dim_gemeinde(gemeindeschluessel),
    FOREIGN KEY (gemeindeverbandsschluessel) REFERENCES public.dim_gemeindeverband(gemeindeverbandsschluessel),
    FOREIGN KEY (regbezirkschluessel) REFERENCES public.dim_regierungsbezirk(regbezirkschluessel),
    FOREIGN KEY (kreisschluessel) REFERENCES public.dim_stadtkreiskreisfreiestadtlandkreis(kreisschluessel),
    FOREIGN KEY (stadttypschluessel) REFERENCES public.dim_stadt_typen(schluessel)
);





-- Populieren der Faktentabelle mit aggregierten Daten aus verschiedenen Dimensionstabellen
-- In diese Abfrage werden mehrere Dimensionstabellen integriert, um die Faktentabelle zu befüllen.
-- Dabei werden Schlüssel für Land, Gemeinde, Gemeindeverband, Regierungsbezirk, Kreis und Stadttypen genutzt.

INSERT INTO public.faktentabelle (
    landesschluessel,          -- Fremdschlüssel zur Verknüpfung mit der Landestabelle
    gemeindeschluessel,        -- Fremdschlüssel zur Verknüpfung mit der Gemeindetabelle
    gemeindeverbandsschluessel, -- Fremdschlüssel zur Verknüpfung mit der Gemeindeverbandstabelle
    regbezirkschluessel,       -- Fremdschlüssel zur Verknüpfung mit der Regierungsbezirkstabelle
    kreisschluessel,           -- Fremdschlüssel zur Verknüpfung mit der Stadtkreis-, kreisfreie Stadt- und Landkreistabelle
    stadttypschluessel,        -- Fremdschlüssel zur Verknüpfung mit der Stadt-Typen-Tabelle
    gesamtbevölkerung,         -- Aggregierte Spalte für die Gesamtbevölkerung
    erwerbstätige,             -- Aggregierte Spalte für die Anzahl der Erwerbstätigen
    arbeitslose,               -- Aggregierte Spalte für die Anzahl der Arbeitslosen
    schulabschlüsse,           -- Aggregierte Spalte für die Anzahl der Schulabschlüsse
    beruflicheabschlüsse       -- Aggregierte Spalte für die Anzahl der beruflichen Abschlüsse
)
-- Daten werden aus verschiedenen Dimensionstabellen abgerufen und in die Faktentabelle eingefügt.
SELECT 
    g.landesschluessel,        -- Abruf des Landesschlüssels aus der Gemeindetabelle
    g.gemeindeschluessel,      -- Abruf des Gemeindeschlüssels aus der Gemeindetabelle
    gv.gemeindeverbandsschluessel, -- Abruf des Gemeindeverbandsschlüssels aus der Gemeindeverbandstabelle
    r.regbezirkschluessel,     -- Abruf des Regierungsbezirksschlüssels aus der Regierungsbezirkstabelle
    k.kreisschluessel,         -- Abruf des Kreisschlüssels aus der Stadtkreis-, kreisfreie Stadt- und Landkreistabelle
    st.schluessel AS stadttypschluessel, -- Abruf des Stadttypenschlüssels aus der Stadt-Typen-Tabelle
    -- Aggregation der Bevölkerungsdaten aus der Klassenstufentabelle
    SUM(CASE WHEN kl.schluessel IS NOT NULL THEN kl.schueler_klss_stp ELSE 0 END) AS gesamtbevölkerung,
    -- Aggregation der Erwerbsdaten aus der Erwerbsstatustabelle
    SUM(CASE WHEN e.schluessel IS NOT NULL THEN e.erwerbstat_kurz_stp ELSE 0 END) AS erwerbstätige,
    -- Aggregation der Arbeitslosenzahlen aus der Erwerbsstatustabelle
    SUM(CASE WHEN e.schluessel IS NOT NULL THEN e.erwerbstat_kurz_stp__12 ELSE 0 END) AS arbeitslose,
    -- Aggregation der Schulabschlüsse aus der höchsten Schulabschlusstabelle
    SUM(CASE WHEN hs.schluessel IS NOT NULL THEN hs.schulabs_stp ELSE 0 END) AS schulabschlüsse,
    -- Aggregation der beruflichen Abschlüsse aus der höchsten beruflichen Abschlusstabelle
    SUM(CASE WHEN hb.schluessel IS NOT NULL THEN hb.berufabs_ausf_stp ELSE 0 END) AS beruflicheabschlüsse
FROM 
    public.dim_gemeinde g -- Start der Abfrage bei der Gemeindetabelle
    -- Verknüpfung mit der Gemeindeverbandstabelle über den Gemeindeverbandsschlüssel
    LEFT JOIN public.dim_gemeindeverband gv ON g.gemeindeverbandsschluessel = gv.gemeindeverbandsschluessel
    -- Verknüpfung mit der Stadtkreis-, kreisfreie Stadt- und Landkreistabelle über den Kreisschlüssel
    LEFT JOIN public.dim_stadtkreiskreisfreiestadtlandkreis k ON g.kreisschluessel = k.kreisschluessel
    -- Verknüpfung mit der Regierungsbezirkstabelle über den Regierungsbezirksschlüssel
    LEFT JOIN public.dim_regierungsbezirk r ON g.regbezirkschluessel = r.regbezirkschluessel
    -- Verknüpfung mit der Landestabelle über den Landesschlüssel
    LEFT JOIN public.dim_land l ON g.landesschluessel = l.landesschluessel
    -- Verknüpfung mit der Stadt-Typen-Tabelle über den Gemeindeschlüssel
    LEFT JOIN public.dim_stadt_typen st ON g.gemeindeschluessel = st.schluessel
    -- Verknüpfung mit der Klassenstufentabelle über den Gemeindeschlüssel zur Berechnung der Gesamtbevölkerung
    LEFT JOIN public.dim_klassenstufe kl ON g.gemeindeschluessel = kl.schluessel
    -- Verknüpfung mit der Erwerbsstatustabelle über den Gemeindeschlüssel zur Berechnung der Erwerbstätigen und Arbeitslosen
    LEFT JOIN public.dim_erwerbsstatus e ON g.gemeindeschluessel = e.schluessel
    -- Verknüpfung mit der höchsten Schulabschlusstabelle über den Gemeindeschlüssel zur Berechnung der Schulabschlüsse
    LEFT JOIN public.dim_hoechster_schulabschluss hs ON g.gemeindeschluessel = hs.schluessel
    -- Verknüpfung mit der höchsten beruflichen Abschlusstabelle über den Gemeindeschlüssel zur Berechnung der beruflichen Abschlüsse
    LEFT JOIN public.dim_hoechster_berufl_abschluss hb ON g.gemeindeschluessel = hb.schluessel
-- Gruppierung der Daten nach den Schlüsseln, um eine Aggregation der Zahlen für jede Gruppe zu ermöglichen
GROUP BY 
    g.landesschluessel, 
    g.gemeindeschluessel, 
    gv.gemeindeverbandsschluessel, 
    r.regbezirkschluessel, 
    k.kreisschluessel, 
    st.schluessel;



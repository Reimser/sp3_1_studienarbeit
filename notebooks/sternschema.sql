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
    gesamt_schuelerzahl INTEGER,  -- Spalte für die gesamte Schülerzahl
    -- Fremdschlüssel-Beziehungen definieren
    FOREIGN KEY (landesschluessel) REFERENCES public.dim_land(landesschluessel),
    FOREIGN KEY (gemeindeschluessel) REFERENCES public.dim_gemeinde(gemeindeschluessel),
    FOREIGN KEY (gemeindeverbandsschluessel) REFERENCES public.dim_gemeindeverband(gemeindeverbandsschluessel),
    FOREIGN KEY (regbezirkschluessel) REFERENCES public.dim_regierungsbezirk(regbezirkschluessel),
    FOREIGN KEY (kreisschluessel) REFERENCES public.dim_stadtkreiskreisfreiestadtlandkreis(kreisschluessel),
    FOREIGN KEY (stadttypschluessel) REFERENCES public.dim_stadt_typen(schluessel)
);







-- Populieren der Faktentabelle mit aggregierten Daten aus verschiedenen Dimensionstabellen
INSERT INTO public.faktentabelle (
    landesschluessel,
    gemeindeschluessel,
    gemeindeverbandsschluessel,
    regbezirkschluessel,
    kreisschluessel,
    stadttypschluessel,
    gesamtbevölkerung,
    erwerbstätige,
    arbeitslose,
    schulabschlüsse,
    beruflicheabschlüsse,
    gesamt_schuelerzahl
)
SELECT 
    g.landesschluessel,
    g.gemeindeschluessel,
    gv.gemeindeverbandsschluessel,
    r.regbezirkschluessel,
    k.kreisschluessel,
    st.schluessel AS stadttypschluessel,
    -- Berechnung der Gesamtbevölkerung
    SUM(COALESCE(e.erwerbstat_kurz_stp__w, 0) + COALESCE(e.erwerbstat_kurz_stp__m, 0) + COALESCE(kl.schueler_klss_stp, 0)) AS gesamtbevölkerung,
    -- Aggregation der Erwerbsdaten
    SUM(COALESCE(e.erwerbstat_kurz_stp, 0)) AS erwerbstätige,
    -- Aggregation der Arbeitslosenzahlen
    SUM(COALESCE(e.erwerbstat_kurz_stp__12, 0)) AS arbeitslose,
    -- Aggregation der Schulabschlüsse
    SUM(COALESCE(hs.schulabs_stp, 0)) AS schulabschlüsse,
    -- Aggregation der beruflichen Abschlüsse
    SUM(COALESCE(hb.berufabs_ausf_stp, 0)) AS beruflicheabschlüsse,
    -- Aggregation der gesamten Schülerzahl
    SUM(COALESCE(kl.schueler_klss_stp, 0)) AS gesamt_schuelerzahl
FROM 
    public.dim_gemeinde g
    LEFT JOIN public.dim_gemeindeverband gv ON g.gemeindeverbandsschluessel = gv.gemeindeverbandsschluessel
    LEFT JOIN public.dim_stadtkreiskreisfreiestadtlandkreis k ON g.kreisschluessel = k.kreisschluessel
    LEFT JOIN public.dim_regierungsbezirk r ON g.regbezirkschluessel = r.regbezirkschluessel
    LEFT JOIN public.dim_land l ON g.landesschluessel = l.landesschluessel
    LEFT JOIN public.dim_stadt_typen st ON g.gemeindeschluessel = st.schluessel
    LEFT JOIN public.dim_klassenstufe kl ON g.gemeindeschluessel = kl.schluessel
    LEFT JOIN public.dim_erwerbsstatus e ON g.gemeindeschluessel = e.schluessel
    LEFT JOIN public.dim_hoechster_schulabschluss hs ON g.gemeindeschluessel = hs.schluessel
    LEFT JOIN public.dim_hoechster_berufl_abschluss hb ON g.gemeindeschluessel = hb.schluessel
GROUP BY 
    g.landesschluessel, 
    g.gemeindeschluessel, 
    gv.gemeindeverbandsschluessel, 
    r.regbezirkschluessel, 
    k.kreisschluessel, 
    st.schluessel;




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



CREATE TABLE public.faktentabelle (
    faktenschluessel SERIAL PRIMARY KEY,
    landesschluessel CHAR(2),
    gemeindeschluessel CHAR(12),
    gemeindeverbandsschluessel CHAR(9),
    regbezirkschluessel CHAR(3),
    kreisschluessel CHAR(5),
    stadttypschluessel CHAR(12),
    gesamtbevölkerung INTEGER,
    erwerbstätige INTEGER,
    arbeitslose INTEGER,
    schulabschlüsse INTEGER,
    beruflicheabschlüsse INTEGER,
    -- Fremdschlüssel-Beziehungen definieren
    FOREIGN KEY (landesschluessel) REFERENCES public.dim_land(landesschluessel),
    FOREIGN KEY (gemeindeschluessel) REFERENCES public.dim_gemeinde(gemeindeschluessel),
    FOREIGN KEY (gemeindeverbandsschluessel) REFERENCES public.dim_gemeindeverband(gemeindeverbandsschluessel),
    FOREIGN KEY (regbezirkschluessel) REFERENCES public.dim_regierungsbezirk(regbezirkschluessel),
    FOREIGN KEY (kreisschluessel) REFERENCES public.dim_stadtkreiskreisfreiestadtlandkreis(kreisschluessel)
);





-- Populieren der Faktentabelle
INSERT INTO public.faktentabelle (
    landesschluessel, gemeindeschluessel, 
    gemeindeverbandsschluessel, regbezirkschluessel, kreisschluessel, 
    stadttypschluessel, gesamtbevölkerung, erwerbstätige, arbeitslose, 
    schulabschlüsse, beruflicheabschlüsse)
SELECT 
    g.landesschluessel,
    g.gemeindeschluessel,
    gv.gemeindeverbandsschluessel,
    r.regbezirkschluessel,
    k.kreisschluessel,
    st.schluessel AS stadttypschluessel,
    SUM(CASE WHEN kl.schluessel IS NOT NULL THEN kl.schueler_klss_stp ELSE 0 END) AS gesamtbevölkerung,
    SUM(CASE WHEN e.schluessel IS NOT NULL THEN e.erwerbstat_kurz_stp ELSE 0 END) AS erwerbstätige,
    SUM(CASE WHEN e.schluessel IS NOT NULL THEN e.erwerbstat_kurz_stp__12 ELSE 0 END) AS arbeitslose,
    SUM(CASE WHEN hs.schluessel IS NOT NULL THEN hs.schulabs_stp ELSE 0 END) AS schulabschlüsse,
    SUM(CASE WHEN hb.schluessel IS NOT NULL THEN hb.berufabs_ausf_stp ELSE 0 END) AS beruflicheabschlüsse
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
    g.landesschluessel, g.gemeindeschluessel, 
    gv.gemeindeverbandsschluessel, r.regbezirkschluessel, k.kreisschluessel, st.schluessel;



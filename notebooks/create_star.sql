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

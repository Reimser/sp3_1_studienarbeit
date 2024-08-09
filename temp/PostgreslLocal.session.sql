SELECT f.*
FROM public.faktentabelle f
LEFT JOIN public.dim_land l ON f.landesschluessel = l.landesschluessel
LEFT JOIN public.dim_gemeinde g ON f.gemeindeschluessel = g.gemeindeschluessel
LEFT JOIN public.dim_gemeindeverband gv ON f.gemeindeverbandsschluessel = gv.gemeindeverbandsschluessel
LEFT JOIN public.dim_regierungsbezirk r ON f.regbezirkschluessel = r.regbezirkschluessel
LEFT JOIN public.dim_stadtkreiskreisfreiestadtlandkreis k ON f.kreisschluessel = k.kreisschluessel
LEFT JOIN public.dim_stadt_typen st ON f.stadttypschluessel = st.schluessel
WHERE l.landesschluessel IS NULL
   OR g.gemeindeschluessel IS NULL
   OR gv.gemeindeverbandsschluessel IS NULL
   OR r.regbezirkschluessel IS NULL
   OR k.kreisschluessel IS NULL
   OR st.schluessel IS NULL;

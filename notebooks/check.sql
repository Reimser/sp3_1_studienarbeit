# Ueberpruefen ob die PKs erfolgreich gesetzt wurden

-- Überprüfen des Primärschlüssels in der Tabelle dim_land
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid = 'public.dim_land'::regclass
AND contype = 'p';

-- Überprüfen des Primärschlüssels in der Tabelle dim_gemeinde
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid = 'public.dim_gemeinde'::regclass
AND contype = 'p';

-- Überprüfen des Primärschlüssels in der Tabelle dim_gemeindeverband
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid = 'public.dim_gemeindeverband'::regclass
AND contype = 'p';

-- Überprüfen des Primärschlüssels in der Tabelle dim_regierungsbezirk
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid = 'public.dim_regierungsbezirk'::regclass
AND contype = 'p';

-- Überprüfen des Primärschlüssels in der Tabelle dim_stadtkreiskreisfreiestadtlandkreis
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid = 'public.dim_stadtkreiskreisfreiestadtlandkreis'::regclass
AND contype = 'p';

-- Überprüfen des Primärschlüssels in der Tabelle dim_stadt_typen
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid = 'public.dim_stadt_typen'::regclass
AND contype = 'p';


-- Überprüfen des Primärschlüssels in der Tabelle dim_klassenstufe
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid = 'public.dim_klassenstufe'::regclass
AND contype = 'p';

-- Überprüfen des Primärschlüssels in der Tabelle dim_schulform
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid = 'public.dim_schulform'::regclass
AND contype = 'p';

-- Überprüfen des Primärschlüssels in der Tabelle dim_hoechster_schulabschluss
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid = 'public.dim_hoechster_schulabschluss'::regclass
AND contype = 'p';

-- Überprüfen des Primärschlüssels in der Tabelle dim_hoechster_berufl_abschluss
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid = 'public.dim_hoechster_berufl_abschluss'::regclass
AND contype = 'p';

-- Überprüfen des Primärschlüssels in der Tabelle dim_erwerbsstatus
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid = 'public.dim_erwerbsstatus'::regclass
AND contype = 'p';

-- Überprüfen des Primärschlüssels in der Tabelle dim_et_alter
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid = 'public.dim_et_alter'::regclass
AND contype = 'p';

-- Überprüfen des Primärschlüssels in der Tabelle dim_et_hoechst_berufl_abschl
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid = 'public.dim_et_hoechst_berufl_abschl'::regclass
AND contype = 'p';

-- Überprüfen des Primärschlüssels in der Tabelle dim_et_stellung_im_beruf
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid = 'public.dim_et_stellung_im_beruf'::regclass
AND contype = 'p';

-- Überprüfen des Primärschlüssels in der Tabelle dim_et_beruf_hauptgr_isco08
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid = 'public.dim_et_beruf_hauptgr_isco08'::regclass
AND contype = 'p';

-- Überprüfen des Primärschlüssels in der Tabelle dim_et_wirtschaftszweig
SELECT conname AS constraint_name
FROM pg_constraint
WHERE conrelid = 'public.dim_et_wirtschaftszweig'::regclass
AND contype = 'p';


Ueberpruefen ob die Faktentabelle richtig aufgesetzt wurde und die FKs funzen

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_name = 'faktentabelle';

SELECT column_name, data_type, character_maximum_length
FROM information_schema.columns
WHERE table_name = 'faktentabelle';

SELECT conname AS constraint_name, confrelid::regclass AS referenced_table
FROM pg_constraint
WHERE conrelid = 'public.faktentabelle'::regclass
AND contype = 'f';

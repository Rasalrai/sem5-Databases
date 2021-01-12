-- Optymalizacja poleceń  SQL
-- Część 3. Metody dostępu do danych

BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(ownname => 'inf141313',
    tabname => 'OPT_PRACOWNICY');
  DBMS_STATS.GATHER_TABLE_STATS(ownname => 'inf141313',
    tabname => 'OPT_ZESPOLY');
  DBMS_STATS.GATHER_TABLE_STATS(ownname => 'inf141313',
    tabname => 'OPT_ETATY');
END;


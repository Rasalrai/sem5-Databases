-- Optymalizacja poleceń  SQL
-- Wyświetlanie planów wykonania

-- EXPLAIN PLAN: wstęp


EXPLAIN PLAN FOR
SELECT nazwisko, nazwa
FROM opt_pracownicy JOIN opt_zespoly USING(id_zesp);

SELECT * FROM TABLE(dbms_xplan.display());


EXPLAIN PLAN SET STATEMENT_ID = 'zap_1_inf141313' FOR
SELECT nazwisko, nazwa
FROM opt_pracownicy JOIN opt_zespoly USING(id_zesp);

EXPLAIN PLAN
SET STATEMENT_ID = 'zap_2_inf141313' FOR
SELECT etat, ROUND(AVG(placa), 2)
FROM opt_pracownicy
GROUP BY etat ORDER BY etat;

SELECT * FROM TABLE(dbms_xplan.display(statement_id => 'zap_2_inf141313'));


SELECT * FROM TABLE(dbms_xplan.display(statement_id => 'zap_2_inf141313', format => 'BASIC'));

-- zadania

-- zad 1
SELECT * FROM TABLE(dbms_xplan.display(statement_id => 'zap_2_inf141313'));

-- zad 2
SELECT * FROM TABLE(dbms_xplan.display(statement_id => 'zap_2_inf141313',
                                       format => 'ALL'));

-- zad 3
EXPLAIN PLAN FOR
SELECT etat, count(*) AS ile
FROM opt_pracownicy
GROUP BY etat ORDER BY etat;

SELECT * FROM TABLE(dbms_xplan.display());


SELECT etat, count(*) AS ile
FROM opt_pracownicy
GROUP BY etat ORDER BY etat;    -- F10


-- AUTOTRACE

-- wstęp

SELECT etat, ROUND(AVG(placa), 2)
FROM opt_pracownicy
GROUP BY etat ORDER BY etat;

SET AUTOTRACE ON EXPLAIN

SET AUTOTRACE ON STATISTICS

SET AUTOTRACE ON

SET AUTOTRACE OFF


-- DISPLAY_CURSOR

SELECT nazwa, COUNT(*)
FROM opt_pracownicy JOIN opt_zespoly USING(id_zesp)
GROUP BY nazwa ORDER BY nazwa;

SELECT * FROM TABLE(dbms_xplan.display_cursor());

SELECT sql_text, sql_id,
    to_char(last_active_time, 'yyyy.mm.dd hh24:mi:ss')
        AS last_active_time,
    parsing_schema_name
FROM v$sql
WHERE sql_text LIKE 'SELECT nazwa%'
    AND sql_text NOT LIKE '%v$sql%';

--ID: 5g6j0wnbfwbf6

SELECT * FROM TABLE(dbms_xplan.display_cursor(sql_id => '5g6j0wnbfwbf6'));

SELECT /*zapytanie_inf141313*/ nazwa, COUNT(*)
FROM opt_pracownicy JOIN opt_zespoly USING(id_zesp)
GROUP BY nazwa ORDER BY nazwa;

SELECT sql_text, sql_id
FROM v$sql
WHERE sql_text LIKE '%zapytanie_inf141313%'
    AND sql_text NOT LIKE '%v$sql%';
-- 5j9str6rp14dk

SELECT * FROM TABLE(dbms_xplan.display_cursor(sql_id => '5j9str6rp14dk',
                                              format=>'ALL'));
SELECT * FROM TABLE(dbms_xplan.display_cursor(sql_id => '5j9str6rp14dk',
    format=>'BASIC +ROWS +BYTES +PREDICATE'));

SELECT /*+ GATHER_PLAN_STATISTICS zap2_inf141313*/ nazwa, COUNT(*)
FROM opt_pracownicy JOIN opt_zespoly USING(id_zesp)
GROUP BY nazwa ORDER BY nazwa;

SELECT sql_text, sql_id
FROM v$sql
WHERE sql_text LIKE '%zap2_inf141313%'
    AND sql_text NOT LIKE '%v$sql%';
-- c24hgn4v09z16

SELECT * FROM TABLE(dbms_xplan.display_cursor(sql_id => 'c24hgn4v09z16',
                                              format => 'IOSTATS ALL LAST'));

-- zadania

-- zad 1
SELECT /*query1_141313*/ * FROM opt_pracownicy
ORDER BY placa DESC
FETCH FIRST ROW ONLY;
-- 4gjsvm9z41hz6

SELECT /*query2_141313*/ ROUND(AVG(placa), 2) AS sr_placa,
    plec FROM opt_pracownicy
GROUP BY plec;
-- d9zmfw21ykm3a

SELECT * FROM TABLE(dbms_xplan.display_cursor(sql_id => '4gjsvm9z41hz6',
                                              format => 'ALL'));

SELECT * FROM TABLE(dbms_xplan.display_cursor(sql_id => 'd9zmfw21ykm3a',
    format=>'BASIC +ROWS +BYTES +PREDICATE'));

Insert /*3query_141313*/ into OPT_PRACOWNICY (ID_PRAC,ID_ZESP,NAZWISKO,PLEC,CZY_ETAT,PLACA,PLACA_DOD,ETAT)
        values (11111, 2, '11111', 'M', 'T', 1110, 100, 'KUSTOSZ');
-- fz9018yjqskv3

DELETE /*4query_141313*/ FROM opt_pracownicy
WHERE id_prac = 11111;
-- 2ch40s57mmqc7

SELECT * FROM TABLE(dbms_xplan.display_cursor(sql_id => 'fz9018yjqskv3'));
SELECT * FROM TABLE(dbms_xplan.display_cursor(sql_id => '2ch40s57mmqc7'));

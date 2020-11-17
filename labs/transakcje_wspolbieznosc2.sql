-- transakcje i zarządzanie współbieżnością

-- współbieżność, blokady

-- zad 3
UPDATE pracownicy
SET placa_pod = placa_pod + 100
WHERE nazwisko = 'HAPKE';

SELECT * FROM TABLE(sbd.blokady);

TY BLOKADA_ZADANA          BLOKADA_UZYSKANA             OBIEKT                       CZY_BLOKUJE_INNA
-- ----------------------- ---------------------------- ---------------------------- ----------------
TM	BRAK	               ROW EXCLUSIVE (RX)	        INF141313.PRACOWNICY	     0
TX	BRAK	               EXCLUSIVE (X)	            rekord	                     0


-- zad 4
SELECT placa_pod FROM pracownicy
WHERE nazwisko = 'HAPKE';

UPDATE pracownicy
SET placa_pod = placa_pod + 50
WHERE nazwisko = 'HAPKE';

-- zad 5

TY BLOKADA_ZADANA          BLOKADA_UZYSKANA             OBIEKT                       CZY_BLOKUJE_INNA
-- ----------------------- ---------------------------- ---------------------------- ----------------
TM	BRAK	               ROW EXCLUSIVE (RX)	        INF141313.PRACOWNICY	     1
TX	BRAK	               EXCLUSIVE (X)	            rekord	                     1

-- zad 6

ROLLBACK;
-- sesja B "odwiesza" się: zapytanie zostaje ukończone

SELECT * FROM TABLE(sbd.blokady);

TY BLOKADA_ZADANA          BLOKADA_UZYSKANA             OBIEKT                       CZY_BLOKUJE_INNA
-- ----------------------- ---------------------------- ---------------------------- ----------------
TM	BRAK	               ROW EXCLUSIVE (RX)	        INF141313.PRACOWNICY	     0
TX	BRAK	               EXCLUSIVE (X)	            rekord	                     0


-- zad 7
ROLLBACK;


-- Współbieżność, poziomy izolacji

-- zad 1
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT placa_pod FROM pracownicy
WHERE nazwisko = 'KONOPKA';
-- 480


-- zad 2
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT placa_pod FROM pracownicy
WHERE nazwisko = 'KONOPKA';
-- 480

UPDATE pracownicy
SET placa_pod = 780
WHERE nazwisko = 'KONOPKA';

COMMIT;


-- zad 3

UPDATE pracownicy
SET placa_pod = 280
WHERE nazwisko = 'KONOPKA';
-- 1 row updated

COMMIT;


-- zad 4
-- rozmyty odczyt

SELECT placa_pod FROM pracownicy
WHERE nazwisko = 'KONOPKA';
-- aktualna placa_pod to 280

-- przy sekwencyjnym wykonaniu tych transakcji, płaca wynosiłaby 580.


-- zad 5

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- w kroku 3:
-- ORA-08177: can't serialize access for this transaction

-- poziom SERIALIZABLE nie pozwala na modyfikację tego samego wiersza w dwóch równoległych transakcjach, więc druga z nich została zablokowana.



-- Anomalia skrośnego zapisu


-- zad 1, 2

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- zad 3

UPDATE pracownicy
SET placa_pod = (SELECT placa_pod
    FROM pracownicy 
    WHERE nazwisko = 'SLOWINSKI')
WHERE nazwisko = 'BRZEZINSKI';

-- zad 4
UPDATE pracownicy
SET placa_pod = (SELECT placa_pod
    FROM pracownicy 
    WHERE nazwisko = 'BRZEZINSKI')
WHERE nazwisko = 'SLOWINSKI';

-- zad 5
COMMIT;

SELECT nazwisko, placa_pod FROM pracownicy
WHERE nazwisko IN ('BRZEZINSKI', 'SLOWINSKI');


-- NAZWISKO      PLACA_POD
--------------- ----------
-- SLOWINSKI           960
-- BRZEZINSKI         1070

-- Taki wynik nie mógłby być wynikiem traksakcji wykonanych sekwencyjnie.


-- Zakleszczenie

-- zad 1
UPDATE pracownicy
SET placa_pod = placa_pod + 10
WHERE id_prac = 210;

-- zad 2
UPDATE pracownicy
SET placa_pod = placa_pod + 10
WHERE id_prac = 220;

-- zad 3
UPDATE pracownicy
SET placa_pod = placa_pod + 10
WHERE id_prac = 220;

-- zad 4
UPDATE pracownicy
SET placa_pod = placa_pod + 10
WHERE id_prac = 210;

-- ORA-00060: deadlock detected while waiting for resource
-- wykryto zakleszczenie w sesji A, więc wykonywanie zapytania zostało przerwane i zgłoszono błąd.

-- zad 5
ROLLBACK;
-- zapytanie w drugiej sesji jest odblokowane

COMMIT;

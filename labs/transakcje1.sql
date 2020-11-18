-- DML

-- zad 1
UPDATE pracownicy
SET etat = 'ADIUNKT' WHERE nazwisko = 'MATYSIAK';

-- zad 2
DELETE FROM pracownicy
WHERE etat = 'ASYSTENT';

-- zad 3
SELECT * FROM pracownicy WHERE etat = 'ASYSTENT';

-- zad 4
ROLLBACK;


-- DDL

-- zad 1
UPDATE pracownicy
SET placa_pod = placa_pod*1.1 WHERE etat = 'ADIUNKT';

SELECT * FROM pracownicy WHERE etat = 'ADIUNKT';

-- zad 2
ALTER TABLE pracownicy
MODIFY placa_dod NUMBER(7, 2);

-- zad 3
-- rollback ostatniej transakcji nie cofnął podwyżek dla adiunktów


-- savepoints

-- zad 1
UPDATE pracownicy
SET placa_pod = placa_pod + 200
WHERE nazwisko = 'MORZY';

-- zad 2
SAVEPOINT S1;

-- zad 3
UPDATE pracownicy
SET placa_dod = 100
WHERE nazwisko = 'BIALY';

-- zad 4
SAVEPOINT S2;

-- zad 5
DELETE FROM pracownicy
WHERE nazwisko = 'JEZIERSKI';

-- zad 6
ROLLBACK TO S1;
-- Morzy wciąż ma podwyżkę
-- płaca dod. Białego jest inna niż 100
-- Jezierski ponownie jest w bazie

-- zad 7
ROLLBACK TO S2;
-- nie można w tym momencie wycofać do S2

-- zad 8
ROLLBACK;

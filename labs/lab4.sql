-- PL/SQL -programowanie serwera Oracle Część 4. Procedury wyzwalane

-- zad 1

CREATE TABLE DziennikOperacji(
  typOperacji VARCHAR(10),
  dataRealizacji DATE DEFAULT CURRENT_DATE,
  nazwaTabeli VARCHAR(20) DEFAULT 'Zespoly',
  liczbaRekordow INTEGER
);

CREATE OR REPLACE TRIGGER LogujOperacje
	AFTER UPDATE OR INSERT OR DELETE ON zespoly 
DECLARE
	typOp DziennikOperacji.typOperacji%TYPE;
	rekordy DziennikOperacji.liczbaRekordow%TYPE;
BEGIN
  CASE
    WHEN INSERTING THEN
      typOp := 'INSERT';
    WHEN DELETING THEN
      typOp := 'DELETE';
    WHEN UPDATING THEN
      typOp := 'UPDATE';
  END CASE;
    
  SELECT COUNT(*) INTO rekordy FROM zespoly;
    
  INSERT INTO DziennikOperacji(typOperacji, liczbaRekordow)
  	VALUES (typOp, rekordy);
END;


-- zad 2

CREATE OR REPLACE TRIGGER PokazPlace
  BEFORE UPDATE OF placa_pod ON Pracownicy
  FOR EACH ROW
  WHEN (NVL(OLD.placa_pod, 0) <> NVL(NEW.placa_pod, 0))
BEGIN
  DBMS_OUTPUT.PUT_LINE('Pracownik ' || :OLD.nazwisko);
  DBMS_OUTPUT.PUT_LINE('Płaca przed modyfikacją: ' || NVL(:OLD.placa_pod, 0));
  DBMS_OUTPUT.PUT_LINE('Płaca po modyfikacji: ' || NVL(:NEW.placa_pod, 0));
END;

update pracownicy
set placa_pod = NULL
where etat = 'STAZYSTA';

update pracownicy
set placa_pod = 520
where etat = 'STAZYSTA';


-- zad 3

CREATE OR REPLACE TRIGGER UzupelnijPlace
  BEFORE INSERT ON Pracownicy
  FOR EACH ROW
DECLARE
	p_min etaty.placa_min%TYPE;
	p_max etaty.placa_max%TYPE;
BEGIN
  
  IF :NEW.etat IS NOT NULL THEN
    SELECT placa_min, placa_max INTO p_min, p_max
    FROM etaty WHERE nazwa = :NEW.etat;
    
    IF NVL(:NEW.placa_pod, 0) < p_min THEN
      :NEW.placa_pod := p_min;
    ELSIF NVL(:NEW.placa_pod, 0) > p_max THEN
      :NEW.placa_pod := p_max;
    END IF;
  END IF;
      
  IF :NEW.placa_dod IS NULL THEN
    :NEW.placa_dod := 0;
  END IF;
END;


INSERT INTO pracownicy(id_prac, nazwisko, etat) VALUES (310, 'Iliescu', 'ASYSTENT');
INSERT INTO pracownicy(id_prac, nazwisko, etat) VALUES (320, 'Popa', 'ADIUNKT');
INSERT INTO pracownicy(id_prac, nazwisko, placa_pod) VALUES (330, 'Bradea', 20);


-- zad 4

CREATE SEQUENCE SEQ_Zespoly
  START WITH 6997 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER UzupelnijID
  BEFORE INSERT ON Zespoly
  FOR EACH ROW
BEGIN
  IF :NEW.id_zesp IS NULL THEN
    :NEW.id_zesp := seq_zespoly.nextval;
  END IF;
END;

-- zad 5

CREATE OR REPLACE VIEW Szefowie
  (szef, pracownicy) AS
  SELECT ps.nazwisko, podwladni
    FROM pracownicy ps LEFT JOIN (SELECT id_szefa, COUNT(*) as podwladni
      FROM pracownicy
      GROUP BY id_szefa) pp ON ps.id_prac = pp.id_szefa;

CREATE OR REPLACE TRIGGER usun_podwladnych_szefa
	INSTEAD OF DELETE ON szefowie
	FOR EACH ROW
DECLARE
  CURSOR subs(sz pracownicy.nazwisko%TYPE) IS
	SELECT id_prac, nazwisko FROM pracownicy WHERE nazwisko = sz FOR UPDATE;

  temp NUMBER;
BEGIN
  FOR empl IN subs(:OLD.szef) LOOP
    
    SELECT podwladni INTO temp
    FROM pracownicy ps LEFT JOIN (SELECT id_szefa, COUNT(*) as podwladni
      FROM pracownicy
      GROUP BY id_szefa) pp ON ps.id_prac = pp.id_szefa
    WHERE ps.nazwisko = empl.nazwisko;
    
    IF temp IS NOT NULL THEN
      RAISE_APPLICATION_ERROR(20001, 'Jeden z podwładnych usuwanego pracownika jest szefem innych pracowników. Usuwanie anulowane!'); 
    END IF;
  END LOOP;
    -- if reaches here, safe to remove
    
  FOR empl IN subs(:OLD.szef) LOOP
    DELETE FROM pracownicy WHERE id_prac = empl.id_prac;
  END LOOP;
    DELETE FROM pracownicy WHERE nazwisko = :OLD.szef;
END;

DELETE FROM szefowie WHERE szef = 'WEGLARZ';
-- ORA-20001

DELETE FROM szefowie WHERE szef = 'KONOPKA';
-- OK


-- zad 6

ALTER TABLE zespoly
ADD liczba_pracownikow NUMBER(6);

UPDATE zespoly z
SET liczba_pracownikow = (SELECT COUNT(*) FROM pracownicy WHERE id_zesp = z.id_zesp);

CREATE OR REPLACE TRIGGER czlonkowie_zespolow
  BEFORE DELETE OR INSERT OR UPDATE ON pracownicy
  FOR EACH ROW
BEGIN
  CASE
    WHEN INSERTING THEN
      -- add employee
      UPDATE zespoly SET liczba_pracownikow = liczba_pracownikow+1 WHERE id_zesp = :NEW.id_zesp;
    WHEN DELETING THEN
      -- remove employee
      UPDATE zespoly SET liczba_pracownikow = liczba_pracownikow-1 WHERE id_zesp = :OLD.id_zesp;
    WHEN UPDATING THEN
      -- remove and add employee
      UPDATE zespoly SET liczba_pracownikow = liczba_pracownikow+1 WHERE id_zesp = :NEW.id_zesp;
      UPDATE zespoly SET liczba_pracownikow = liczba_pracownikow-1 WHERE id_zesp = :OLD.id_zesp;
  END CASE;
END;


INSERT INTO Pracownicy(id_prac, nazwisko, id_zesp, id_szefa) VALUES(550,'NOWY PRACOWNIK', 40, 120);
UPDATE Pracownicy SET id_zesp = 50 WHERE id_zesp = 40;
DELETE FROM pracownicy WHERE id_prac = 550;


-- zad 7

ALTER TABLE pracownicy DROP CONSTRAINT fk_id_szefa;
ALTER TABLE pracownicy ADD CONSTRAINT fk_id_szefa FOREIGN KEY(id_szefa) REFERENCES pracownicy(id_prac) ON DELETE CASCADE;

CREATE OR REPLACE TRIGGER usun_prac
  AFTER DELETE ON pracownicy
  FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE(:OLD.nazwisko);
END;

DELETE FROM pracownicy WHERE nazwisko = 'MORZY';
-- Matysiak, Kowalski, Morzy
ROLLBACK;

CREATE OR REPLACE TRIGGER usun_prac
  BEFORE DELETE ON pracownicy
  FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE(:OLD.nazwisko);
END;

DELETE FROM pracownicy WHERE nazwisko = 'MORZY';
-- Morzy, Matysiak, Kowalski


-- zad 8

ALTER TABLE pracownicy DISABLE ALL TRIGGERS;

SELECT * FROM user_triggers WHERE table_name = 'PRACOWNICY';

alter trigger usun_podwladnych_szefa disable;


-- zad 9

SELECT * FROM user_triggers WHERE table_name in ('PRACOWNICY', 'ZESPOLY');

DROP TRIGGER czlonkowie_zespolow;
DROP TRIGGER logujoperacje;
DROP TRIGGER pokazplace;
DROP TRIGGER usun_podwladnych;
DROP TRIGGER usun_prac;
DROP TRIGGER uzupelnijid;
DROP TRIGGER uzupelnijplace;

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


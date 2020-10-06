-- PL/SQL: wprowadzenie

-- zad 1

DECLARE
  vTekst VARCHAR(60) := 'Witaj, świecie!';
  vLiczba NUMBER(20, 3) := 1000.456;
BEGIN
  DBMS_OUTPUT.PUT_LINE(vTekst);
  DBMS_OUTPUT.PUT_LINE(vLiczba);
END;


-- zad 2

DECLARE
  vTekst VARCHAR(60) := 'Witaj, świecie!';
  vLiczba NUMBER(20, 3) := 1000.456;
BEGIN
  vTekst := vTekst || ' Witaj, nowy dniu!';
  vLiczba := vLiczba + POWER(10, 15);
  
  DBMS_OUTPUT.PUT_LINE(vTekst);
  DBMS_OUTPUT.PUT_LINE(vLiczba);
END;


-- zad 3

DECLARE
  a NUMBER(20, 3) := 7.08;
  b NUMBER(20, 3) := 4.884;
BEGIN
  DBMS_OUTPUT.PUT_LINE(a+b);
END;


-- zad 4

DECLARE
  cPI CONSTANT NUMBER(20, 6) := 3.14159;
  r NUMBER(20, 3) := 30;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Obwód koła o promieniu równym ' || r || ': ' || 2*cPI*r);
  DBMS_OUTPUT.PUT_LINE('Pole koła o promieniu równym ' || r || ': ' || cPI*r*r);
END;


-- zad 5

DECLARE
  vNazwisko Pracownicy.nazwisko%TYPE;
  vEtat Pracownicy.etat%TYPE;
BEGIN
  SELECT nazwisko, etat
  INTO vNazwisko, vEtat
    FROM pracownicy
    ORDER BY placa_pod DESC
    FETCH FIRST ROW ONLY;
  DBMS_OUTPUT.PUT_LINE('Najlepiej zarabia pracownik ' || vNazwisko || '.');
  DBMS_OUTPUT.PUT_LINE('Pracuje on(a) jako ' || vEtat || '.');
END;


-- zad 6

DECLARE
  vPracownik pracownicy%ROWTYPE;
BEGIN
  SELECT *
  INTO vPracownik
  FROM pracownicy
  ORDER BY placa_pod DESC
  FETCH FIRST ROW ONLY;
  
  DBMS_OUTPUT.PUT_LINE('Najlepiej zarabia pracownik ' || vPracownik.nazwisko || '.');
  DBMS_OUTPUT.PUT_LINE('Pracuje on(a) jako ' || vPracownik.etat || '.');
END;


-- zad 7

DECLARE
  vNazwisko Pracownicy.nazwisko%TYPE := 'SLOWINSKI';
  SUBTYPE tPieniadze IS NUMBER (10, 2);
  pienionszki tPieniadze;
BEGIN
  SELECT placa_pod
  INTO pienionszki
  FROM pracownicy
  WHERE nazwisko = 'SLOWINSKI';
  
  pienionszki := pienionszki *12;
  
  DBMS_OUTPUT.PUT_LINE('Pracownik ' || vNazwisko || ' zarabia rocznie ' || pienionszki || '.');
END;


-- zad 8

DECLARE
  sec INTEGER := 25;
BEGIN
  WHILE EXTRACT (SECOND FROM current_timestamp) != sec LOOP
    NULL;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Nadeszła 25 sekunda!');
END;

DECLARE
  sec INTEGER := 25;
BEGIN
  LOOP
    IF EXTRACT (SECOND FROM current_timestamp) = sec THEN
      DBMS_OUTPUT.PUT_LINE('Nadeszła 25 sekunda!');
      EXIT;
    END IF;
  END LOOP;
END;


-- zad 9

DECLARE
  num INTEGER := 6;
  fac INTEGER := 1;
BEGIN
  FOR i IN 2..num LOOP
    fac := fac * i;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(num || '! = ' || fac);
END;


-- zad 10

DECLARE
  epoch CONSTANT DATE := '2001-01-01'; 	-- poniedziałek
BEGIN
  FOR y IN 2001..2100 LOOP
    FOR m IN 1..12 LOOP
      IF (MOD(TO_DATE(y||'-'||LPAD(m, 2, '0')||'-13', 'YYYY-MM-DD') - epoch, 7) = 4) THEN
        DBMS_OUTPUT.PUT_LINE(y||'-'||LPAD(m, 2, '0')||'-13');
      END IF;
    END LOOP;
  END LOOP;
END;

-- lab 2: PL/SQL: programowanie serwera Oracle

-- zad 1

CREATE SEQUENCE Seq_Pracownicy START WITH 300 INCREMENT BY 10;

CREATE OR REPLACE PROCEDURE NowyPracownik
	(pNazwisko IN Pracownicy.nazwisko%TYPE,
	pZespol IN Zespoly.nazwa%TYPE,
    pSzef Pracownicy.nazwisko%TYPE,
    pPlaca IN Pracownicy.placa_pod%TYPE) IS
BEGIN
  INSERT INTO Pracownicy(nazwisko, placa_pod, etat, id_zesp, id_szefa, zatrudniony)
  VALUES(pNazwisko, pPlaca, 'STAZYSTA',
    (SELECT id_zesp FROM zespoly WHERE nazwa = pZespol),
    (SELECT id_prac FROM pracownicy WHERE nazwisko = pSzef),
    current_date
  );
END NowyPracownik;


-- zad 2

CREATE FUNCTION PlacaNetto
	(placa_brutto IN NUMBER,
	podatek IN NUMBER DEFAULT 20)
	RETURN NUMBER IS
	placa_netto NUMBER;
BEGIN
  RETURN placa_brutto * ((100-podatek)/100);
END PlacaNetto;


-- zad 3

CREATE OR REPLACE FUNCTION Silnia
	(liczba IN NATURAL)
	RETURN NATURAL IS
	silnia NATURAL;
BEGIN
  silnia := 1;
  FOR i IN 2..liczba LOOP
    silnia := silnia * i;
  END LOOP;
  RETURN silnia;
END Silnia;


-- zad 4

CREATE OR REPLACE FUNCTION SilniaRek
	(liczba IN NATURAL)
	RETURN NATURAL IS
BEGIN
  IF liczba < 2 THEN
    RETURN 1;
  END IF;
  RETURN SilniaRek(liczba - 1) * liczba;
END SilniaRek;

-- zad 5

CREATE OR REPLACE FUNCTION IleLat
	(data_pocz IN DATE)
	RETURN NATURAL IS
BEGIN
  RETURN TRUNC(MONTHS_BETWEEN(current_date, data_pocz)/12);
END IleLat;


-- zad 6

CREATE OR REPLACE PACKAGE Konwersja IS
	FUNCTION Cels_To_Fahr
		(cels NUMBER)
		RETURN NUMBER;

	FUNCTION Fahr_To_Cels
		(fahr NUMBER)
		RETURN NUMBER;
END Konwersja;

CREATE OR REPLACE PACKAGE BODY KONWERSJA IS
	FUNCTION Cels_To_Fahr
		(cels NUMBER)
		RETURN NUMBER IS
	BEGIN
      RETURN (cels*9/5)+32;
    END Cels_To_Fahr;

	FUNCTION Fahr_To_Cels
		(fahr NUMBER)
		RETURN NUMBER IS
	BEGIN
      RETURN (fahr-32)*5/9;
    END Fahr_To_Cels;

END Konwersja;


-- zad 7

CREATE OR REPLACE PACKAGE Zmienne IS
	PROCEDURE ZwiekszLicznik;
	PROCEDURE ZmniejszLicznik;
	
	FUNCTION PokazLicznik
		RETURN NUMBER;

END Zmienne;


CREATE OR REPLACE PACKAGE BODY Zmienne IS
	vLicznik NUMBER;

	PROCEDURE ZwiekszLicznik IS
	BEGIN
      vLicznik := vLicznik + 1;
      DBMS_OUTPUT.PUT_LINE('Zwiększono');
	END ZwiekszLicznik;

	PROCEDURE ZmniejszLicznik IS
	BEGIN
      vLicznik := vLicznik - 1;
      DBMS_OUTPUT.PUT_LINE('Zmniejszono');
	END ZmniejszLicznik;

	FUNCTION PokazLicznik
		RETURN NUMBER IS
	BEGIN
      RETURN vLicznik;
    END PokazLicznik;

	BEGIN
		vLicznik := 1;
    	DBMS_OUTPUT.PUT_LINE('Zainicjalizowano');
END Zmienne;


-- zad 8

CREATE OR REPLACE PACKAGE IntZespoly IS
    PROCEDURE addTeam(id zespoly.id_zesp%TYPE,
				nzw zespoly.nazwa%TYPE,
				adr zespoly.adres%TYPE);
    PROCEDURE removeId(id zespoly.id_zesp%TYPE);
	PROCEDURE removeName(nzw zespoly.nazwa%TYPE);
	PROCEDURE changeData(id zespoly.id_zesp%TYPE,
				nzw zespoly.nazwa%TYPE,
				adr zespoly.adres%TYPE);
	FUNCTION getId(nzw zespoly.nazwa%TYPE) RETURN zespoly.id_zesp%TYPE;
    FUNCTION getName(id zespoly.id_zesp%TYPE) RETURN zespoly.nazwa%TYPE;
    FUNCTION getAddress(id zespoly.id_zesp%TYPE) RETURN zespoly.adres%TYPE;
END IntZespoly;


CREATE OR REPLACE PACKAGE BODY IntZespoly IS
    PROCEDURE addTeam(id zespoly.id_zesp%TYPE,
				nzw zespoly.nazwa%TYPE,
				adr zespoly.adres%TYPE) IS
	BEGIN
      INSERT INTO zespoly(id_zesp, nazwa, adres)
      	VALUES(id, nzw, adr);
    END addTeam;


    PROCEDURE removeId(id zespoly.id_zesp%TYPE) IS
	BEGIN
      DELETE FROM zespoly WHERE id_zesp = id;
    END removeId;


	PROCEDURE removeName(nzw zespoly.nazwa%TYPE) IS
	BEGIN
      DELETE FROM zespoly WHERE nazwa = nzw;
    END removeName;


	PROCEDURE changeData(id zespoly.id_zesp%TYPE,
				nzw zespoly.nazwa%TYPE,
				adr zespoly.adres%TYPE) IS
	BEGIN
      UPDATE zespoly
      SET nazwa = nzw,
      	adres = adr
      WHERE id_zesp = id;
    END changeData;


	FUNCTION getId(nzw zespoly.nazwa%TYPE)
		RETURN zespoly.id_zesp%TYPE IS
		ret zespoly.id_zesp%TYPE;
	BEGIN
      SELECT id_zesp INTO ret
      	FROM zespoly WHERE nazwa = nzw;
      RETURN ret;
    END getId;


    FUNCTION getName(id zespoly.id_zesp%TYPE)
		RETURN zespoly.nazwa%TYPE IS
		ret zespoly.nazwa%TYPE;
	BEGIN
      SELECT nazwa INTO ret
      	FROM zespoly WHERE id_zesp = id;
      RETURN ret;
    END getName;


    FUNCTION getAddress(id zespoly.id_zesp%TYPE)
		RETURN zespoly.adres%TYPE IS
		ret zespoly.adres%TYPE;
	BEGIN
      SELECT adres INTO ret
      	FROM zespoly WHERE id_zesp = id;
      RETURN ret;
    END getAddress;
END IntZespoly;


-- testing
BEGIN
  IntZespoly.addTeam(2137, 'AI', 'Baraniaka 6');
 dbms_output.put_line(IntZespoly.getId('ALGORYTMY'));
  
 dbms_output.put_line(IntZespoly.getName(10));
 dbms_output.put_line(IntZespoly.getAddress(20));

 dbms_output.put_line(IntZespoly.getId('AI'));
  
 dbms_output.put_line(IntZespoly.getName(2137));
 dbms_output.put_line(IntZespoly.getAddress(2137));
END;


-- zad 9

SELECT object_name, object_type
FROM User_Objects
WHERE object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE')
ORDER BY object_name;

SELECT object_name, object_type
FROM User_Objects
WHERE object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE')
ORDER BY object_name;

-- TODO finish this


-- zad 10

-- zad 11

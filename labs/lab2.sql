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

CREATE OR REPLACE PACKAGE Konwersja IS
	FUNCTION Cels_To_Fahr
		(cels NUMBER)
		RETURN NUMBER;

	FUNCTION Fahr_To_Cels
		(fahr NUMBER)
		RETURN NUMBER;
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





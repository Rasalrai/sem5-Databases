-- PL/SQL 3 – programowanie serwera Oracle

-- zad 1

DECLARE
  CURSOR asystenci IS
	SELECT nazwisko, zatrudniony FROM pracownicy
	WHERE etat = 'ASYSTENT';
BEGIN
  FOR osoba IN asystenci LOOP
    DBMS_OUTPUT.PUT_LINE(osoba.nazwisko || ' pracuje od ' || osoba.zatrudniony);
  END LOOP;
END;


-- zad 2

DECLARE
  CURSOR zarobki IS
	SELECT nazwisko FROM pracownicy
	ORDER BY placa_pod DESC
	FETCH FIRST 3 ROWS ONLY;
BEGIN
  FOR osoba IN zarobki LOOP
    DBMS_OUTPUT.PUT_LINE(zarobki%ROWCOUNT || ' : ' || osoba.nazwisko);
  END LOOP;
END;

-- zad 3


DECLARE
  epoch CONSTANT DATE := '2001-01-01'; 	-- poniedziałek
  CURSOR podwyzka IS
	SELECT id_prac, zatrudniony FROM pracownicy
	WHERE MOD(zatrudniony - epoch, 7) = 0
	FOR UPDATE;
BEGIN
  FOR osoba IN podwyzka LOOP
    UPDATE pracownicy
    SET placa_pod = 1.2 * placa_pod
    WHERE id_prac = osoba.id_prac;
  END LOOP;
END;


-- zad 4

DECLARE
  CURSOR z IS
	SELECT nazwa, id_zesp FROM zespoly;
BEGIN
  FOR zesp IN z LOOP
    IF zesp.nazwa = 'ALGORYTMY' THEN
      UPDATE pracownicy
      SET placa_pod	 = placa_pod + 100
      WHERE id_zesp = zesp.id_zesp;
    ELSIF zesp.nazwa = 'ADMINISTRACJA' THEN
      UPDATE pracownicy
      SET placa_pod	 = placa_pod + 150
      WHERE id_zesp = zesp.id_zesp;
    ELSE
      DELETE FROM pracownicy
      WHERE id_zesp = zesp.id_zesp AND etat = 'STAZYSTA';
    END IF;
  END LOOP;
END;


-- zad 5

CREATE OR REPLACE PROCEDURE PokazPracownikowEtatu
	(etat IN pracownicy.etat%TYPE) IS
  CURSOR pracownicyEtatu(e pracownicy.etat%TYPE) IS
    SELECT nazwisko FROM pracownicy
    WHERE etat = e
    ORDER BY nazwisko;
BEGIN
  FOR osoba IN pracownicyEtatu(etat) LOOP
    DBMS_OUTPUT.PUT_LINE(osoba.nazwisko);
  END LOOP;
END PokazPracownikowEtatu;


BEGIN
  PokazPracownikowEtatu('PROFESOR');
END;


-- zad 6

CREATE OR REPLACE PROCEDURE RaportKadrowy IS
  n_pracownikow Integer;
  placa_etatu pracownicy.placa_pod%TYPE;

  CURSOR etaty IS
	SELECT DISTINCT etat FROM pracownicy;

  CURSOR pracownicyEtatu(e pracownicy.etat%TYPE) IS
    SELECT nazwisko, placa_pod, placa_dod FROM pracownicy
    WHERE etat = e
    ORDER BY nazwisko;

BEGIN
  FOR e in etaty LOOP
    placa_etatu := 0;
    n_pracownikow := 0;
    DBMS_OUTPUT.PUT_LINE('Etat: ' || e.etat);
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    FOR osoba IN pracownicyEtatu(e.etat) LOOP
      DBMS_OUTPUT.PUT_LINE(osoba.nazwisko || ' pensja: ' || osoba.placa_pod + NVL(osoba.placa_dod, 0));
      placa_etatu := placa_etatu + osoba.placa_pod + NVL(osoba.placa_dod, 0);
      n_pracownikow := n_pracownikow + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Liczba pracownikow: ' || n_pracownikow);
      
    IF n_pracownikow = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Średnia pensja: brak');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Średnia pensja: ' || placa_etatu);
    END IF;
  END LOOP;
END RaportKadrowy;

-- TODO figure out NVL(placa_dod, 0)
-- the below code works, above does not



CREATE OR REPLACE PROCEDURE RaportKadrowy IS
  n_pracownikow Integer;
  placa_etatu pracownicy.placa_pod%TYPE;

  CURSOR etaty IS
	SELECT nazwa FROM etaty;

  CURSOR pracownicyEtatu(e pracownicy.etat%TYPE) IS
    SELECT nazwisko, placa_pod, placa_dod FROM pracownicy
    WHERE etat = e
    ORDER BY nazwisko;

BEGIN
  FOR e in etaty LOOP
    placa_etatu := 0;
    n_pracownikow := 0;
    DBMS_OUTPUT.PUT_LINE('Etat: ' || e.nazwa);
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    FOR osoba IN pracownicyEtatu(e.nazwa) LOOP
      DBMS_OUTPUT.PUT_LINE(pracownicyEtatu%ROWCOUNT || '. ' || osoba.nazwisko || ', pensja: ' || osoba.placa_pod ); -- + NVL(osoba.placa_dod, 0));
      placa_etatu := placa_etatu + osoba.placa_pod; -- + NVL(osoba.placa_dod, 0);
      n_pracownikow := n_pracownikow + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Liczba pracownikow: ' || n_pracownikow);
      
    IF n_pracownikow = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Średnia pensja: brak');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Średnia pensja: ' || ROUND(placa_etatu/n_pracownikow, 2));
    END IF;
    DBMS_OUTPUT.PUT_LINE('');
  END LOOP;
END RaportKadrowy;


BEGIN
  RaportKadrowy;
END;


-- zad 7


CREATE OR REPLACE PACKAGE BODY IntZespoly IS
    PROCEDURE addTeam(id zespoly.id_zesp%TYPE,
				nzw zespoly.nazwa%TYPE,
				adr zespoly.adres%TYPE) IS
	BEGIN
      INSERT INTO zespoly(id_zesp, nazwa, adres)
      	VALUES(id, nzw, adr);

      IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nie dodano żadnego rekordu.');
      END IF;
    END addTeam;


    PROCEDURE removeId(id zespoly.id_zesp%TYPE) IS
	BEGIN
      DELETE FROM zespoly WHERE id_zesp = id;
      
      IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nie usunięto żadnego rekordu.');
      END IF;
    END removeId;


	PROCEDURE removeName(nzw zespoly.nazwa%TYPE) IS
	BEGIN
      DELETE FROM zespoly WHERE nazwa = nzw;
      
      IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nie usunięto żadnego rekordu.');
      END IF;
    END removeName;


	PROCEDURE changeData(id zespoly.id_zesp%TYPE,
				nzw zespoly.nazwa%TYPE,
				adr zespoly.adres%TYPE) IS
	BEGIN
      UPDATE zespoly
      SET nazwa = nzw,
      	adres = adr
      WHERE id_zesp = id;
      
      IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nie zmieniono żadnego rekordu.');
      END IF;
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



BEGIN
  IntZespoly.removeName('Lorem ipsum');
END;
-- Nie usunięto żadnego rekordu.


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
	IDNotFoundEx EXCEPTION;
	nameNotFoundEx EXCEPTION;
	existingIdEx EXCEPTION;
END IntZespoly;

CREATE OR REPLACE PACKAGE BODY IntZespoly IS
    PROCEDURE addTeam(id zespoly.id_zesp%TYPE,
				nzw zespoly.nazwa%TYPE,
				adr zespoly.adres%TYPE) IS
	BEGIN
      INSERT INTO zespoly(id_zesp, nazwa, adres)
      	VALUES(id, nzw, adr);

      IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nie dodano żadnego rekordu.');
      END IF;

    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        RAISE existingIdEx;
    END addTeam;

    PROCEDURE removeId(id zespoly.id_zesp%TYPE) IS
	BEGIN
      DELETE FROM zespoly WHERE id_zesp = id;
      
      IF SQL%NOTFOUND THEN
        RAISE IDNotFoundEx;
      END IF;
    END removeId;

	PROCEDURE removeName(nzw zespoly.nazwa%TYPE) IS
	BEGIN
      DELETE FROM zespoly WHERE nazwa = nzw;
      
      IF SQL%NOTFOUND THEN
        RAISE nameNotFoundEx;
      END IF;
    END removeName;

	PROCEDURE changeData(id zespoly.id_zesp%TYPE,
				nzw zespoly.nazwa%TYPE,
				adr zespoly.adres%TYPE) IS
	BEGIN
      UPDATE zespoly
      SET nazwa = nzw,
      	adres = adr
      WHERE id_zesp = id;
      
      IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nie zmieniono żadnego rekordu.');
        RAISE IDNotFoundEx;
      END IF;
    END changeData;

	FUNCTION getId(nzw zespoly.nazwa%TYPE)
		RETURN zespoly.id_zesp%TYPE IS
		ret zespoly.id_zesp%TYPE;
	BEGIN
      SELECT id_zesp INTO ret
      	FROM zespoly WHERE nazwa = nzw;
      RETURN ret;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE nameNotFoundEx;
    END getId;

    FUNCTION getName(id zespoly.id_zesp%TYPE)
		RETURN zespoly.nazwa%TYPE IS
		ret zespoly.nazwa%TYPE;
	BEGIN
      SELECT nazwa INTO ret
      	FROM zespoly WHERE id_zesp = id;
      RETURN ret;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE IDNotFoundEx;
    END getName;

    FUNCTION getAddress(id zespoly.id_zesp%TYPE)
		RETURN zespoly.adres%TYPE IS
		ret zespoly.adres%TYPE;
	BEGIN
      SELECT adres INTO ret
      	FROM zespoly WHERE id_zesp = id;
      RETURN ret;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE IDNotFoundEx;
      
    END getAddress;
END IntZespoly;


BEGIN
  -- IntZespoly.addTeam(20, 'Lorem ipsum', 'Somewhere');
  DBMS_OUTPUT.PUT_LINE(IntZespoly.getId('Lorem ipsum'));
EXCEPTION
  WHEN IntZespoly.IDNotFoundEx THEN
    DBMS_OUTPUT.PUT_LINE('Błąd: podane ID nie istnieje.');
  WHEN IntZespoly.nameNotFoundEx THEN
    DBMS_OUTPUT.PUT_LINE('Błąd: podana nazwa nie istnieje.');
  WHEN IntZespoly.existingIdEx THEN
    DBMS_OUTPUT.PUT_LINE('Błąd: zespół o takim ID już istnieje.');
END;

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






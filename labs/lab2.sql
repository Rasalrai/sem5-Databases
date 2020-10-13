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


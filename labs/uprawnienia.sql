-- USER B

-- zad 2
GRANT SELECT ON pracownicy TO inf141286;

-- zad 5
UPDATE inf141286.pracownicy
SET placa_pod = 2*placa_pod;

UPDATE inf141286.pracownicy
SET placa_pod = 2000
WHERE nazwisko = 'MORZY';

UPDATE inf141286.pracownicy
SET placa_dod = 700;



-- zad 6
CREATE SYNONYM prac_wero FOR inf141286.pracownicy;

UPDATE prac_wero
SET placa_dod = 800;

COMMIT;

-- zad 7
SELECT * FROM inf141286.pracownicy;

-- zad 8
select owner, table_name, grantee, grantor, privilege from user_tab_privs;
select table_name, grantee, grantor, privilege from user_tab_privs_made;
select owner, table_name, grantor, privilege from user_tab_privs_recd;
select owner, table_name, column_name, grantee, grantor, privilege from user_col_privs;
select table_name, column_name, grantee, grantor, privilege from   user_col_privs_made;
select owner, table_name, column_name, grantor, privilege from   user_col_privs_recd;

-- zad 9

UPDATE inf141286.pracownicy
SET placa_dod = 700;


UPDATE prac_wero
SET placa_dod = 700;

-- zad 10

CREATE ROLE rola_141286 NOT IDENTIFIED;
GRANT SELECT, UPDATE ON pracownicy TO rola_141286;

-- zad 11

SELECT * FROM inf141286.pracownicy;


-- zad 12

SET ROLE rola_141313 IDENTIFIED BY inf141313;
SELECT * FROM prac_wero;

select granted_role, admin_option from user_role_privs where username = 'INF141313';
select role, owner, table_name, column_name, privilege from role_tab_privs;

-- zad 13, 14
SELECT * FROM inf141286.pracownicy;

-- zad 16
GRANT rola_141286 to inf141286;

-- zad 18
REVOKE UPDATE ON pracownicy FROM rola_141286;

-- zad 19
DROP ROLE rola_141286;

-- zad 20
-- jako uzytkownik C: rola user_C_WJ
CREATE ROLE user_C_WJ NOT IDENTIFIED;

GRANT SELECT ON inf141286.pracownicy TO user_C_WJ;

-- zad 21
select granted_role, admin_option from user_role_privs where username = 'INF141313';
select role, owner, table_name, column_name, privilege from role_tab_privs;

-- zad 23

UPDATE inf141286.prac20
SET placa_pod = 1.1 * placa_pod;


-- zad 25, 27, 29
BEGIN
  DBMS_OUTPUT.PUT_LINE(inf141286.funLiczEtaty());
END;

SELECT * FROM inf141286.etaty;


-- zad 30
CREATE TABLE test(
    id NUMBER(2),
    tekst VARCHAR2(20)
);


-- select USER from dual
-- user_users
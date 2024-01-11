--1.
    SELECT * FROM Bank; 
--2.c
    SELECT * FROM Bank
    WHERE geschaeftssitz='Hamburg';
--3.
    SELECT mname, wohnort
    FROM Mitarbeiter
    WHERE anstellungsdatum > ('28.04.1998')
    ORDER BY mname;
--4a,
    SELECT mname, wohnort, bname, blz
    FROM Mitarbeiter, Bank
    WHERE monatsgehalt < 2500 AND bname = arbeitgeber_bank;

--4b,
    SELECT mname, wohnort, bname, blz
    From Mitarbeiter JOIN Bank on bname = arbeitgeber_bank
    WHERE monatsgehalt < 2500;
--5.
    SELECT kontonummer, kontoart
    FROM Kunde JOIN unterhaelt ON inhaber = kname
    JOIN Konto On kontonr = kontonummer
    WHERE betreuer = 'Olafson';
--6a,
    SELECT kname, kontonummer, guthaben
    FROM Mitarbeiter JOIN Bank ON bname = arbeitgeber_bank
    JOIN Kunde ON mname = betreuer
    JOIN unterhaelt ON kname = inhaber
    JOIN Konto On kontonr = kontonummer
    WHERE kontoart = 'Tagesgeld' AND geschaeftssitz = 'Frankfurt'
    ORDER BY kname, kontonummer;

--6b,
    SELECT kname, kontonummer, guthaben
    FROM Filiale JOIN Bank ON mutterbank =  bname
    JOIN Kunde ON zustaendige_filiale = fname
    JOIN unterhaelt ON kname = inhaber
    JOIN Konto On kontonr = kontonummer
    WHERE kontoart = 'Tagesgeld' AND geschaeftssitz = 'Frankfurt'
    ORDER BY kname, kontonummer;
--7.
    SELECT COUNT (*)
    FROM Mitarbeiter
    WHERE wohnort='Hamburg';
--8.
    SELECT mname, monatsgehalt
    FROM Mitarbeiter
    WHERE monatsgehalt > (SELECT AVG(monatsgehalt) FROM Mitarbeiter);
--9.
    SELECT mname, arbeitgeber_bank
    FROM Mitarbeiter
    WHERE mname IN (SELECT betreuer FROM Kunde WHERE wohnort = 'Leipzig');
--10a,
    SELECT kontonr, guthaben
    FROM Konto
    WHERE kontoart = 'Giro' AND anlage_filiale IN (SELECT fname FROM Filiale WHERE mutterbank = 'BlackBank')
    ORDER BY kontonr DESC;
--10b,
    SELECT kontonr, guthaben
    FROM Konto JOIN Filiale ON anlage_filiale = fname
    WHERE kontoart = 'Giro' AND mutterbank = 'BlackBank'
    ORDER BY kontonr DESC;
-- Active: 1704882710388@@127.0.0.1@5432@postgres
--1,
    SELECT DISTINCT biergarten_ort FROM besucht 
    JOIN gast ON nname = besucher_nname
    WHERE lieblingsgetraenk = 'Pils';
--2
    SELECT ort, AVG(Preisproliter)
    FROM biergarten JOIN schenkt_aus ON bname = biergarten_name 
    JOIN getraenk ON gname = getraenke_name
    WHERE Alkogehalt > 0
    GROUP BY (Ort);
--3
    SELECT ort, AVG(Preisproliter)
    FROM biergarten JOIN schenkt_aus ON bname = biergarten_name 
    JOIN getraenk ON gname = getraenke_name
    WHERE Alkogehalt > 0
    GROUP BY (Ort)
    HAVING SUM(ausschankprotag) > 1500;
--4
    SELECT bname
    FROM biergarten
    WHERE umsatzprojahr > (SELECT Umsatzprojahr FROM biergarten WHERE ort = 'Vilsbiburg' AND bname = 'Zur letzten Instanz')
    ORDER BY bname desc;
--5a,
    SELECT DISTINCT vname || ' ' || nname AS name, lieblingsgetraenk
    FROM gast JOIN besucht ON vname = besucher_vname AND nname = besucher_nname
    JOIN biergarten ON bname = biergarten_name
    WHERE bname > 'Fimstuben'
    ORDER BY name desc;
--5b,
    SELECT DISTINCT vname || ' ' || nname AS name, lieblingsgetraenk
    FROM gast JOIN besucht ON vname = besucher_vname AND nname = besucher_nname
    JOIN biergarten ON bname = biergarten_name 
    WHERE bname > ALL(SELECT Biergarten_name FROM Schenkt_aus JOIN biergarten ON Bname = biergarten_name WHERE getraenke_name = 'Lauwasser')
    ORDER BY name desc;
--6a,
    SELECT gname 
    FROM getraenk
    EXCEPT
    SELECT lieblingsgetraenk 
    FROM gast;
--6b,
    SELECT gname    
    FROM getraenk
    WHERE gname NOT IN (SELECT lieblingsgetraenk FROM gast);
--6c,
    SELECT gname 
    FROM getraenk
    WHERE NOT EXISTS (SELECT lieblingsgetraenk FROM gast WHERE lieblingsgetraenk = gname);
--7
    create table ortstatistik (
        stat_ort char(20),
        anzahlBiergarten int,
        Durchschnittumsatz decimal(8, 2)
    );

    INSERT INTO ortstatistik
    SELECT Ort, COUNT(*), SUM(umsatzprojahr)
    FROM Biergarten
    GROUP BY Ort;
--8
    UPDATE biergarten
    SET anzahlplaetze = (SELECT MAX(anzahlplaetze) FROM Biergarten)
    WHERE bname IN (
    SELECT biergarten_name 
    FROM besucht
    JOIN gast ON nname = besucher_nname AND vname = besucher_vname
    WHERE gebdatum < '1.1.1945');
--9a
    DELETE FROM schenkt_aus
    WHERE getraenke_name IN (SELECT gname FROM getraenk WHERE hersteller NOT IN (SELECT hersteller FROM getraenk JOIN gast ON lieblingsgetraenk = gname));
--9b
    DELETE FROM getraenk
    WHERE hersteller IN (SELECT hersteller FROM getraenk WHERE hersteller NOT IN (SELECT hersteller FROM getraenk JOIN gast ON lieblingsgetraenk = gname));
--9c
    DELETE FROM firma
    WHERE fname NOT IN (SELECT hersteller FROM getraenk WHERE gname IN (SELECT lieblingsgetraenk FROM gast));

    SELECT * FROM ortstatistik;

    DROP TABLE ortstatistik;

    SELECT * FROM getraenk;

    SELECT * FROM Biergarten;

    SELECT * FROM Schenkt_aus;

    SELECT * FROM gast;

    SELECT * FROM besucht;

    SELECT * FROM firma;

--getraenk (alkoholgehalt > 0) && (Ausschankprotag(alk) * preis (mehrere) pro standort) / gesamtausschankprotag(alk)
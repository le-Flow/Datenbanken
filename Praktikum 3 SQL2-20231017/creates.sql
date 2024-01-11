-- creates fuer Biergarten

create table firma (
   fname char(20),
   standort char(20),
   primary key (fname)
);

create table getraenk (
   gname char(20),
   alkogehalt int,
   preisproliter decimal(4,2),
   hersteller char(20) not null,
   produktionsaufname date,
   primary key (gname),
   foreign key (hersteller) references firma
);

create table gast (
   nname char(20),
   vname char(20),
   gebdatum date,
   lieblingsgetraenk char(20),
   primary key (nname, vname),
   foreign key (lieblingsgetraenk) references getraenk
);

create table biergarten (
   bname char(20),
   ort char(20),
   eroeffdatum date,
   anzahlplaetze int,
   umsatzprojahr decimal (8,2),
   primary key (bname, ort)
);


create table besucht (
   besucher_nname char(20),
   besucher_vname char(20),
   biergarten_name char(20),
   biergarten_ort char(20),
   primary key (besucher_nname, besucher_vname, biergarten_name, biergarten_ort),
   foreign key (besucher_nname, besucher_vname) references gast,
   foreign key (biergarten_name, biergarten_ort) references biergarten
);

create table schenkt_aus (
   biergarten_name char(20),
   biergarten_ort char(20),
   getraenke_name char(20),
   ausschankprotag int,
   primary key (biergarten_name, biergarten_ort, getraenke_name),
   foreign key (biergarten_name, biergarten_ort) references biergarten,
   foreign key (getraenke_name) references getraenk
);

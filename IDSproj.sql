drop table Zamestnanci CASCADE CONSTRAINTS;
drop table Zvirata CASCADE CONSTRAINTS;
drop table Lecby cascade constraints;
drop table Predpisy cascade constraints;
drop table Leky cascade constraints;
drop table Druhy cascade constraints;
drop table Osoby CASCADE CONSTRAINTS;


create table Osoby(
    osobni_cislo NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    jmeno VARCHAR(20) not null, 
    prijmeni VARCHAR(20) not null,
    titul VARCHAR(20) not null, 
    ulice VARCHAR(20) not null, 
    cislo_popisne integer not null, 
    mesto VARCHAR(20) not null, 
    psc integer not null
);

create table Zamestnanci(
    rc int not null primary key,
    cislo_uctu int,
    kod_banky int,
    pozice VARCHAR(20), 
    hodinova_mzda int,
    osobni_zaznamy int,

    foreign key (osobni_zaznamy) references Osoby(osobni_cislo) on delete cascade
);
create table Druhy(
id_druhu NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nazev varchar(20)
);

create table Zvirata(
    cislo_zvirete NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    jmeno varchar(20),
    datum_narozeni date,
    datum_posledni_prohlidky date,
    vlastnik integer,
    druh integer,
    
    foreign key (druh) references Druhy(id_druhu) on delete cascade,
    foreign key (vlastnik) references Osoby(osobni_cislo) on delete cascade
);

create table Lecby(
    kod_lecby NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    diagnoza blob, 
    datum_zahajeni date,
   stav varchar(200),
   CONSTRAINT check_stav CHECK (stav IN ('Probihajici', 'Prerusena', 'Ukoncena')),
   
   zahajujici_osetrovatel integer,
   foreign key (zahajujici_osetrovatel) references Zamestnanci(rc) on delete cascade,
   
   zvire integer,
   foreign key (zvire) references Zvirata(cislo_zvirete) on delete cascade,
   
    druh integer,
   foreign key (druh) references Druhy(id_druhu) on delete cascade
   
);
create table Leky(
    kod_leku NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazev varchar(20),
    typ varchar(20),
    kontraindikace varchar(150),
    ucinna_lata varchar(20)
);
create table Predpisy(
kod_predpisu NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
davkovani varchar(20),
doba_podavani varchar(20),
podan_v_ordinaci varchar(3),
lecba integer,
   foreign key (lecba) references Lecby(kod_lecby) on delete cascade,
   predepsany_lek integer,
   foreign key (predepsany_lek) references Leky(kod_leku) on delete cascade
);






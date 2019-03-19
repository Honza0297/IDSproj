drop table Zamestnanci CASCADE CONSTRAINTS;
drop table Zvirata CASCADE CONSTRAINTS;
drop table Lecby cascade constraints;
drop table Predpisy cascade constraints;
drop table Leky cascade constraints;
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

create table Zvirata(
    cislo_zvirete NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    jmeno varchar(20),
    datum_narozeni date,
    datum_posledni_prohlidky date,
    vlastnik integer,

    foreign key (vlastnik) references Osoby(osobni_cislo) on delete cascade
);

create table Lecby(
    kod_lecby NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    diagnoza blob, 
    datum_zahajeni date,
   stav varchar(200),
   CONSTRAINT check_stav CHECK (stav IN ('Probihajici', 'Prerusena', 'Ukoncena')) 
);

create table Predpisy(
kod_predpisu NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
davkovani varchar(20),
doba_podavani varchar(20),
podan_v_ordinaci varchar(3)
);

create table Leky(
    kod_leku NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazev varchar(20),
    typ varchar(20),
    kontraindikace varchar(150),
    ucinna_lata varchar(20)
);




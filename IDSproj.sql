drop table Zamestnanec;
drop table Zvire;
drop table Osoba;

create table Osoba(
    osobni_cislo integer not null,
    jmeno VARCHAR(20) not null, 
    prijmeni VARCHAR(20) not null,
    titul VARCHAR(20) not null, 
    ulice VARCHAR(20) not null, 
    cislo_popisne integer not null, 
    mesto VARCHAR(20) not null, 
    psc integer not null,
    
    primary key (osobni_cislo)
);

create table Zamestnanec(
    rc int not null,
    cislo_uctu int,
    kod_banky int,
    pozice VARCHAR(20), 
    hodinova_mzda int,
    osobni_zaznamy int,
    
    primary key (rc),
    foreign key (osobni_zaznamy) references Osoba on delete cascade
);

create table Zvire(
    cislo_zvirete varchar(20),
    jmeno varchar(20),
    datum_narozeni date,
    datum_posledni_prohlidky date,
    vlastnik integer,
    
    primary key (cislo_zvirete),
    foreign key (vlastnik) references Osoba on delete cascade
);
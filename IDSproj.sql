DROP TABLE Zamestnanci CASCADE CONSTRAINTS;
DROP TABLE Zvirata CASCADE CONSTRAINTS;
DROP TABLE Lecby CASCADE CONSTRAINTS;
DROP TABLE Predpisy CASCADE CONSTRAINTS;
DROP TABLE Leky CASCADE CONSTRAINTS;
DROP TABLE Druhy CASCADE CONSTRAINTS;
DROP TABLE Nemoci CASCADE CONSTRAINTS;
DROP TABLE Urceni_leku_pro_nemoc CASCADE CONSTRAINTS;
DROP TABLE Davkovani_pro_druh CASCADE CONSTRAINTS;
DROP TABLE Osoby CASCADE CONSTRAINTS;


CREATE TABLE Osoby(
    osobni_cislo NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    jmeno VARCHAR(255) NOT NULL, 
    prijmeni VARCHAR(255) NOT NULL,
    titul VARCHAR(255), 
    ulice VARCHAR(255) NOT NULL, 
    cislo_popisne NUMBER NOT NULL, 
    mesto VARCHAR(255) NOT NULL, 
    psc NUMBER NOT NULL
);

CREATE TABLE Zamestnanci(
    rc NUMBER NOT NULL PRIMARY KEY,
    cislo_uctu NUMBER,
    kod_banky NUMBER,
    pozice VARCHAR(20) NOT NULL, 
    hodinova_mzda NUMBER NOT NULL,
    osobni_zaznamy NUMBER NOT NULL,

    FOREIGN KEY (osobni_zaznamy) REFERENCES Osoby(osobni_cislo) ON DELETE CASCADE
);

CREATE TABLE Druhy(
    id_druhu NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazev VARCHAR(50) NOT NULL
);

CREATE TABLE Zvirata(
    cislo_zvirete NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    jmeno VARCHAR(50),
    datum_narozeni DATE NOT NULL,
    datum_posledni_prohlidky DATE NOT NULL,
    vlastnik NUMBER NOT NULL,
    druh NUMBER NOT NULL,
    
    FOREIGN KEY (druh) REFERENCES Druhy(id_druhu) ON DELETE CASCADE,
    FOREIGN KEY (vlastnik) REFERENCES Osoby(osobni_cislo) ON DELETE CASCADE
);

CREATE TABLE Lecby(
    kod_lecby NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    diagnoza VARCHAR(500) NOT NULL, 
    datum_zahajeni DATE NOT NULL,
    stav VARCHAR(50) DEFAULT 'Probihajici' CHECK (stav IN ('Probihajici', 'Prerusena', 'Ukoncena')),
   
   zahajujici_osetrovatel NUMBER NOT NULL,
   FOREIGN KEY (zahajujici_osetrovatel) REFERENCES Zamestnanci(rc) ON DELETE CASCADE,
   
   zvire NUMBER NOT NULL,
   FOREIGN KEY (zvire) REFERENCES Zvirata(cislo_zvirete) ON DELETE CASCADE
);

CREATE TABLE Leky(
    kod_leku NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazev VARCHAR(20) NOT NULL,
    typ VARCHAR(20) NOT NULL,
    kontraindikace VARCHAR(150),
    ucinna_latka VARCHAR(20) NOT NULL
);

CREATE TABLE Predpisy( 
    kod_predpisu NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    davkovani VARCHAR(20) NOT NULL,
    doba_podavani VARCHAR(20),    
    podan_v_ordinaci VARCHAR(3) NOT NULL,
    CONSTRAINT podan_v_ordinaci CHECK (podan_v_ordinaci IN ('ANO', 'NE')),
    
    kod_lecby NUMBER NOT NULL,
    FOREIGN KEY (kod_lecby) REFERENCES Lecby(kod_lecby) ON DELETE CASCADE,
    
    predepsany_lek NUMBER NOT NULL,
    FOREIGN KEY (predepsany_lek) REFERENCES Leky(kod_leku) ON DELETE CASCADE,

    vypsal NUMBER NOT NULL,
    FOREIGN KEY (vypsal) REFERENCES Zamestnanci(rc) ON DELETE CASCADE    
);

CREATE TABLE Nemoci(
    kod_nemoci NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazev varchar(255) NOT NULL
);

CREATE TABLE Urceni_leku_pro_nemoc (
    kod_nemoci NUMBER NOT NULL,
    CONSTRAINT ur_kod_nemoci FOREIGN KEY (kod_nemoci) REFERENCES Nemoci(kod_nemoci),
    
    kod_leku NUMBER NOT NULL,   
    CONSTRAINT ur_kod_leku FOREIGN KEY (kod_leku) REFERENCES Leky(kod_leku)
);

CREATE TABLE Davkovani_pro_druh(
    doporucene_davkovani number not null,
    kod_leku NUMBER NOT NULL,
    CONSTRAINT da_kod_leku FOREIGN KEY (kod_leku) REFERENCES Leky(kod_leku),
    
    id_druhu NUMBER NOT NULL,   
    CONSTRAINT da_id_druhu FOREIGN KEY (id_druhu) REFERENCES Druhy(id_druhu)
);


INSERT INTO Osoby(jmeno, prijmeni, ulice, cislo_popisne, mesto, psc) 
    VALUES('Jan', 'Beran', 'Bozetechova', 2, 'Ceska Trebova', 56003);
    
INSERT INTO Druhy(nazev)
    VALUES('kocka');
    
INSERT INTO Zvirata(jmeno, datum_narozeni, datum_posledni_prohlidky, vlastnik, druh) 
    VALUES('Micka', DATE'1998-12-20', DATE'2019-3-19', (SELECT osobni_cislo FROM Osoby WHERE jmeno='Jan' AND prijmeni='Beran' ), (SELECT id_druhu FROM Druhy WHERE nazev='kocka' ) );



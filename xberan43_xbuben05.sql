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
    jmeno VARCHAR(25) NOT NULL, 
    prijmeni VARCHAR(40) NOT NULL,
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

    FOREIGN KEY (osobni_zaznamy) REFERENCES Osoby ON DELETE CASCADE
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
    
    FOREIGN KEY (druh) REFERENCES Druhy ON DELETE CASCADE,
    FOREIGN KEY (vlastnik) REFERENCES Osoby ON DELETE CASCADE
);

CREATE TABLE Lecby(
    kod_lecby NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    diagnoza VARCHAR(500) NOT NULL, 
    datum_zahajeni DATE NOT NULL,
    stav VARCHAR(50) DEFAULT 'Probihajici' CHECK (stav IN ('Probihajici', 'Prerusena', 'Ukoncena')),
   
   zahajujici_osetrovatel NUMBER NOT NULL,
   FOREIGN KEY (zahajujici_osetrovatel) REFERENCES Zamestnanci ON DELETE CASCADE,
   
   zvire NUMBER NOT NULL,
   FOREIGN KEY (zvire) REFERENCES Zvirata ON DELETE CASCADE
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
    davkovani VARCHAR(255) NOT NULL,
    doba_podavani VARCHAR(20),    
    podan_v_ordinaci VARCHAR(3) NOT NULL,
    CONSTRAINT podan_v_ordinaci CHECK (podan_v_ordinaci IN ('ANO', 'NE')),
    
    kod_lecby NUMBER NOT NULL,
    FOREIGN KEY (kod_lecby) REFERENCES Lecby ON DELETE CASCADE,
    
    predepsany_lek NUMBER NOT NULL,
    FOREIGN KEY (predepsany_lek) REFERENCES Leky ON DELETE CASCADE,

    vypsal NUMBER NOT NULL,
    FOREIGN KEY (vypsal) REFERENCES Zamestnanci ON DELETE CASCADE    
);

CREATE TABLE Nemoci(
    kod_nemoci NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazev varchar(255) NOT NULL
);

CREATE TABLE Urceni_leku_pro_nemoc (
    kod_nemoci NUMBER NOT NULL,
    CONSTRAINT ur_kod_nemoci FOREIGN KEY (kod_nemoci) REFERENCES Nemoci,
    
    kod_leku NUMBER NOT NULL,   
    CONSTRAINT ur_kod_leku FOREIGN KEY (kod_leku) REFERENCES Leky
);

CREATE TABLE Davkovani_pro_druh(
    doporucene_davkovani VARCHAR(255) not null,
    kod_leku NUMBER NOT NULL,
    CONSTRAINT da_kod_leku FOREIGN KEY (kod_leku) REFERENCES Leky,
    
    id_druhu NUMBER NOT NULL,   
    CONSTRAINT da_id_druhu FOREIGN KEY (id_druhu) REFERENCES Druhy
);


INSERT INTO Osoby(jmeno, prijmeni, ulice, cislo_popisne, mesto, psc) 
    VALUES('Jan', 'Beran', 'Božetěchova', 2, 'Česká Třebová', 56003);

INSERT INTO Osoby(jmeno, prijmeni, titul, ulice, cislo_popisne, mesto, psc) 
    VALUES('Stanislav', 'Stejskal','MVDr.', 'Kuldova', 654, 'Brno', 60025);

INSERT INTO Osoby(jmeno, prijmeni, ulice, cislo_popisne, mesto, psc) 
    VALUES('Josef', 'Vysokomýtský', 'Ústecká', 1002, 'Liberec', 56203);

INSERT INTO Osoby(jmeno, prijmeni, titul, ulice, cislo_popisne, mesto, psc) 
    VALUES('Jasan', 'Statham', 'Ph.D. Ing.','1st Avenue', 65487, 'New York', 56991);

INSERT INTO Osoby(jmeno, prijmeni, ulice, cislo_popisne, mesto, psc) 
    VALUES('Kamil', 'Vondra', 'Ostravska', 21, 'Opava', 96003);

INSERT INTO Osoby(jmeno, prijmeni, ulice, cislo_popisne, mesto, psc) 
    VALUES('Kamila', 'Krátká', 'Bří Čapků', 201, 'Aš', 16003);
    
INSERT INTO Osoby(jmeno, prijmeni, ulice, cislo_popisne, mesto, psc) 
    VALUES('Aneta', 'Kafkova', 'Kounicova', 21, 'Valasske Mezirici', 16903);
    
INSERT INTO Osoby(jmeno, prijmeni, ulice, cislo_popisne, mesto, psc) 
    VALUES('Helmut', 'Heinz', 'Drobneho', 38, 'Brno', 60020);

INSERT INTO Zamestnanci(rc, cislo_uctu, kod_banky, pozice, hodinova_mzda, osobni_zaznamy) 
    VALUES(0405805487, 1236548942, 300, 'doktor', 220, (SELECT osobni_cislo FROM Osoby WHERE prijmeni='Stejskal' AND jmeno='Stanislav'));

INSERT INTO Zamestnanci(rc, cislo_uctu, kod_banky, pozice, hodinova_mzda, osobni_zaznamy) 
    VALUES(0405905487, 1236543242, 3030, ' sestra', 190, (SELECT osobni_cislo FROM Osoby WHERE prijmeni='Krátká' AND jmeno='Kamila'));

INSERT INTO Zamestnanci(rc, cislo_uctu, kod_banky, pozice, hodinova_mzda, osobni_zaznamy) 
    VALUES(0405705487, 1231243242, 0600, 'sestra', 175, (SELECT osobni_cislo FROM Osoby WHERE prijmeni='Kafkova' AND jmeno='Aneta'));
    
INSERT INTO Zamestnanci(rc, cislo_uctu, kod_banky, pozice, hodinova_mzda, osobni_zaznamy) 
    VALUES(0905705487, 1266843242, 0600, 'opravar', 130, (SELECT osobni_cislo FROM Osoby WHERE prijmeni='Heinz' AND jmeno='Helmut'));
    
INSERT INTO Druhy(nazev)
    VALUES('kočka');

INSERT INTO Druhy(nazev)
    VALUES('pes');

INSERT INTO Druhy(nazev)
    VALUES('krokodýl');

INSERT INTO Druhy(nazev)
    VALUES('potkan');

INSERT INTO Druhy(nazev)
    VALUES('koza');

INSERT INTO Druhy(nazev)
    VALUES('křeček');


INSERT INTO Nemoci(nazev)
    VALUES('malárie');

INSERT INTO Nemoci(nazev)
    VALUES('zablešení');

INSERT INTO Nemoci(nazev)
    VALUES('rakovina');

INSERT INTO Nemoci(nazev)
    VALUES('slintavka');


INSERT INTO Leky(nazev, typ, kontraindikace, ucinna_latka)
    VALUES('amalar', 'antimalarika', 'alergie', 'AM2013');

INSERT INTO Leky(nazev, typ, kontraindikace, ucinna_latka)
    VALUES('blechostop2000', 'antiparazitni', 'otevřené rány', 'oxid manganičitý');

INSERT INTO Leky(nazev, typ, ucinna_latka)
    VALUES('sutlam', 'antibiotika', 'penicilin');


INSERT INTO Urceni_leku_pro_nemoc(kod_nemoci, kod_leku)
    VALUES((SELECT kod_nemoci FROM Nemoci WHERE nazev='slintavka'), (SELECT kod_leku FROM Leky WHERE nazev='sutlam'));

INSERT INTO Urceni_leku_pro_nemoc(kod_nemoci, kod_leku)
    VALUES((SELECT kod_nemoci FROM Nemoci WHERE nazev='malárie'), (SELECT kod_leku FROM Leky WHERE nazev='amalar'));

INSERT INTO Urceni_leku_pro_nemoc(kod_nemoci, kod_leku)
    VALUES((SELECT kod_nemoci FROM Nemoci WHERE nazev='zablešení'), (SELECT kod_leku FROM Leky WHERE nazev='blechostop2000'));

INSERT INTO Urceni_leku_pro_nemoc(kod_nemoci, kod_leku)
    VALUES((SELECT kod_nemoci FROM Nemoci WHERE nazev='zablešení'), (SELECT kod_leku FROM Leky WHERE nazev='sutlam'));


INSERT INTO Davkovani_pro_druh(doporucene_davkovani, kod_leku, id_druhu)
    VALUES('2x2',(SELECT kod_leku FROM Leky WHERE nazev='sutlam'), (SELECT id_druhu FROM Druhy WHERE nazev='kočka'));    

INSERT INTO Davkovani_pro_druh(doporucene_davkovani, kod_leku, id_druhu)
    VALUES('3x3',(SELECT kod_leku FROM Leky WHERE nazev='sutlam'), (SELECT id_druhu FROM Druhy WHERE nazev='koza')); 

INSERT INTO Davkovani_pro_druh(doporucene_davkovani, kod_leku, id_druhu)
    VALUES('2x denně půl tablety',(SELECT kod_leku FROM Leky WHERE nazev='sutlam'), (SELECT id_druhu FROM Druhy WHERE nazev='potkan')); 

INSERT INTO Davkovani_pro_druh(doporucene_davkovani, kod_leku, id_druhu)
    VALUES('1x mesicne 2ml',(SELECT kod_leku FROM Leky WHERE nazev='amalar'), (SELECT id_druhu FROM Druhy WHERE nazev='kočka')); 

INSERT INTO Davkovani_pro_druh(doporucene_davkovani, kod_leku, id_druhu)
    VALUES('1x mesicne 5ml',(SELECT kod_leku FROM Leky WHERE nazev='amalar'), (SELECT id_druhu FROM Druhy WHERE nazev='pes')); 
    

INSERT INTO Zvirata(jmeno, datum_narozeni, datum_posledni_prohlidky, vlastnik, druh) 
    VALUES('Micka', DATE'1998-12-20', DATE'2019-3-19', (SELECT osobni_cislo FROM Osoby WHERE jmeno='Jan' AND prijmeni='Beran' ), (SELECT id_druhu FROM Druhy WHERE nazev='kočka' ) );

INSERT INTO Zvirata(jmeno, datum_narozeni, datum_posledni_prohlidky, vlastnik, druh) 
    VALUES('Rex', DATE'2016-12-20', DATE'2018-3-19', (SELECT osobni_cislo FROM Osoby WHERE jmeno='Kamila' AND prijmeni='Krátká' ), (SELECT id_druhu FROM Druhy WHERE nazev='pes' ) );

INSERT INTO Zvirata(datum_narozeni, datum_posledni_prohlidky, vlastnik, druh) 
    VALUES(DATE'2015-11-30', DATE'2019-3-19', (SELECT osobni_cislo FROM Osoby WHERE jmeno='Kamila' AND prijmeni='Krátká' ), (SELECT id_druhu FROM Druhy WHERE nazev='koza' ) );

INSERT INTO Zvirata(jmeno, datum_narozeni, datum_posledni_prohlidky, vlastnik, druh) 
    VALUES('Mourek', DATE'2009-10-10', DATE'2019-3-2', (SELECT osobni_cislo FROM Osoby WHERE jmeno='Jasan' AND prijmeni='Statham' ), (SELECT id_druhu FROM Druhy WHERE nazev='kočka' ) );


INSERT INTO Lecby(diagnoza, datum_zahajeni, stav, zahajujici_osetrovatel, zvire)
	VALUES('Vysoké teploty, pravděpodobně slintavka', DATE'2019-03-10', 'Probihajici', (SELECT rc FROM Zamestnanci Z, Osoby O WHERE Z.osobni_zaznamy=O.osobni_cislo AND O.prijmeni='Stejskal'), (SELECT cislo_zvirete FROM Zvirata WHERE jmeno='Micka'));

INSERT INTO Lecby(diagnoza, datum_zahajeni, stav, zahajujici_osetrovatel, zvire)
	VALUES('má blechy', DATE'2019-01-10', 'Ukoncena', (SELECT rc FROM Zamestnanci Z, Osoby O WHERE Z.osobni_zaznamy=O.osobni_cislo AND O.prijmeni='Stejskal'), (SELECT cislo_zvirete FROM Zvirata WHERE jmeno='Rex'));

INSERT INTO Predpisy(davkovani, doba_podavani, podan_v_ordinaci, kod_lecby, predepsany_lek, vypsal)
	VALUES('2x2 tablety denně', 'tyden', 'NE', (SELECT L.kod_lecby FROM Lecby L, Zvirata Z WHERE L.datum_zahajeni=DATE'2019-03-10' AND Z.jmeno='Micka' AND L.zvire=Z.cislo_zvirete), (SELECT kod_leku FROM Leky WHERE nazev='sutlam'), (SELECT rc FROM Zamestnanci Z, Osoby O WHERE Z.osobni_zaznamy=O.osobni_cislo AND O.prijmeni='Stejskal'));
    
    
    
    
    
  
/*Spojeni tri tabulek: kdo vlastni kocku?*/
select osoby.osobni_cislo, osoby.prijmeni, osoby.jmeno from
osoby join zvirata on osoby.osobni_cislo = zvirata.vlastnik join druhy on zvirata.druh = druhy.id_druhu
where druhy.nazev = 'kočka';


/*Spojení dvou tabulek (přes vazební tabulku): Který lék léčí malárii? */
select leky.nazev from
leky join urceni_leku_pro_nemoc on leky.kod_leku = urceni_leku_pro_nemoc.kod_leku join nemoci on urceni_leku_pro_nemoc.kod_nemoci = nemoci.kod_nemoci
where nemoci.nazev = 'malárie';

/*Dotaz s group_by: Kolik zvirat mají jednotlivé osoby? Osoby bez zvirat nas nezajimaji*/
select osoby.prijmeni, osoby.jmeno, count(zvirata.vlastnik) as pocet_zviratek from
osoby join zvirata on osoby.osobni_cislo = zvirata.vlastnik
group by(osoby.prijmeni, osoby.jmeno);

/*Dotaz s vnorenym selectem: Kdo ma plat vyssi nez prumerny?*/
select osoby.prijmeni, osoby.jmeno, zamestnanci.pozice from
zamestnanci join osoby on zamestnanci.osobni_zaznamy = osoby.osobni_cislo
where zamestnanci.hodinova_mzda > 
    (select AVG(hodinova_mzda) from zamestnanci);


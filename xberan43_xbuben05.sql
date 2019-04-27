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

DROP SEQUENCE osoba_sequence;
 SET SERVEROUTPUT ON
CREATE SEQUENCE osoba_sequence START WITH 1 INCREMENT BY 1 NOCYCLE;

CREATE TABLE Osoby(
    osobni_cislo NUMBER PRIMARY KEY,
    jmeno VARCHAR(25) NOT NULL, 
    prijmeni VARCHAR(40) NOT NULL,
    titul VARCHAR(40), 
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
    cena NUMBER,
    datum_zahajeni DATE NOT NULL,
    stav VARCHAR(50) DEFAULT 'Probihajici' CHECK (stav IN ('Probihajici', 'Prerusena', 'Ukoncena')),
   
   zahajujici_osetrovatel NUMBER NOT NULL,
   FOREIGN KEY (zahajujici_osetrovatel) REFERENCES Zamestnanci ON DELETE CASCADE,
   
   zvire NUMBER NOT NULL,
   FOREIGN KEY (zvire) REFERENCES Zvirata ON DELETE CASCADE
);

CREATE TABLE Leky(
    kod_leku NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cena_leku number not null,
    nazev VARCHAR(20) NOT NULL,
    typ VARCHAR(20) NOT NULL,
    kontraindikace VARCHAR(150),
    ucinna_latka VARCHAR(20) NOT NULL
);

CREATE TABLE Predpisy( 
    kod_predpisu NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    doplatek NUMBER NOT NULL,
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


create or replace trigger cena_lecby 
before insert or update of predepsany_lek, doplatek on Predpisy 
for each row 
declare 
max_doplatek_leku number; 
begin 
select cena_leku 
into max_doplatek_leku 
from Leky 
where Leky.kod_leku = :NEW.predepsany_lek; 
if(:NEW.doplatek > max_doplatek_leku) 
then raise_application_error(-20429,'Doplatek nemuze byt vyssi nez cela cena leku!'); 
end if; 
end; 
/


create or replace trigger id_osoba_trigger
before insert on Osoby
for each row
begin
select osoba_sequence.nextval INTO :NEW.osobni_cislo from dual;
end;
/


INSERT INTO Osoby( jmeno, prijmeni, ulice, cislo_popisne, mesto, psc) 
    VALUES( 'Jan', 'Beran', 'Božetěchova', 2, 'Česká Třebová', 56003);

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
    VALUES('Karel', 'Krátký', 'Bří Čapků', 201, 'Aš', 16003);
    
INSERT INTO Osoby(jmeno, prijmeni, ulice, cislo_popisne, mesto, psc) 
    VALUES('Jiří', 'Záviš', 'Antonínská', 2201, 'Ostrava', 16403);

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


INSERT INTO Leky(nazev, cena_leku, typ, kontraindikace, ucinna_latka)
    VALUES('amalar', 300, 'antimalarika', 'alergie', 'AM2013');

INSERT INTO Leky(nazev, cena_leku, typ, kontraindikace, ucinna_latka)
    VALUES('blechostop2000', 250, 'antiparazitni', 'otevřené rány', 'oxid manganičitý');

INSERT INTO Leky(nazev, cena_leku, typ, ucinna_latka)
    VALUES('sutlam', 500, 'antibiotika', 'penicilin');


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

INSERT INTO Zvirata(jmeno, datum_narozeni, datum_posledni_prohlidky, vlastnik, druh) 
    VALUES('Pardál', DATE'2011-09-10', DATE'2019-3-2', (SELECT osobni_cislo FROM Osoby WHERE jmeno='Karel' AND prijmeni='Krátký' ), (SELECT id_druhu FROM Druhy WHERE nazev='kočka' ) );
    
    
INSERT INTO Lecby(diagnoza,cena, datum_zahajeni, stav, zahajujici_osetrovatel, zvire)
    VALUES('Vysoké teploty, pravděpodobně slintavka',500, DATE'2019-03-10', 'Probihajici', (SELECT rc FROM Zamestnanci Z, Osoby O WHERE Z.osobni_zaznamy=O.osobni_cislo AND O.prijmeni='Stejskal'), (SELECT cislo_zvirete FROM Zvirata WHERE jmeno='Micka'));

INSERT INTO Lecby(diagnoza, cena, datum_zahajeni, stav, zahajujici_osetrovatel, zvire)
    VALUES('má blechy', 200, DATE'2019-01-10', 'Ukoncena', (SELECT rc FROM Zamestnanci Z, Osoby O WHERE Z.osobni_zaznamy=O.osobni_cislo AND O.prijmeni='Stejskal'), (SELECT cislo_zvirete FROM Zvirata WHERE jmeno='Rex'));

INSERT INTO Lecby(diagnoza, cena, datum_zahajeni, stav, zahajujici_osetrovatel, zvire)
    VALUES('chybí levá přední noha', 20000, DATE'2017-06-10', 'Ukoncena', (SELECT rc FROM Zamestnanci Z, Osoby O WHERE Z.osobni_zaznamy=O.osobni_cislo AND O.prijmeni='Stejskal'), (SELECT cislo_zvirete FROM Zvirata WHERE jmeno='Rex'));

INSERT INTO Predpisy(doplatek, davkovani, doba_podavani, podan_v_ordinaci, kod_lecby, predepsany_lek, vypsal)
    VALUES(100, '2x2 tablety denně', 'tyden', 'NE', (SELECT L.kod_lecby FROM Lecby L, Zvirata Z WHERE L.datum_zahajeni=DATE'2019-03-10' AND Z.jmeno='Micka' AND L.zvire=Z.cislo_zvirete), (SELECT kod_leku FROM Leky WHERE nazev='sutlam'), (SELECT rc FROM Zamestnanci Z, Osoby O WHERE Z.osobni_zaznamy=O.osobni_cislo AND O.prijmeni='Stejskal'));
    
    
    
    
    
  
/*Spojeni tri tabulek: kdo vlastni kocku?*/
select osoby.osobni_cislo, osoby.prijmeni, osoby.jmeno from
osoby join zvirata on osoby.osobni_cislo = zvirata.vlastnik join druhy on zvirata.druh = druhy.id_druhu
where druhy.nazev = 'kočka';

/*Spojení dvou tabulek: Jmena všech evidovaných psů?*/
select Z.jmeno
from zvirata Z, druhy D
where D.nazev = 'pes' and Z.druh = D.id_druhu;

/*Spojení dvou tabulek (přes vazební tabulku): Který lék léčí malárii? */
select leky.nazev from
leky join urceni_leku_pro_nemoc on leky.kod_leku = urceni_leku_pro_nemoc.kod_leku join nemoci on urceni_leku_pro_nemoc.kod_nemoci = nemoci.kod_nemoci
where nemoci.nazev = 'malárie';

/*Dotaz s group_by: Kolik stály všechny léčby jednotlivých zvířat v součtu?*/
select Z.cislo_zvirete, Z.jmeno, sum(L.cena) as cena_za_lecby
from zvirata Z, lecby L
where L.zvire = Z.cislo_zvirete
group by(Z.cislo_zvirete, Z.jmeno)
order by(cena_za_lecby) desc;

/*Dotaz s group_by: Kolik zvirat mají jednotlivé osoby? Osoby bez zvirat nas nezajimaji*/
select osoby.prijmeni, osoby.jmeno, count(zvirata.vlastnik) as pocet_zviratek from
osoby join zvirata on osoby.osobni_cislo = zvirata.vlastnik
group by(osoby.prijmeni, osoby.jmeno);

/*Dotaz s exists: Vypiš lecby s cenou menší než 2000*/
select diagnoza, cena
from lecby L
where exists (select * from lecby where L.cena < 2000);

/*Dotaz s IN a vnořeným selectem: Vypis evidovaných osob, které ale nejsou zaměstnanci kliiky*/
select jmeno, prijmeni
from osoby
where osobni_cislo not in (select zamestnanci.osobni_zaznamy from zamestnanci);

/*Dotaz s vnorenym selectem: Kdo ma plat vyssi nez prumerny?*/
select osoby.prijmeni, osoby.jmeno, zamestnanci.pozice from
zamestnanci join osoby on zamestnanci.osobni_zaznamy = osoby.osobni_cislo
where zamestnanci.hodinova_mzda > 
    (select AVG(hodinova_mzda) from zamestnanci);
    

create or replace procedure informace_o_cloveku(id_cloveka NUMBER) as
    jmenoo osoby.jmeno%type;
    prijmenii osoby.prijmeni%type;
    mestoo osoby.mesto%type;
    begin
        select jmeno, prijmeni, mesto into jmenoo, prijmenii, mestoo from osoby where osobni_cislo = id_cloveka;
        DBMS_OUTPUT.put_line('Clovek s danym ID: ' || jmenoo|| ' ' || prijmenii||' bydli ve meste: ' || mestoo);
    exception
        when no_data_found then
        DBMS_OUTPUT.put_line('Clovek se zadanym ID neexistuje.');
end informace_o_cloveku;
/

create or replace procedure zvirata_uzivajici_leky(lek varchar) as
    jmenoo zvirata.jmeno%type;
    cisloo zvirata.cislo_zvirete%type;
    cursor kur is
        select Z.jmeno, Z.cislo_zvirete from zvirata Z, predpisy P, leky L, lecby B 
            where L.nazev = lek and L.kod_leku = P.predepsany_lek and P.kod_lecby = B.kod_lecby and B.zvire = Z.cislo_zvirete;
    begin
    open kur;
    loop
        fetch kur into jmenoo, cisloo;
        DBMS_OUTPUT.put_line('Zvire s ID ' || cisloo || ' a jmenem ' || jmenoo ||' uziva lek ' || lek);
        exit when kur%notfound;
    end loop;        
    close kur;
end;
/

create or replace procedure informace_o_lidech as
    jmenoo osoby.jmeno%type;
    prijmenii osoby.prijmeni%type;
    mestoo osoby.mesto%type;
    cursor kur_cl is
        select jmeno, prijmeni, mesto from osoby;
    begin
        open kur_cl;
        loop
        fetch kur_cl into jmenoo, prijmenii, mestoo;
            exit when kur_cl%notfound;    
            DBMS_OUTPUT.put_line('Clovek ' || jmenoo|| ' ' || prijmenii||' bydli ve meste: ' || mestoo);
        end loop;
        close kur_cl;
end;
/

grant all on Zamestnanci to xbuben05;
grant all on Zvirata to xbuben05;
grant all on Lecby to xbuben05; 
grant all on Predpisy to xbuben05;
grant all on Leky to xbuben05;
grant all on Druhy to xbuben05;
grant all on Nemoci to xbuben05;
grant all on Urceni_leku_pro_nemoc to xbuben05;
grant all on Davkovani_pro_druh to xbuben05;
grant all on Osoby to xbuben05;


grant execute on informace_o_lidech to xbuben05;
grant execute on informace_o_cloveku to xbuben05;
grant execute on zvirata_uzivajici_leky to xbuben05;


call zvirata_uzivajici_leky('sutlam');
call informace_o_lidech();
call informace_o_cloveku(2);

/*Trigger na cenu leku zahlasi chybu v doplatku*/
INSERT INTO Predpisy(doplatek, davkovani, doba_podavani, podan_v_ordinaci, kod_lecby, predepsany_lek, vypsal)
    VALUES(1000, '2x2 tablety denně', 'tyden', 'NE', (SELECT L.kod_lecby FROM Lecby L, Zvirata Z WHERE L.datum_zahajeni=DATE'2019-03-10' AND Z.jmeno='Micka' AND L.zvire=Z.cislo_zvirete), (SELECT kod_leku FROM Leky WHERE nazev='sutlam'), (SELECT rc FROM Zamestnanci Z, Osoby O WHERE Z.osobni_zaznamy=O.osobni_cislo AND O.prijmeni='Stejskal'));
    
    
/*Explain plan*/
explain plan
for
select osoby.prijmeni, osoby.jmeno, count(zvirata.vlastnik) as pocet_zviratek from
osoby join zvirata on osoby.osobni_cislo = zvirata.vlastnik
group by(osoby.prijmeni, osoby.jmeno);
SELECT * FROM TABLE(dbms_xplan.display);

create index zvirata_vlastnik
on zvirata(vlastnik);
create index osoby_index
on osoby(prijmeni, jmeno);

explain plan
for
select osoby.prijmeni, osoby.jmeno, count(zvirata.vlastnik) as pocet_zviratek from
zvirata join osoby on osoby.osobni_cislo = zvirata.vlastnik
group by(osoby.prijmeni, osoby.jmeno);
SELECT * FROM TABLE(dbms_xplan.display);

drop index zvirata_vlastnik;
drop index osoby_index;

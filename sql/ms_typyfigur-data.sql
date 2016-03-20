INSERT INTO ms_pravidla SET nazev = "Standartní", id_sada = 1, poli_x = 10, poli_y = 15;

/* CREATE TABLE `marsal`.`ms_typyfigur` (
    `id` INT UNSIGNED NOT NULL,
    `nazev` VARCHAR(45) NOT NULL,
    `obrazek` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`id`)
) */
TRUNCATE ms_typyfigur;
INSERT INTO ms_typyfigur (sada, id, nazev, obrazek) VALUES
 (1, 1, "Bomba",    "unit01.gif")
,(1, 2, "Maršál",   "unit02.gif")
,(1, 3, "Generál",  "unit03.gif")
,(1, 4, "Kaprál",   "unit04.gif")
,(1, 5, "Kadet",    "unit05.gif")
,(1, 6, "Kapitán",  "unit06.gif")
,(1, 7, "Przkumník","unit07.gif")
,(1, 8, "Voják",    "unit08.gif")
,(1, 9, "Minér",    "unit09.gif")
,(1, 10, "Špión",   "unit10.gif")
,(1, 11, "Prapor",  "unit11.gif")
,(1, 50, "Neznámo", "unit50.gif")
;

/* CREATE TABLE `marsal`.`ms_typyfigur_vyhrava` (
    `vyhrava` TINYINT UNSIGNED NOT NULL,
    `prohrava` TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY (`vyhrava`, `prohrava`)
) */
TRUNCATE ms_typyfigur_vyhrava;
INSERT INTO ms_typyfigur_vyhrava (pravidla, vyhrava, prohrava) VALUES
 (1,  9, 1) -- Miner nad Bombou
,(1, 10, 2) -- Spion nad Marsalem
;


DELETE FROM ms_typyfigur_pohyb;
-- Normalni figura - chodi o jedno pole, utoci jen nediagonalne
INSERT INTO ms_typyfigur_pohyb (id_sada, id_pravidla, id_typ, x, y, muze_utocit) VALUES
 (1,1,  0,  0,  1, true)
,(1,1,  0,  0, -1, true)
,(1,1,  0,  1,  0, true)
,(1,1,  0, -1,  0, true)
,(1,1,  0,  1,  1, false)
,(1,1,  0, -1,  1, false)
,(1,1,  0, -1, -1, false)
,(1,1,  0,  1, -1, false)
;
-- Marsaal
INSERT INTO ms_typyfigur_pohyb (id_sada, id_pravidla, id_typ, x, y, muze_utocit)
  SELECT id_sada, id_pravidla,  2, x, y, muze_utocit FROM ms_typyfigur_pohyb WHERE id_typ = 0;
-- Generaal
INSERT INTO ms_typyfigur_pohyb (id_sada, id_pravidla, id_typ, x, y, muze_utocit)
  SELECT id_sada, id_pravidla,  3, x, y, muze_utocit FROM ms_typyfigur_pohyb WHERE id_typ = 0;
-- Kapraal
INSERT INTO ms_typyfigur_pohyb (id_sada, id_pravidla, id_typ, x, y, muze_utocit)
  SELECT id_sada, id_pravidla,  4, x, y, muze_utocit FROM ms_typyfigur_pohyb WHERE id_typ = 0;
-- Kadet
INSERT INTO ms_typyfigur_pohyb (id_sada, id_pravidla, id_typ, x, y, muze_utocit)
  SELECT id_sada, id_pravidla,  5, x, y, muze_utocit FROM ms_typyfigur_pohyb WHERE id_typ = 0;
-- Kapitaan
INSERT INTO ms_typyfigur_pohyb (id_sada, id_pravidla, id_typ, x, y, muze_utocit)
  SELECT id_sada, id_pravidla,  6, x, y, muze_utocit FROM ms_typyfigur_pohyb WHERE id_typ = 0;
-- Pruzkumniik
INSERT INTO ms_typyfigur_pohyb (id_sada, id_pravidla, id_typ, x, y, muze_utocit)
  SELECT id_sada, id_pravidla,  7, x, y, muze_utocit FROM ms_typyfigur_pohyb WHERE id_typ = 0;
INSERT INTO ms_typyfigur_pohyb (id_sada, id_pravidla, id_typ, x, y, muze_utocit, flags) VALUES
  (1,1,  7,  0, -100, true, 'y_nek');
INSERT INTO ms_typyfigur_pohyb (id_sada, id_pravidla, id_typ, x, y, muze_utocit, flags) VALUES
  (1,1,  7,  0,  100, true, 'y_nek');
INSERT INTO ms_typyfigur_pohyb (id_sada, id_pravidla, id_typ, x, y, muze_utocit, flags) VALUES
  (1,1,  7,  0, -100, true, 'x_nek');
INSERT INTO ms_typyfigur_pohyb (id_sada, id_pravidla, id_typ, x, y, muze_utocit, flags) VALUES
  (1,1,  7,  0,  100, true, 'x_nek');
-- Vojaak
INSERT INTO ms_typyfigur_pohyb (id_sada, id_pravidla, id_typ, x, y, muze_utocit)
  SELECT id_sada, id_pravidla,  8, x, y, muze_utocit FROM ms_typyfigur_pohyb WHERE id_typ = 0;
-- Mineer
INSERT INTO ms_typyfigur_pohyb (id_sada, id_pravidla, id_typ, x, y, muze_utocit)
  SELECT id_sada, id_pravidla,  9, x, y, muze_utocit FROM ms_typyfigur_pohyb WHERE id_typ = 0;
-- Spioon
INSERT INTO ms_typyfigur_pohyb (id_sada, id_pravidla, id_typ, x, y, muze_utocit)
  SELECT id_sada, id_pravidla, 10, x, y, muze_utocit FROM ms_typyfigur_pohyb WHERE id_typ = 0;
/*
INSERT INTO ms_typyfigur_pohyb (id_sada, id_pravidla, id_typ, x, y, muze_utocit) VALUESs
 (1,1,  10,  0,  1, true)
,(1,1,  10,  0, -1, true)
,(1,1,  10,  1,  0, true)
,(1,1,  10, -1,  0, true)
,(1,1,  10,  1,  1, false)
,(1,1,  10, -1,  1, false)
,(1,1,  10, -1, -1, false)
,(1,1,  10,  1, -1, false)*/
;

/* CREATE TABLE marsal.ms_initcounts (
     id INT UNSIGNED NOT NULL AUTO_INCREMENT,
     nazev VARCHAR(45)  NOT NULL,
    PRIMARY KEY (id)
)*/
INSERT INTO marsal.ms_initcounts (id, nazev) VALUES
 (1, "Výchozí")
;

/* CREATE TABLE marsal.ms_initcounts_data (
			id_initcount INT UNSIGNED NOT NULL,
			typ_figurky TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
			pocet VARCHAR(45)  NULL,			
			PRIMARY KEY (id_initcount, typ_figurky)
) */
INSERT INTO marsal.ms_initcounts_data (id_initcount, typ_figurky, pocet) VALUES
 (1,  1, 8)  -- Minov pole 8
,(1,  2, 1)  -- Marl      1
,(1,  3, 1)  -- Generl     1
,(1,  4, 2)  -- Kapitn     2
,(1,  5, 3)  -- Kadet       3
,(1,  6, 4)  -- Kaprl      4
,(1,  7, 5)  -- Stelec     5
,(1,  8, 8)  -- Przkumnk  8
,(1,  9, 6)  -- Minr       6
,(1, 10, 1)  -- pin       1
,(1, 11, 1)  -- Prapor      1
;

INSERT INTO ms_hraci SET nick = "Ondra", pass = MD5("heslo");
INSERT INTO ms_hraci SET nick = "Ilona", pass = MD5("heslo");

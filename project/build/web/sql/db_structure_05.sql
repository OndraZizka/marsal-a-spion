-- ----------------------------------------------------------------------
-- MySQL GRT Application
-- SQL Script
-- ----------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS marsal
  CHARACTER SET latin1;
-- -------------------------------------
-- Tables

DROP TABLE IF EXISTS marsal.ms_bitvy;
CREATE TABLE marsal.ms_bitvy (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  hrac1 INT UNSIGNED NULL,
  hrac2 INT UNSIGNED NULL,
  kolo INT UNSIGNED NOT NULL,
  zacatek DATETIME NOT NULL,
  posledni_kolo DATETIME NOT NULL,
  na_tahu_hrac2 BOOLEAN NOT NULL,
  nazev CHAR(45) NOT NULL,
  sada TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  INDEX index_hrac1 (hrac1),
  INDEX index_hrac2 (hrac2),
  CONSTRAINT fk_ms_bitvy_1 FOREIGN KEY fk_ms_bitvy_1 (hrac1)
    REFERENCES marsal.ms_hraci (id),
  CONSTRAINT fk_ms_bitvy_2 FOREIGN KEY fk_ms_bitvy_2 (hrac2)
    REFERENCES marsal.ms_hraci (id)
)
ENGINE = MyISAM
CHARACTER SET cp1250 COLLATE cp1250_general_ci;

DROP TABLE IF EXISTS marsal.ms_bitvy_stav;
CREATE TABLE marsal.ms_bitvy_stav (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  figurka TINYINT UNSIGNED NOT NULL,
  policko TINYINT UNSIGNED NOT NULL,
  id_bitva INT UNSIGNED NOT NULL,
	id_hrac INT UNSIGNED NOT NULL,
  PRIMARY KEY (id, figurka),
  UNIQUE INDEX policko_bitvy (id_bitva, policko),
  CONSTRAINT fk_ms_bitvy_stav_1 FOREIGN KEY fk_ms_bitvy_stav_1 (id_bitva)
    REFERENCES marsal.ms_bitvy (id)
)
ENGINE = MyISAM
CHARACTER SET cp1250 COLLATE cp1250_general_ci;

DROP TABLE IF EXISTS marsal.ms_hraci;
CREATE TABLE marsal.ms_hraci (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nick VARCHAR(45) NOT NULL,
  pass VARCHAR(45) BINARY NOT NULL,
  posledni_tah DATETIME NULL,
  PRIMARY KEY (id),
  INDEX index_2 (nick)
)
ENGINE = MyISAM
CHARACTER SET cp1250 COLLATE cp1250_general_ci;

DROP TABLE IF EXISTS marsal.ms_tables_templates;
CREATE TABLE marsal.ms_tables_templates (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (id)
)
ENGINE = InnoDB
CHARACTER SET cp1250 COLLATE cp1250_general_ci;

DROP TABLE IF EXISTS marsal.ms_initcounts;
CREATE TABLE marsal.ms_initcounts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nazev VARCHAR(45) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = MyISAM
CHARACTER SET cp1250 COLLATE cp1250_general_ci;

DROP TABLE IF EXISTS marsal.ms_initcounts_data;
CREATE TABLE marsal.ms_initcounts_data (
  typ_figurky TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  pocet VARCHAR(45) NULL,
  id_initcount INT UNSIGNED NOT NULL,
  PRIMARY KEY (typ_figurky, id_initcount),
  CONSTRAINT fk_ms_initcounts_data_1 FOREIGN KEY fk_ms_initcounts_data_1 (id_initcount)
    REFERENCES marsal.ms_initcounts (id)NO ACTION,
  CONSTRAINT fk_ms_initcounts_data_2 FOREIGN KEY fk_ms_initcounts_data_2 (typ_figurky)
    REFERENCES marsal.ms_typyfigur (id)
)
ENGINE = MyISAM
CHARACTER SET cp1250 COLLATE cp1250_general_ci;

DROP TABLE IF EXISTS marsal.ms_typyfigur;
CREATE TABLE marsal.ms_typyfigur (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nazev VARCHAR(45) NOT NULL,
  obrazek VARCHAR(45) NOT NULL,
  sada TINYINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (id)
)
ENGINE = MyISAM
CHARACTER SET cp1250 COLLATE cp1250_general_ci;

DROP TABLE IF EXISTS marsal.ms_typyfigur_vyhrava;
CREATE TABLE marsal.ms_typyfigur_vyhrava (
  vyhrava TINYINT UNSIGNED NOT NULL,
  prohrava TINYINT UNSIGNED NOT NULL,
  pravidla TINYINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (vyhrava, prohrava),
  CONSTRAINT fk_ms_typyfigur_vyhrava_1 FOREIGN KEY fk_ms_typyfigur_vyhrava_1 (vyhrava)
    REFERENCES marsal.ms_typyfigur (id),
  CONSTRAINT fk_ms_typyfigur_vyhrava_2 FOREIGN KEY fk_ms_typyfigur_vyhrava_2 (prohrava)
    REFERENCES marsal.ms_typyfigur (id)
)
ENGINE = MyISAM
CHARACTER SET cp1250 COLLATE cp1250_general_ci;



SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------------------------------------------------
-- EOF


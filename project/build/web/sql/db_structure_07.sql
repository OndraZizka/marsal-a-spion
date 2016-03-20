-- ----------------------------------------------------------------------
-- MySQL GRT Application
-- SQL Script
-- ----------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS marsal
  CHARACTER SET cp1250;
-- -------------------------------------
-- Tables

DROP TABLE IF EXISTS marsal.ms_bitvy;
CREATE TABLE marsal.ms_bitvy (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  hrac1 INT UNSIGNED NULL,
  hrac2 INT UNSIGNED NULL,
  nazev CHAR(45) NOT NULL,
  id_sada TINYINT UNSIGNED NOT NULL DEFAULT 1,
  id_pravidla TINYINT UNSIGNED NOT NULL DEFAULT 1,
  kolo INT UNSIGNED NOT NULL DEFAULT 0,
  zacatek DATETIME NULL,
  posledni_kolo DATETIME NULL,
  na_tahu_hrac2 BOOLEAN NOT NULL,
  PRIMARY KEY (id),
  INDEX index_hrac1 (hrac1),
  INDEX index_hrac2 (hrac2),
  CONSTRAINT fk_ms_bitvy_1 FOREIGN KEY fk_ms_bitvy_1 (hrac1)
    REFERENCES marsal.ms_hraci (id)
,
  CONSTRAINT fk_ms_bitvy_2 FOREIGN KEY fk_ms_bitvy_2 (hrac2)
    REFERENCES marsal.ms_hraci (id)
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
  hrac INT UNSIGNED NULL,
  nazev VARCHAR(45) NOT NULL,
  sada TINYINT UNSIGNED NOT NULL DEFAULT 1,
  vytvoreno DATETIME NOT NULL,
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
    REFERENCES marsal.ms_initcounts (id)
,
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
  sada TINYINT UNSIGNED NOT NULL,
  pravidla TINYINT UNSIGNED NOT NULL DEFAULT 1,
  vyhrava TINYINT UNSIGNED NOT NULL DEFAULT 1,
  pravidla TINYINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (sada, (nil)),
  CONSTRAINT fk_ms_typyfigur_vyhrava_1 FOREIGN KEY fk_ms_typyfigur_vyhrava_1 (sada)
    REFERENCES marsal.ms_typyfigur (id)
,
  CONSTRAINT fk_ms_typyfigur_vyhrava_2 FOREIGN KEY fk_ms_typyfigur_vyhrava_2 ((nil))
    REFERENCES marsal.ms_typyfigur (id)
    ON DELETE
    ON UPDATE
)
ENGINE = MyISAM
CHARACTER SET cp1250 COLLATE cp1250_general_ci;

DROP TABLE IF EXISTS marsal.ms_bitvy_figurky;
CREATE TABLE marsal.ms_bitvy_figurky (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_bitva INT UNSIGNED NOT NULL,
  id_hrac INT UNSIGNED NOT NULL,
  id_typ TINYINT UNSIGNED NOT NULL,
  policko TINYINT UNSIGNED NULL,
  PRIMARY KEY (id),
  INDEX ix_bitva (id_bitva),
  INDEX ix_hrac (id_hrac),
  INDEX policko (policko)
)
ENGINE = InnoDB
CHARACTER SET cp1250 COLLATE cp1250_general_ci;

DROP TABLE IF EXISTS marsal.ms_typyfigur_pohyb;
CREATE TABLE marsal.ms_typyfigur_pohyb (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_sada INT UNSIGNED NOT NULL,
  id_pravidla INT UNSIGNED NOT NULL,
  id_typ INT UNSIGNED NOT NULL,
  x TINYINT NULL,
  y TINYINT NULL,
  muze_utocit BOOLEAN NOT NULL,
	flags SET('x_nek', 'y_nek', 'utok', 'preskok'),
  PRIMARY KEY (id_sada, id_typ)
)
ENGINE = InnoDB
CHARACTER SET cp1250 COLLATE cp1250_general_ci;



SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------------------------------------------------
-- EOF

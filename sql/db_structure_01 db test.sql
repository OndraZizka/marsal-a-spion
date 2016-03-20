-- ----------------------------------------------------------------------
-- MySQL GRT Application
-- SQL Script
-- ----------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS `test`
  CHARACTER SET latin1;
-- -------------------------------------
-- Tables

DROP TABLE IF EXISTS `test`.`ms_bitvy`;
CREATE TABLE `test`.`ms_bitvy` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `hrac1` INT UNSIGNED NULL,
  `hrac2` INT UNSIGNED NULL,
  `kolo` INT UNSIGNED NOT NULL,
  `zacatek` DATETIME NOT NULL,
  `posledni_kolo` DATETIME NOT NULL,
  `na_tahu_hrac2` BOOLEAN NOT NULL,
  `nazev` CHAR(45) CHARACTER SET  COLLATE  NOT NULL,
  PRIMARY KEY (`id`, `hrac1`, `hrac2`),
  INDEX `index_hrac1` (`hrac1`),
  INDEX `index_hrac2` (`hrac2`)
)
ENGINE = MyISAM
CHARACTER SET cp1250 COLLATE general_ci;

DROP TABLE IF EXISTS `test`.`ms_bitvy_stav`;
CREATE TABLE `test`.`ms_bitvy_stav` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `figurka` TINYINT UNSIGNED NOT NULL,
  `policko` TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `figurka`)
)
ENGINE = MyISAM
CHARACTER SET cp1250 COLLATE general_ci;

DROP TABLE IF EXISTS `test`.`ms_hraci`;
CREATE TABLE `test`.`ms_hraci` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nick` VARCHAR(45) CHARACTER SET  COLLATE  NOT NULL,
  `pass` VARCHAR(45) CHARACTER SET  COLLATE  BINARY NOT NULL,
  `posledni_tah` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `index_2` (`nick`)
)
ENGINE = MyISAM
CHARACTER SET cp1250 COLLATE general_ci;

DROP TABLE IF EXISTS `test`.`ms_tables_templates`;
CREATE TABLE `test`.`ms_tables_templates` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
CHARACTER SET cp1250 COLLATE general_ci;

DROP TABLE IF EXISTS `test`.`ms_initcounts`;
CREATE TABLE `test`.`ms_initcounts` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nazev` VARCHAR(45) CHARACTER SET  COLLATE  NOT NULL,
  PRIMARY KEY (`id`)
)
ENGINE = MyISAM
CHARACTER SET cp1250 COLLATE general_ci;

DROP TABLE IF EXISTS `test`.`ms_initcounts_data`;
CREATE TABLE `test`.`ms_initcounts_data` (
  `typ_figurky` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pocet` VARCHAR(45) CHARACTER SET  COLLATE  NULL,
  `id_initcount` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`typ_figurky`, `id_initcount`)
)
ENGINE = MyISAM
CHARACTER SET cp1250 COLLATE general_ci;

DROP TABLE IF EXISTS `test`.`ms_typyfigur`;
CREATE TABLE `test`.`ms_typyfigur` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nazev` VARCHAR(45) CHARACTER SET  COLLATE  NOT NULL,
  `obrazek` VARCHAR(45) CHARACTER SET  COLLATE  NOT NULL,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
CHARACTER SET cp1250 COLLATE general_ci;

DROP TABLE IF EXISTS `test`.`ms_typyfigur_vyhrava`;
CREATE TABLE `test`.`ms_typyfigur_vyhrava` (
  `vyhrava` TINYINT UNSIGNED NOT NULL,
  `prohrava` TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (`vyhrava`, `prohrava`)
)
ENGINE = InnoDB
CHARACTER SET cp1250 COLLATE general_ci;



SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------------------------------------------------
-- EOF


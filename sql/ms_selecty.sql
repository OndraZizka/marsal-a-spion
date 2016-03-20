SELECT * FROM ms_bitvy m;
SELECT * FROM ms_bitvy_stav m;
SELECT * FROM ms_hraci m;
SELECT * FROM ms_initcounts m;
SELECT * FROM ms_initcounts_data m;
SELECT * FROM ms_tables_templates m;
SELECT * FROM ms_typyfigur m;
SELECT * FROM ms_typyfigur_vyhrava m;

CREATE TABLE marsal.ms_hraci (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nick VARCHAR(45) NOT NULL,
  pass VARCHAR(45) BINARY NOT NULL,
  posledni_tah DATETIME NULL,
  PRIMARY KEY (id),
  INDEX index_2 (nick)
);
INSERT INTO ms_hraci
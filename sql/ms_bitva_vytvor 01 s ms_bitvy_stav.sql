DELIMITER $$

/* CREATE TABLE marsal.ms_bitvy (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    hrac1 INT UNSIGNED NULL,
    hrac2 INT UNSIGNED NULL,
    kolo INT UNSIGNED NOT NULL,
    zacatek DATETIME NOT NULL,
    posledni_kolo DATETIME NOT NULL,
    na_tahu_hrac2 BOOLEAN NOT NULL,
    nazev CHAR(45)  NOT NULL,
    PRIMARY KEY (id),
    INDEX index_hrac1 (hrac1),
    INDEX index_hrac2 (hrac2)
)

CREATE TABLE marsal.ms_bitvy_stav (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  figurka TINYINT UNSIGNED NOT NULL,
  policko TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (id, figurka)
) */

-- Vytvoreni bitvy
DROP PROCEDURE IF EXISTS marsal.ms_bitva_vytvor $$
CREATE PROCEDURE marsal.ms_bitva_vytvor (
    _nazev CHAR(45), _hrac1 INT UNSIGNED, _hrac2 INT UNSIGNED, _na_tahu_hrac2 BOOLEAN, _id_initcount INT UNSIGNED
)BEGIN
  DECLARE iPolicko, iTyp, iPocet, iLastId INT UNSIGNED DEFAULT 0;
  DECLARE bDone BOOLEAN DEFAULT false;
  DECLARE curFigurky CURSOR FOR
    SELECT typ_figurky, pocet FROM marsal.ms_initcounts_data WHERE id_initcount = _id_initcount;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = true;

  INSERT INTO ms_bitvy SET id = NULL, nazev = _nazev, hrac1 = _hrac1, hrac2 = _hrac2, na_tahu_hrac2 = _na_tahu_hrac2;
  SELECT LAST_INSERT_ID() INTO iLastId;

  OPEN curFigurky;
  loopFigurkyTypy: LOOP
    FETCH curFigurky INTO iTyp, iPocet;
    IF bDone THEN LEAVE loopFigurkyTypy; SET bDone = false; END IF;
    WHILE iPocet > 0 DO
      INSERT INTO ms_bitvy_stav (id_bitva, id_hrac, figurka, policko) VALUES (iLastId, _hrac1, iTyp, iPolicko);
      SET iPocet = iPocet - 1;
      SET iPolicko = iPolicko + 1;
    END WHILE;
  END LOOP loopFigurkyTypy;
  CLOSE curFigurky;

  IF _hrac2 IS NOT NULL THEN
  SET iPolicko = 99;
  OPEN curFigurky;
  loopFigurkyTypy: LOOP
    FETCH curFigurky INTO iTyp, iPocet;
    IF bDone THEN LEAVE loopFigurkyTypy; END IF;
    WHILE iPocet > 0 DO
      INSERT INTO ms_bitvy_stav (id_bitva, id_hrac, figurka, policko) VALUES (iLastId, _hrac2, iTyp, iPolicko);
      SET iPocet = iPocet - 1;
      SET iPolicko = iPolicko - 1;
    END WHILE;
  END LOOP loopFigurkyTypy;
  CLOSE curFigurky;
  END IF;

END $$


-- Mazani bitvy
DROP PROCEDURE IF EXISTS marsal.ms_bitva_smaz $$
CREATE PROCEDURE marsal.ms_bitva_smaz (_id INT UNSIGNED) BEGIN
  DELETE FROM marsal.ms_bitvy WHERE id = _id;
  -- Vyvola trigger ms_bitvy_ondelete
END $$

DROP TRIGGER marsal.ms_bitvy_ondelete $$
CREATE TRIGGER marsal.ms_bitvy_ondelete AFTER DELETE ON marsal.ms_bitvy FOR EACH ROW BEGIN
  DELETE FROM marsal.ms_bitvy_stav WHERE id_bitva = OLD.id;
END $$


DELIMITER ;



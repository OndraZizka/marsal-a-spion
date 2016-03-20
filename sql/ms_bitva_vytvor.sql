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
    _nazev CHAR(45), _hrac1 INT UNSIGNED, _hrac2 INT UNSIGNED,
    _sada TINYINT UNSIGNED, _pravidla  TINYINT UNSIGNED,
    _na_tahu_hrac2 BOOLEAN, _id_initcount INT UNSIGNED
)BEGIN
  DECLARE iPolicko, iTyp, iPocet, iLastIdBitva INT UNSIGNED DEFAULT 0;
  DECLARE bDone BOOLEAN DEFAULT false;
  DECLARE curFigurky CURSOR FOR
    SELECT typ_figurky, pocet FROM marsal.ms_initcounts_data WHERE id_initcount = _id_initcount;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = true;

  INSERT INTO ms_bitvy SET
    id = NULL, nazev = _nazev, hrac1 = _hrac1, hrac2 = _hrac2,
    id_sada = _sada, id_pravidla = _pravidla,
    na_tahu_hrac2 = _na_tahu_hrac2;
  SELECT LAST_INSERT_ID() INTO iLastIdBitva;

  OPEN curFigurky;
  loopFigurkyTypy: LOOP
    FETCH curFigurky INTO iTyp, iPocet;
    IF bDone THEN LEAVE loopFigurkyTypy; SET bDone = false; END IF;
    WHILE iPocet > 0 DO
      INSERT INTO ms_bitvy_figurky (id_bitva, id_hrac, id_typ, policko) VALUES (iLastIdBitva, _hrac1, iTyp, iPolicko);
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
      INSERT INTO ms_bitvy_stav (id_bitva, id_hrac, id_typ, policko) VALUES (iLastIdBitva, _hrac2, iTyp, iPolicko);
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
  DELETE FROM marsal.ms_bitvy_figurky WHERE id_bitva = OLD.id;
END $$



-- Vraci true, jestli muze figura udelat dany pohyb.
DROP FUNCTION ms_figura_muzepohyb$$
CREATE FUNCTION ms_figura_muzepohyb (
  _id_sada TINYINT UNSIGNED, _id_pravidla TINYINT UNSIGNED, _id_typ TINYINT UNSIGNED,
  _dx INT, _dy INT, _utok BOOL, _preskok BOOL)
RETURNS BOOLEAN
BEGIN
  DECLARE iNum INT;
  DECLARE curPohyby CURSOR FOR
    SELECT COUNT(*) FROM marsal.ms_typyfigur_pohyb
      WHERE id_sada = _id_sada AND id_pravidla = id_pravidla AND id_typ = _id_typ
        -- AND flags = CONCAT_WS(',', IF(_utok, "utok", NULL), IF(_preskok, "preskok", NULL) )
        AND muze_utocit = _utok AND flags = CONCAT_WS(',', IF(_preskok, "preskok", NULL) )
        AND (x = _dx OR FIND_IN_SET('x_nek', flags))
        AND (y = _dy OR FIND_IN_SET('y_nek', flags)) ;

  OPEN curPohyby;
  FETCH curPohyby INTO iNum;
  CLOSE curPohyby;
  RETURN iNum > 0;
END $$



-- Prepocitava 1D souradnice na 2D.
DROP PROCEDURE ms_prepocti_1d2d $$
CREATE PROCEDURE ms_prepocti_1d2d (
    IN _id_pravidla INT UNSIGNED, IN _policko INT,
    OUT _x TINYINT UNSIGNED, OUT _y TINYINT UNSIGNED
) BEGIN
  DECLARE iCols INT UNSIGNED;
  SELECT poli_x INTO iCols FROM ms_pravidla WHERE id = _id_pravidla;
  SET _x = _policko % iCols;
  SET _y = _policko DIV iCols;
  SELECT _x, _y;
END $$
-- Prepocitava 2D souradnice na 1D.
DROP PROCEDURE ms_prepocti_2d1d $$
CREATE PROCEDURE ms_prepocti_2d1d (
    IN _id_pravidla INT UNSIGNED, IN _x TINYINT UNSIGNED, IN _y TINYINT UNSIGNED, OUT _policko INT
) BEGIN
  DECLARE iCols INT UNSIGNED;
  SELECT poli_x INTO iCols FROM ms_pravidla WHERE id = _id_pravidla;
  SET _policko = _y * iCols + _x;
END $$

-- Test
-- CALL ms_prepocti_2d1d (1, 1, 1, @shit) $$
-- CALL ms_prepocti_1d2d (1, 11, @shit, @sh) $$





DROP FUNCTION ms_figura_muzepohyb$$
CREATE FUNCTION ms_figura_muzepohyb (
  _id_sada TINYINT UNSIGNED, _id_pravidla TINYINT UNSIGNED, _id_typ TINYINT UNSIGNED,
  _dx INT, _dy INT, _utok BOOL, _preskok BOOL)
RETURNS BOOLEAN
BEGIN
  DECLARE iNum INT;

  SELECT COUNT(*) INTO iNum FROM marsal.ms_typyfigur_pohyb
      WHERE id_sada = _id_sada AND id_pravidla = id_pravidla AND id_typ = _id_typ
        -- AND flags = CONCAT_WS(',', IF(_utok, "utok", NULL), IF(_preskok, "preskok", NULL) )
        AND muze_utocit = _utok AND flags = CONCAT_WS(',', IF(_preskok, "preskok", NULL) )
        AND (x = _dx OR FIND_IN_SET('x_nek', flags))
        AND (y = _dy OR FIND_IN_SET('y_nek', flags)) ;
  RETURN iNum > 0;
END $$




DROP PROCEDURE ms_figura_tahni $$
CREATE PROCEDURE ms_figura_tahni (_id_figurka BIGINT UNSIGNED, _dx INT, _dy INT) BEGIN
  DECLARE bUtok, bPreskok, bPossible BOOLEAN;
  DECLARE iIdBitva, iFigurek INT UNSIGNED;

  CREATE TEMPORARY TABLE IF NOT EXISTS tFigurkyTatoHra LIKE ms_bitvy_figurky;
  TRUNCATE tFigurkyTatoHra;
  INSERT INTO tFigurkyTatoHra
    SELECT * FROM ms_bitvy_figurky
       WHERE id_bitva = (SELECT id_bitva FROM ms_bitvy_figurky WHERE id = _id_figurka);

  -- Zjistime, jestli se jedna o utok
  -- SELECT id_bitva INTO iIdBitva FROM ms_bitvy_figurky WHERE id = _id_figurka;
  SELECT COUNT(*) INTO iFigurek FROM
      tFigurkyTatoHra AS bf1,
      tFigurkyTatoHra AS bf2
    WHERE /*bf1.id = _id_figurka AND bf2.id_bitva = bf1.id_bitva
      AND*/ bf2.x = bf1.x + _dx
      AND   bf2.y = bf1.y + _dy
  ;
  SET bUtok = iFigurek > 0;


  -- Zjistime, jestli se jedna o preskok
  SELECT COUNT(*) INTO iFigurek FROM
      tFigurkyTatoHra AS bf1,
      tFigurkyTatoHra AS bf2
    WHERE /*bf1.id = _id_figurka AND bf1.id_bitva = bf2.id_bitva AND */
      CASE
      WHEN _dx = 0 AND _dy = 0 THEN 0
      WHEN _dx = 0 AND _dy != 0 THEN
        bf2.x = bf1.x -- sloupec je stejny
        AND bf2.y > LEAST(bf1.y, bf1.y + _dy) -- hledane figurky jsou pod horni pozici
        AND bf2.y < GREATEST(bf1.y, bf1.y + _dy) -- hledane figurky jsou nad dolni pozici
      WHEN _dx != 0 AND _dy = 0 THEN
        bf2.y = bf1.y -- radka je stejna
        AND bf2.x > LEAST(bf1.x, bf1.x + _dx) -- hledane figurky jsou za levou pozici
        AND bf2.x < GREATEST(bf1.x, bf1.x + _dx) -- hledane figurky jsou pred pravou pozici
      WHEN _dx = _dy AND _dx != 0 AND _dy != 0 THEN
        ABS(bf2.y - bf1.y) = ABS(bf2.x - bf1.x)
      ELSE 0
      END
  ;
  SET bPreskok = iFigurek > 0;

  -- Zjistime, jestli je takovy tah mozny
  SET bPossible = ms_figurka_muzepohyb(1,1, (SELECT id_typ FROM ms_typyfigur WHERE id = _id), _dx, _dy, bUtok, bPreskok);


  DROP TEMPORARY TABLE tFigurkyTatoHra;
END $$




DELIMITER ;



DELIMITER $$

DROP FUNCTION IF EXISTS `marsal`.`sm_test` $$
CREATE FUNCTION `marsal`.`sm_test` () RETURNS INT
BEGIN
  DECLARE x INT DEFAULT 0;

  -- Haze syntax error u 1. SELECTu
  /*CASE
    WHEN SELECT 1 THEN x = x + 1;
    WHEN SELECT 0 THEN x = x + 1;
    WHEN SELECT 1 THEN x = x + 1;
    ELSE x = x + 1;
  END CASE;*/


END $$



-- Prekryti nazvu sloupcu parametry rutiny

DROP PROCEDURE xxx $$
CREATE PROCEDURE xxx (_id_bitva INT) BEGIN
  SELECT COUNT(*), id_bitva FROM ms_bitvy_figurky AS t WHERE t.id_bitva = _id_bitva
  ;
END $$

SELECT * FROM ms_bitvy_figurky$$
CALL xxx(1222) $$




DELIMITER ;
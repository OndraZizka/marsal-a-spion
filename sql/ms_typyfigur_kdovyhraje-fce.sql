DELIMITER $$

DROP FUNCTION IF EXISTS marsal.ms_typyfigur_kdovyhraje $$
CREATE FUNCTION marsal.ms_typyfigur_kdovyhraje ( _sada, _pravidla, figura1 TINYINT, figura2 TINYINT )
    RETURNS TINYINT DETERMINISTIC READS SQL DATA
BEGIN
DECLARE vyhraje_vetsi BOOLEAN;
-- Plichta
IF figura1 = figura2 THEN RETURN 0; END IF;

  SELECT COUNT(*) > 0 INTO vyhraje_vetsi FROM marsal.ms_typyfigur_vyhrava AS t
    WHERE t.vyhrava > t.prohrava   -- Bereme v uvahu jen ty, ktere jsou vyjimkou obecneho pravidla vyhry
      AND t.sada     = _sada
      AND t.pravidla = _pravidla
      AND ( t.vyhrava = figura1 AND t.prohrava = figura2
         OR t.vyhrava = figura2 AND t.prohrava = figura1 );
  RETURN IF(vyhraje_vetsi, IF(figura2 > figura1, 2, 1),  IF(figura2 > figura1, 1, 2) );
END $$



DROP PROCEDURE IF EXISTS marsal.ms_typyfigur_kdovyhraje_test $$
CREATE PROCEDURE marsal.ms_typyfigur_kdovyhraje_test()
    -- RETURNS TINYINT
    DETERMINISTIC
BEGIN
  DECLARE f1, f2, er INT UNSIGNED;
  DECLARE done       BOOLEAN DEFAULT FALSE;
  DECLARE cur_tests CURSOR FOR SELECT figure1, figure2, expected_result FROM tmp_tests AS t;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

  DROP TEMPORARY TABLE IF EXISTS tmp_tests;
  CREATE TEMPORARY TABLE tmp_tests (
    figure1 INT UNSIGNED NOT NULL,
    figure2 INT UNSIGNED NOT NULL,
    expected_result INT UNSIGNED NOT NULL,
    real_result     INT UNSIGNED DEFAULT NULL
  );
  INSERT INTO tmp_tests (figure1, figure2, expected_result) VALUES
     (9,9,0),
     (9,1,1),
     (8,1,2),
     (1,9,2),
     (1,8,1);
  OPEN cur_tests;
  loop1: LOOP
    FETCH cur_tests INTO f1, f2, er;
    IF done THEN LEAVE loop1; END IF;
    UPDATE tmp_tests SET real_result = (ms_typyfigur_kdovyhraje(1,1, f1,f2) = 0);
  END LOOP loop1;
  CLOSE cur_tests;

  SELECT * FROM tmp_tests;

END $$


DELIMITER ;
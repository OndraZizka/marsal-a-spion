CREATE TABLE t1 (val INT);
CREATE TABLE t2 (val INT);

DROP TRIGGER trig1;
CREATE TRIGGER trig1 AFTER INSERT ON t1
FOR EACH ROW
  INSERT INTO t2 SET val = NEW.val * 2;

DROP TRIGGER trig2;
CREATE TRIGGER trig2 AFTER INSERT ON t2
FOR EACH ROW
  INSERT INTO t1 SET id = NULL;

-- Zkontrolujeme...
SELECT COUNT(*) FROM t1;
SELECT * FROM (SELECT COUNT(*) FROM t1) AS t1x, (SELECT COUNT(*) FROM t2) AS t2x;

-- Pokud jsme aktivovali oba triggery
INSERT INTO t1 VALUES ( RAND() );

######  Vysledek:
#  Pri zacykleni triggeru MySQL cyklus odhali.
# Neni spusten trigger tabulky, ktera jiz jeden trigger spustila.
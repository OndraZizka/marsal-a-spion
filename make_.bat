@rem * Preklad trid pro Marsal a spion 
@echo ###################################
@echo #    Preklad - Marsal a spion     #
@echo ###################################
@echo.


@if exist tmp goto tmp_exists
@rem cd ./WEB-INF
@mkdir tmp
@rem cd ..
@set tmp_exists=1
:tmp_exists
                                      
javac ./src/*.java -d ./tmp -encoding windows-1250
jar cf ./WEB-INF/classes/marsal_a_spion.jar -C ./tmp .

@if "%tmp_exists%" == "1" rmdir tmp /s /q 
@rem pause

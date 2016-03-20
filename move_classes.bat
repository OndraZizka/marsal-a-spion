@rem * Preklad trid pro Marsal a spion 
@echo ###################################
@echo #    Presun - Marsal a spion     #
@echo ###################################
@echo.


@rem jar cf ./real/WEB-INF/classes/marsal_a_spion.jar -C ./build .
xcopy .\build\classes .\real\WEB-INF\classes /E /Y /I
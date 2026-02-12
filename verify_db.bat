@echo off
echo Verificando base de datos ferreteria_db...
echo.
"D:\Archivos de programas\XAMPPg\mysql\bin\mysql.exe" -u root -e "USE ferreteria_db; SHOW TABLES;"
echo.
echo ===================================
echo Verificacion completada
echo ===================================

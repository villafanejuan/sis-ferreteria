@echo off
echo Importando base de datos ferreteria_db...
"D:\Archivos de programas\XAMPPg\mysql\bin\mysql.exe" -u root < "d:\Archivos de programas\XAMPPg\htdocs\sis-ferreteria\ferreteria_db.sql"
if %errorlevel% equ 0 (
    echo.
    echo ===================================
    echo Base de datos importada exitosamente!
    echo ===================================
) else (
    echo.
    echo ===================================
    echo Error al importar la base de datos
    echo ===================================
)
pause

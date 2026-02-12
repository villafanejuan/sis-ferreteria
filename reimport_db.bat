@echo off
echo ========================================
echo REIMPORTANDO BASE DE DATOS COMPLETA
echo ========================================
echo.
echo Paso 1: Eliminando base de datos anterior...
"D:\Archivos de programas\XAMPPg\mysql\bin\mysql.exe" -u root -e "DROP DATABASE IF EXISTS ferreteria_db;"
echo.
echo Paso 2: Creando base de datos nueva...
"D:\Archivos de programas\XAMPPg\mysql\bin\mysql.exe" -u root -e "CREATE DATABASE ferreteria_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
echo.
echo Paso 3: Importando estructura y datos...
"D:\Archivos de programas\XAMPPg\mysql\bin\mysql.exe" -u root ferreteria_db < "d:\Archivos de programas\XAMPPg\htdocs\sis-ferreteria\ferreteria_db.sql"
if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo IMPORTACION EXITOSA
    echo ========================================
    echo.
    echo Verificando tablas importadas...
    "D:\Archivos de programas\XAMPPg\mysql\bin\mysql.exe" -u root -e "USE ferreteria_db; SHOW TABLES;"
) else (
    echo.
    echo ========================================
    echo ERROR EN LA IMPORTACION
    echo ========================================
)
echo.
pause

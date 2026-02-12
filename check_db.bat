@echo off
chcp 65001 > nul
echo === VERIFICACIÓN DE BASE DE DATOS ===
echo.
"D:\Archivos de programas\XAMPPg\mysql\bin\mysql.exe" -u root -e "USE ferreteria_db; SELECT 'Base de datos ferreteria_db encontrada' AS Status; SELECT COUNT(*) AS 'Total de Tablas' FROM information_schema.tables WHERE table_schema = 'ferreteria_db'; SELECT table_name AS 'Tablas' FROM information_schema.tables WHERE table_schema = 'ferreteria_db' ORDER BY table_name;"
echo.
echo === VERIFICACIÓN COMPLETADA ===

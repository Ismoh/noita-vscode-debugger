@echo off
setlocal
set "LUAROCKS_SYSCONFDIR=C:\Program Files (x86)/luarocks"
"M:\_porgramming\noita-vscode-debugger\.build\luarocks-3.9.2-windows-32\luarocks.exe" --project-tree M:\_porgramming\noita-vscode-debugger\mods\noita-vscode-debugger/lua_modules %*
exit /b %ERRORLEVEL%

@echo off
@call env.cmd
%RZR_BINDIR%\RazorRequest.exe /config %RZR_BINDIR%\clarite_config.xml /session /space %RZR_SPACE% /env %RZR_ENV% %2 %3 /stdin


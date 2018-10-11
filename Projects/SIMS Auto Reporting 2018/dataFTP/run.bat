SET /P dfe=<"%CD%\dfenumber.nfo"

FOR %%f IN (*.txt) DO (
  CMD /c process.bat "%%~nf" %dfe%
)
CMD /c runftp.bat %dfe%
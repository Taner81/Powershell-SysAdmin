setlocal ENABLEDELAYEDEXPANSION

IF NOT EXIST "%cd%\runftp.ftp" (
  SET txt=OPEN 10.188.0.45  
  @echo !txt! > "%CD%\runftp.ftp"
  SET txt=data
  (@ECHO !txt!) >> "%CD%\runftp.ftp"
  SET txt=c@ctu507
  (@ECHO !txt!) >> "%CD%\runftp.ftp"
  SET txt=mput "%cd%\%1-*.csv"
  @ECHO !txt! >> "%CD%\runftp.ftp
  SET txt=quit
  @ECHO !txt! >> "%CD%\runftp.ftp"
)
FTP -v -i -s:runftp.ftp
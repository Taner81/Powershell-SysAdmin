IF EXIST %CD%\%2-%1.csv (
  DEL %CD%\%2-%1.csv
)

IF EXIST "%CD%\%1.txt" (
  REN %CD%\%1.txt %2-%1.csv
)
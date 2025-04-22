@echo off
setlocal EnableDelayedExpansion

set /p commitMessage=Enter commit message: 

cd /d C:\Users\piert\MakingMusic\SuperCollider
git add .
git commit -m "!commitMessage!"
git push

cd /d C:\Users\piert\MakingMusic\SuperCollider\SUDJ-execute
git add .
git commit -m "!commitMessage!"
git push

cd /d C:\ProgramData\SuperCollider\Extensions\SUDJ-classes
git add .
git commit -m "!commitMessage!"
git push

echo.
echo All done!
pause

endlocal
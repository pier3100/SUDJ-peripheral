@echo off
setlocal EnableDelayedExpansion

set /p commitMessage=Enter commit message: 

echo.
echo === Pushing to SUDJ-peripheral===
cd /d C:\Users\piert\MakingMusic\SuperCollider
git add .
git commit -am "!commitMessage!"
git push

echo.
echo === Pushing to SUDJ-execute ===
cd /d C:\Users\piert\MakingMusic\SuperCollider\SUDJ-execute
git add .
git commit -am "!commitMessage!"
git push

echo.
echo === Pushing to SUDJ-classes ===
cd /d C:\ProgramData\SuperCollider\Extensions\SUDJ-classes
git add .
git commit -am "!commitMessage!"
git push

echo.
echo All done!
pause

endlocal
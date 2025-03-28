@echo off
set /p commitMessage="Enter commit message: "

start cmd /k "cd /d C:\Users\piert\MakingMusic\SuperCollider && git add . && git commit -m \"%commitMessage%\" && git push"
start cmd /k "cd /d C:\Users\piert\MakingMusic\SuperCollider\SUDJ-execute && git add . && git commit -m \"%commitMessage%\" && git push"
start cmd /k "cd /d C:\ProgramData\SuperCollider\Extensions\SUDJ-classes && git add . && git commit -m \"%commitMessage%\" && git push"
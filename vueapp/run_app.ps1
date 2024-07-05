npm install
& "$($Env:Programfiles)\Google\Chrome\Application\chrome.exe" --user-data-dir="$($env:USERPROFILE)\Documents\my\data" --disable-web-security --new-window http://localhost:8080/
npm run serve 

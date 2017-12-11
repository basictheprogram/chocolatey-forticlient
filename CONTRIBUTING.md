Super rough draft, just putting the info here until I  have more time to clean 
it up.

Repository URLs

In the package manager settings, add the following URL to the list of Package Sources:
http://solidworks.int.celadonsystems.com/chocolatey

Use the command below to push packages to this feed using chocolatey (choco.exe).
choco push [{package file}] --source="http://solidworks.int.celadonsystems.com/" [--api-key={apikey}]

You can set the ApiKey for this repository with
choco setapikey --source="http://solidworks.int.celadonsystems.com/" --api-key={apikey}

https://github.com/chocolatey/choco/wiki/CommandsSources
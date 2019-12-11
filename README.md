# Suunto Ambit2 File Parser

Sunnto Ambit and Ambit2 watches don't use the GPX format. This CFML scripts converts Sunnto Ambit .json files into GPX files.

I have only tested this with Ambit2 files, but happy to test with other watch files.

## Retrieving the Files

Sunnto Moveslink software firsts places the files in your local directory before uploading it to Movescount. You can retrieve the files from:
```C:\Users\<user>\AppData\Roaming\Suunto\Moveslink2```\
If you are on a Mac or an earlier version of Windows, you'll have to poke around in the system to find the files.

## V0.1

Only Latitude and Longitude is being written to the GPX file at this point. The plan is to include all the other data like Temperature, Altitude, Speed, Power, etc.

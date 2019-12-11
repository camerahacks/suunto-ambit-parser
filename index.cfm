<cfscript>

setting requestTimeOut=300;

fileName = 'log-2019-11-10T09_55_04.json';

suuntoAPI = createObject("component", "CFC/parserEngine");

xmlAPI = createObject("component", "CFC/XMLEngine");

file = suuntoAPI.readAmbitFile(fileName);

ambitJson = suuntoAPI.ambitJsonParser(file);


/* NOT USED
arrayIndex = ArrayFind(ambitJson.Samples, function(struct){ 

	trkptLocalTime = '2019-11-10T09:55:44.513';
	return left(struct.LocalTime, 19) == left(trkptLocalTime, 19); 
});
*/

GPXFile = suuntoAPI.createGPX();

GPXFile = suuntoAPI.addTrkpt(GPXFile, ambitJson);

newFilename = listFirst(fileName, ".");

fileWrite(expandPath("./"&newFilename&".gpx"), xmlAPI.indentXML(GPXFile, '  '));

</cfscript>
<cfscript>

setting requestTimeOut=300;

fileName = 'log-2019-11-10T09_55_04.json';

suuntoAPI = createObject("component", "CFC/parserEngine");

xmlAPI = createObject("component", "CFC/XMLEngine");

//sampleXML = suuntoAPI.readAmbitFile('Move_2019_11_10_09_55_04_Mountain+biking.gpx');

//sampleXML = xmlParse(sampleXML);

//dump(arrayLen(sampleXML['gpx']['trk']['trkseg'].XmlChildren));

file = suuntoAPI.readAmbitFile(fileName);

ambitJson = suuntoAPI.ambitJsonParser(file);

//dump(ambitJson.TrackPoints[1636]);

arrayIndex = ArrayFind(ambitJson.Samples, function(struct){ 

	trkptLocalTime = '2019-11-10T09:55:44.513';
	return left(struct.LocalTime, 19) == left(trkptLocalTime, 19); 
});

//writeOutput(arrayIndex);


GPXFile = suuntoAPI.createGPX();

GPXFile = suuntoAPI.addTrkpt(GPXFile, ambitJson);

newFilename = listFirst(fileName, ".");

fileWrite(expandPath("./"&newFilename&".gpx"), xmlAPI.indentXML(GPXFile, '  '));

</cfscript>
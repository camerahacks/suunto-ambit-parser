component output="false" displayname="Parse Suunto Ambit File"  {


	public function readAmbitFile(required fileName){

		ambitFile = fileRead(expandPath("./"&Arguments.fileName));

		return ambitFile;

	}


	public function ambitJsonParser(required jsonfile){

		//Suunto creates a json file that is not valid json. Have to replace some values to make it valid
		//Weird how they used to do this with their XML files. Now the XML (SML) is valid but Json is not.

		samples = '}"Samples:"';

		replaceSamples = ',"Samples":';

		trackpoints = '"TrackPoints:"';

		replaceTrackpoints = ',"TrackPoints":';

		makeitJson = replace(arguments.jsonfile, samples, replaceSamples);

		makeitJson = replace(makeitJson, trackpoints, replaceTrackpoints);

		//Add '}' to the end of the file to make it valid

		ambitJson = insert('}', makeitJson, len(makeitJson)-1);

		return deserializeJSON(ambitJson);

	}

	public function createGPX(required filename){

		//This will create a blank GPX XML Object with not trackpoints

		GPXFile = xmlNew('True');

		//Add gpx root element under the correct URI
		XmlRoot = xmlElemNew(GPXFile, 'http://www.topografix.com/GPX/1/1', 'gpx');

		GPXFile.XmlRoot = XmlRoot;

		//Add creator attribute
		structInsert(GPXFile.XmlRoot.XmlAttributes, 'creator', 'DPHacks - DPHacks.com');

		//Add version attribute
		structInsert(GPXFile.XmlRoot.XmlAttributes, 'version', '1.1');

		//Add xmlns
		structInsert(GPXFile.XmlRoot.XmlAttributes, 'xmlns', 'http://www.topografix.com/GPX/1/1');

		//Add xmlns:gpxdata

		structInsert(GPXFile.XmlRoot.XmlAttributes, 'xmlns:gpxdata', 'http://www.cluetrust.com/XML/GPXDATA/1/0');		

		//Add xmlns:gpxtpx

		structInsert(GPXFile.XmlRoot.XmlAttributes, 'xmlns:gpxtpx', 'http://www.garmin.com/xmlschemas/TrackPointExtension/v1');

		//Add xmlns:xsi

		structInsert(GPXFile.XmlRoot.XmlAttributes, 'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');

		//Add xsi:schemaLocation

		structInsert(GPXFile.XmlRoot.XmlAttributes, 'xsi:schemaLocation', 'http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.cluetrust.com/XML/GPXDATA/1/0 http://www.cluetrust.com/Schemas/gpxdata10.xsd http://www.garmin.com/xmlschemas/TrackPointExtension/v1 http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd');

		//Add the track element
		xmlTrack = xmlElemNew(GPXFile, 'http://www.topografix.com/GPX/1/1' , 'trk');

		arrayAppend(GPXFile.XmlRoot.XmlChildren, xmlTrack);

		//Add a name to the GPX track
		xmlName = xmlElemNew(GPXFile, 'http://www.topografix.com/GPX/1/1' , 'name');

		arrayAppend(GPXFile['gpx']['trk'].XmlChildren, xmlName);

		GPXFile['gpx']['trk']['name'].XmlText = listFirst(arguments.fileName, ".");

		//Add the segment to the file	
		xmlSeg = xmlElemNew(GPXFile, 'http://www.topografix.com/GPX/1/1' , 'trkseg');

		arrayAppend(GPXFile['gpx']['trk'].XmlChildren, xmlSeg);


		return GPXFile;

	}

	public function addTrkpt(required GPXFile, required ambitJson){

		//Add trackpoints to the segment - have to do a loop here to add as many points as needed

		trackpoints = arguments.ambitJson.TrackPoints;

		for(i=1; i <= arrayLen(trackpoints); i++){

			xmlPoint = xmlElemNew(arguments.GPXFile, 'http://www.topografix.com/GPX/1/1' , 'trkpt');

			arrayAppend(GPXFile['gpx']['trk']['trkseg'].XmlChildren, xmlPoint);

			trkpt['lat'] = trackpoints[i].Latitude;
			trkpt['lon'] = trackpoints[i].Longitude;
			trkpttime = trackpoints[i].LocalTime;

			GPXFile['gpx']['trk']['trkseg']['trkpt'][i].XmlAttributes = trkpt;

			GPXFile['gpx']['trk']['trkseg']['trkpt'][i].XmlChildren.append('time');

			GPXFile['gpx']['trk']['trkseg']['trkpt'][i]['time'].XmlText = trkpttime;

		}

		return GPXFile;
	}

	//For future implementation
	public function findSampleForTrkpt(required GPXFile, required ambitJson){

		//GPXFile['gpx']['trk']['trkseg']['trkpt'][i].XmlChildren.append('ele');

	}

	//Old XML stuff from here on down. Not in use anymore.
	//Delete this later
	public function getHeaderInfo(ambitFile){

		headerNode.XML = XmlSearch(arguments.ambitFile, "//*[local-name()='Header' and namespace-uri()='http://www.suunto.com/schemas/sml']");

		dump(headerNode);
		
		if (isXML(headerNode.XML[1])){
			parsedHeader = headerNode.XML[1];

			headerInfo = StructNew();
			
			headerInfo.duration =  parsedHeader.Duration.xmlText;
			headerInfo.ascent =  parsedHeader.Ascent.xmlText;
			headerInfo.descent =  parsedHeader.Descent.xmlText;
			headerInfo.ascentTime =  parsedHeader.AscentTime.xmlText;
			headerInfo.descenttTime =  parsedHeader.DescentTime.xmlText;
			headerInfo.recoveryTime =  parsedHeader.RecoveryTime.xmlText;
			headerInfo.speed.Avg =  parsedHeader.Speed.Avg.xmlText;
			headerInfo.speed.Max =  parsedHeader.Speed.Max.xmlText;
			headerInfo.speed.MaxTime =  parsedHeader.Speed.MaxTime.xmlText;
			headerInfo.speed.Cadence =  parsedHeader.Cadence.MaxTime.xmlText;
			headerInfo.altitude.Max =  parsedHeader.Altitude.max.xmlText;
			headerInfo.altitude.Min =  parsedHeader.Altitude.min.xmlText;
			headerInfo.altitude.MaxTime =  parsedHeader.Altitude.MaxTime.xmlText;
			headerInfo.altitude.MinTime =  parsedHeader.Altitude.MinTime.xmlText;
			headerInfo.activityType =  parsedHeader.activityType.xmlText;
			headerInfo.activity =  parsedHeader.activity.xmlText;
			headerInfo.temperature.Max =  parsedHeader.Temperature.Max.xmlText;
			headerInfo.temperature.Min =  parsedHeader.Temperature.Min.xmlText;
			headerInfo.temperature.MaxTime =  parsedHeader.Temperature.MaxTime.xmlText;
			headerInfo.temperature.MinTime =  parsedHeader.Temperature.MinTime.xmlText;
			headerInfo.distance =  parsedHeader.Distance.xmlText;
			headerInfo.logItemCount =  parsedHeader.LogItemCount.xmlText;
			//headerInfo.HR.Avg =  parsedHeader.HR.avg.xmlText;
			//headerInfo.HR.max =  parsedHeader.HR.max.xmlText;
			//headerInfo.HR.min =  parsedHeader.HR.min.xmlText;
			//headerInfo.peakTrainingEffect =  parsedHeader.peakTrainingEffect.xmlText;			
			//headerInfo.energy =  parsedHeader.energy.xmlText;
			//headerInfo.dateTime =  parsedHeader.dateTime.xmlText;
			
			return headerInfo;
		}

	}

	public function getSamplesData(ambitFile){

		samplesNode.XML = XmlSearch(arguments.ambitFile, "//*[local-name()='Sample' and namespace-uri()='http://www.suunto.com/schemas/sml']");

	}

	public function parseNodes(ambitFile){

		AmbitXMLFile = arguments.ambitFile;
		
		//Set the structure
		AmbitNodes = structnew();
		headerNode = structnew();
		samplesNode = structnew();
		LapsNode = structnew();
		IBINode = structnew();
		
		//Match the header tag and only deal with that chunck
		//headerNode.XML = rematch("<Header>(.*?)</Header>", AmbitXMLFile);
		headerNode.XML = XmlSearch(AmbitXMLFile, "//*[local-name()='Header' and namespace-uri()='http://www.suunto.com/schemas/sml']");
		//Match the samples tag and only deal with that chunck
		//samplesNode.XML = rematch("<Samples>(.*?)</Samples>", AmbitXMLFile);
		samplesNode.XML = XmlSearch(AmbitXMLFile, "//*[local-name()='Samples' and namespace-uri()='http://www.suunto.com/schemas/sml']");
		//Match the Laps tag and only deal with that chunck
		LapsNode.XML = rematch("<Laps>(.*?)</Laps>", AmbitXMLFile);
		//Match the IBI tag and only deal with that chunck
		IBINode.XML = rematch("<IBI>(.*?)</IBI>", AmbitXMLFile);

		//Test for existing chunks and Parse the XML
		
		//Header Node for Ambit XML
		if (ArrayLen(headerNode.XML) GT 0){
			headerNode.count = ArrayLen(headerNode.XML);
			//XMLParse
			headerNode.XML = XMLParse(headerNode.XML[1]);
		}
		else{
			headerNode.count = 0;
		}

		//Samples Node for Ambit XML 
		if (ArrayLen(samplesNode.XML) GT 0){
			samplesNode.count = ArrayLen(samplesNode.XML);
			//XMLParse
			samplesNode.XML = XMLParse(samplesNode.XML[1]);
		}else{
			samplesNode.count = 0;
		}

		//Laps Node for Ambit XML 
		if (ArrayLen(LapsNode.XML) GT 0){
			LapsNode.count = ArrayLen(LapsNode.XML);
			//XMLParse
			LapsNode.XML = XMLParse(LapsNode.XML[1]);
		}else{
			LapsNode.count = 0
		}

		//IBI Node for Ambit XML 
		if (ArrayLen(IBINode.XML) GT 0){
			IBINode.count = ArrayLen(IBINode.XML);
			//XMLParse
			IBINode.XML = XMLParse(IBINode.XML[1]);
		}else{
			IBINode.count = 0;
		}
		
		//Include all the structures into one Structure 
		AmbitNodes.headerNode = headerNode;
		AmbitNodes.samplesNode = samplesNode;
		AmbitNodes.LapsNode = lapsNode;
		AmbitNodes.IBINode = IBINode;
		
		return AmbitNodes;

	}

}
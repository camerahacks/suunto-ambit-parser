component output="false" displayname="Handles XML Funcions"  {

  /*
  indentXml pretty-prints XML and XML-like markup without requiring valid XML.

  @param xml        XML string to format. (Required)
  @param indent     String used for creating the indention. Defaults to a space. (Optional)
  @return           Returns a string. 
  @author           Barney Boisvert (bboisvert@gmail.com) 
  @version          2, July 30, 2010 
  */

	public function indentXML(required XML, indent=" "){

		var lines = "";
		var depth = "";
		var line = "";
		var isCDATAStart = False;
		var isCDATAEnd = False;
		var isEndTag = False;
		var isSelfClose = False;

		xml = trim(REReplace(xml, "(^|>)\s*(<|$)", "\1#chr(10)#\2", "all"));
		lines = listToArray(xml, chr(10));
		depth = 0;

		for(i=1; i <= arrayLen(lines); i++){

			line = trim(lines[i]);

			isCDATAStart = left(line, 9) EQ "<![CDATA[";
			isCDATAEnd = right(line, 3) EQ "]]>";

			if(NOT isCDATAStart AND NOT isCDATAEnd AND left(line, 1) EQ "<" AND right(line, 1) EQ ">"){
				isEndTag = left(line, 2) EQ "</";

				isSelfClose = (right(line, 2) EQ "/>") OR (REFindNoCase("<([a-z0-9_-]*).*</\1>", line));

				if(isEndTag){
					depth = max(0, depth - 1);
				};
				
				lines[i] = repeatString(indent, depth) & line;

				if(NOT isEndTag AND NOT isSelfClose){
					depth = depth + 1
				}
			}elseif(isCDATAStart){
				lines[i] = repeatString(indent, depth) & line;
			}
		}

		return arrayToList(lines, chr(10));

	}

}


<!---
<cffunction name="indentXml" output="false" returntype="string">
  <cfargument name="xml" type="string" required="true" />
  <cfargument name="indent" type="string" default="  "
    hint="The string to use for indenting (default is two spaces)." />
  <cfset var lines = "" />
  <cfset var depth = "" />
  <cfset var line = "" />
  <cfset var isCDATAStart = "" />
  <cfset var isCDATAEnd = "" />
  <cfset var isEndTag = "" />
  <cfset var isSelfClose = "" />
  <cfset xml = trim(REReplace(xml, "(^|>)\s*(<|$)", "\1#chr(10)#\2", "all")) />
  <cfset lines = listToArray(xml, chr(10)) />
  <cfset depth = 0 />
  <cfloop from="1" to="#arrayLen(lines)#" index="i">
    <cfset line = trim(lines[i]) />
    <cfset isCDATAStart = left(line, 9) EQ "<![CDATA[" />
    <cfset isCDATAEnd = right(line, 3) EQ "]]>" />
    <cfif NOT isCDATAStart AND NOT isCDATAEnd AND left(line, 1) EQ "<" AND right(line, 1) EQ ">">
      <cfset isEndTag = left(line, 2) EQ "</" />
      <cfset isSelfClose = right(line, 2) EQ "/>" OR REFindNoCase("<([a-z0-9_-]*).*</\1>", line) />
      <cfif isEndTag>
        <!--- use max for safety against multi-line open tags --->
        <cfset depth = max(0, depth - 1) />
      </cfif>
      <cfset lines[i] = repeatString(indent, depth) & line />
      <cfif NOT isEndTag AND NOT isSelfClose>
        <cfset depth = depth + 1 />
      </cfif>
    <cfelseif isCDATAStart>
      <!---
      we don't indent CDATA ends, because that would change the
      content of the CDATA, which isn't desirable
      --->
      <cfset lines[i] = repeatString(indent, depth) & line />
    </cfif>
  </cfloop>
  <cfreturn arrayToList(lines, chr(10)) />
</cffunction>



--->
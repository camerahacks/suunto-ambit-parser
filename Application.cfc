<cfcomponent>
	<cfset this.name = "ambit-parser" >
	<cfset this.sessionmanagement = "true" >
	<cfset this.sessionTimeout = createTimeSpan(1, 0, 0, 0) >
	<cfset this.loginStorage = "session" >
	
	<!---UDF Libraries
	<cfset structAppend(request,createObject( "component", "CFC/dateUtils" )) />
	 --->

	<!---OnApplication Start Function --->
	<cffunction name="onApplicationStart" output="false">
	

	</cffunction>

	<cffunction name="onSessionStart" output="false">

	</cffunction>

	<!---OnRequest Start Function --->
	<cffunction name="OnRequestStart">
    	<cfargument name = "request" required="true"/>
			<cfif isDefined("url.init")>
				<cfset onApplicationStart()>
			</cfif>
	</cffunction>
</cfcomponent>
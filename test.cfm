
<cfoutput> 

#StructKeyList(Session)# 
<br/><br/>

<cfdump var = "#Session#">

<hr/>

domain: #CGI.SERVER_NAME#
<br/>
page: #CGI.SCRIPT_NAME#

<cfif cgi.SCRIPT_NAME eq '/test.cfm'>
	same page
<cfelse>
	diff page
</cfif>

<cfdump var="#cgi#">

<!--- <cfset StructClear(Session)> --->
</cfoutput> 
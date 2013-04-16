<cfparam name="url.staffid" default="17370">

<cfset objCypher = CreateObject("component","core.cypher")>

<cfset s = "START node=node:person(staffid = '#url.staffid#') RETURN node">

<cfdump var="#objCypher.query(queryString=s)#">

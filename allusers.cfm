<cfset objPerson = CreateObject("component", "components.people")>

<cfset str = objPerson.getAllUsers()>

<cfset arr = str.data>

<cfloop array="#arr#" index="person">
	<cfdump var="#person#">
</cfloop>




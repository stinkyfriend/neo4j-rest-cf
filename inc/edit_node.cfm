<cfset objServiceRoot = CreateObject("component","core.nodes")>

<cfif StructIsEmpty(form)>

	<cfset str = objServiceRoot.get(url.node)>
	
	<cfoutput>
	<h2>Node #str.node#</h2>
	</cfoutput>
	
	
	<cfif not StructIsEmpty(str.data)>
		<cfoutput>
		<ul><cfloop collection="#str.data#" item="key">
			<li>#key# #str.data[key]#</li>
		</cfloop></ul>
		</cfoutput>
	</cfif>

<cfelse>
	
	
	
</cfif>


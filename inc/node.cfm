<cfset objServiceRoot = CreateObject("component","core.nodes")>

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
<cfelse>
	<cfoutput>No properties set on this node, <a href="?action=editnode&node=#str.node#">edit this node</a>?</cfoutput>
</cfif>

<!---<cfoutput>
	<a href="?action=node&node=#ListLast(str.reference_node, '/')#">#str.reference_node#</a>
</cfoutput>--->
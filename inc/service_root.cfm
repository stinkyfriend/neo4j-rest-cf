<cfset objServiceRoot = CreateObject("component","core.serviceRoot")>

<cfset str = objServiceRoot.getServiceRoot()>

<h2>Reference Node</h2>

<cfif StructKeyExists(str, "reference_node")>
	<cfoutput>
		<a href="?action=node&node=#ListLast(str.reference_node, '/')#">#str.reference_node#</a>
	</cfoutput>
<cfelse>
	No reference node exists <a href="?action=addnode">Create a node</a>?
</cfif>
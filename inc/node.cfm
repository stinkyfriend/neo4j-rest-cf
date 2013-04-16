<cfset objNode = CreateObject("component","core.nodes")>

<cfset str = objNode.get(url.node)>
<cfset arrOutRels = objNode.outgoing(url.node)>
<cfset arrInRels = objNode.incoming(url.node)>
<cfoutput>
<h2>Node #str.node#</h2>
</cfoutput>

<cfif not StructIsEmpty(str.data)>
	<cfoutput>
	<ul><cfloop collection="#str.data#" item="key">
		<li>#key#: #str.data[key]#</li>
	</cfloop></ul>
	</cfoutput>
<cfelse>
	<cfoutput>No properties set on this node, <a href="?action=editnode&node=#str.node#">edit this node</a>?</cfoutput>
</cfif>

<h2>Outgoing Relationships</h2>

<cfif ArrayLen(arrOutRels)>
	<cfoutput>
		<ul><cfloop array="#arrOutRels#" index="rel">
			<cfset endNode = ListLast(rel.end, "/")>
			<li>#rel.type# -> <a href="?action=node&node=#endNode#">#endNode#</a></li>
		</cfloop></ul>
	</cfoutput>
<cfelse>
	No outgoing relationships.
</cfif>

<h2>Incoming Relationships</h2>

<cfif ArrayLen(arrInRels)>
	<cfoutput>
		<ul><cfloop array="#arrInRels#" index="rel">
			<cfset startNode = ListLast(rel.start, "/")>
			<li>#rel.type# -> <a href="?action=node&node=#startNode#">#startNode#</a></li>
		</cfloop></ul>
	</cfoutput>
<cfelse>
	No incoming relationships.
</cfif>

<!---<cfoutput>
	<a href="?action=node&node=#ListLast(str.reference_node, '/')#">#str.reference_node#</a>
</cfoutput>--->
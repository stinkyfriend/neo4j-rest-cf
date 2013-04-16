<!--- PROCESS --->
<cfset objNode = CreateObject("component","core.nodes")>
<cfset result = objNode.create()>

<cflocation url="?action=node&node=#result.node#" addtoken="false">

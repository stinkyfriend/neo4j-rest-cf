<cfsetting showdebugoutput="false">
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<title>neo4j - API Example</title>
	<link rel="stylesheet" type="text/css" href="css/reset.css" media="screen" />
	<link rel="stylesheet" type="text/css" href="css/styles_001.css" media="screen" />
	<!--[if IE]>
		<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->
</head>

<body>

<cfparam name="arrIdeas" default="" type="any">
<cfparam name="url.action" default="" type="any">

<div id="page">

	<div id="head">
		<h1>neo4j API Example - Social Graph</h1>
		<ul>
			<li><a href="index.cfm">Home</a></li>
			<li><a href="?action=serviceroot">Service Root</a></li>
		</ul>
	</div>
	
	<div id="content">
		<cfswitch expression="#url.action#">
			<cfcase value="serviceroot">
				<cfinclude template="inc/service_root.cfm" >
			</cfcase>
			<cfcase value="node">
				<cfinclude template="inc/node.cfm" >
			</cfcase>
			<cfcase value="addnode">
				<cfinclude template="inc/add_node.cfm" >
			</cfcase>
			<cfcase value="editnode">
				<cfinclude template="inc/edit_node.cfm" >
			</cfcase>
			<cfcase value="relationships">
				<cfinclude template="inc/relationships.cfm" >
			</cfcase>
			<cfcase value="cypher">
				<cfinclude template="inc/cypher.cfm" >
			</cfcase>
			<cfcase value="index">
				<cfinclude template="inc/indexes.cfm" >
			</cfcase>
		</cfswitch>
	</div>
</div>

</body>
</html>

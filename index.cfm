<cfif application.ready>
	<cfparam name="url.user" default="">
	<cfparam name="url.load" default="10">

	<!--- Get data either for the current user or for whoever is being viewed --->
	<cfif len(url.user)>
		<cfset objPerson = createObject("component","components.person")>
		<cfset currentUser = objPerson.init( url.user )>
		<cfset following = objPerson.getCommonFollowing( )>
		<cfset followers = objPerson.getCommonFollowers( )>
		<cfset activities = objPerson.getActivites( howmany=url.load )>
		<cfset viewingWho = (session.user.getHandle() is url.user ? "Your" : "#objPerson.getFirstname()#'s") & " Activity">
		<cfset viewing = "other">
		
		
		
	<cfelse>
		<cfset following = session.user.getFollowing( )>
		<cfset followers = session.user.getFollowers( )>
		<cfset activities = session.user.getFollowedActivites( howmany=url.load )>
		<cfset viewingWho = "Your Stream">
		<cfset viewing = "self">
	</cfif>
	
</cfif>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>Streams</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="description" content="">
		<meta name="author" content="">
		
		<!-- Le styles -->
		<link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.min.css" rel="stylesheet">
		<style type="text/css">
			body {
			padding-top: 60px;
			padding-bottom: 40px;
			}
		</style>
		
		<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
		<!--[if lt IE 9]>
			<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]-->
	</head>
	
	<body>

	<div class="navbar navbar-fixed-top">
		<div class="navbar-inner">
			<div class="container">
				<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</a>
				<a class="brand" href="/">Streams</a>
				<div class="nav-collapse">
					<ul class="nav">
						<li class="active"><a href="/">Home</a></li>
						<li><a href="#about">About</a></li>
						<li><a href="#contact">Contact</a></li>
					</ul>
				</div><!--/.nav-collapse -->
			</div>
		</div>
	</div>

	<div class="container">
	
	<cfif application.ready>

		<div class="row">
			<div class="span3">
			<form action="controller/ctl_message.cfm" method="post" class="well form-horizontal">
				<label for="penned"><cfoutput>Hi #session.user.getFirstname()#, want to share something?</cfoutput></label>
				<p>
				<textarea rows="4" id="penned" name="penned"></textarea>
				</p>
				<p>
					<button class="btn btn-primary btn-medium" type="submit">
						Comment
						<i class="icon-comment icon-white"></i>
					</button>
				</p>
			</form>
		</div>
		<div class="span6">
			<h2>
			<cfoutput>#viewingWho#</cfoutput>
			<div class="btn-group pull-right">
				<button class="btn">Filter</button>
				<button class="btn dropdown-toggle" data-toggle="dropdown">
					<span class="caret"></span>
				</button>
				<ul class="dropdown-menu">
					<li>
						<a href="#">People <span class="badge pull-right">1</span></a>
					</li>
					<li>
						<a href="#">Topics <span class="badge pull-right">3</span></a>
					</li>
				</ul>
			</div>
			</h2>

			<ul class="media-list">
			<cfoutput query="activities">
				<cfset userInitials = viewing is "self" ? left(firstname, 1) & left(lastname, 1) : left(objPerson.getFirstname(), 1) & left(objPerson.getLastname(), 1)>
				<cfset fullName = viewing is "self" ? firstname & ' ' & lastname : objPerson.getFirstname() & ' ' & objPerson.getLastname()>
				<cfset dateTime = application.lib.GetTimeFromEpoch(posted_on)>
				<cfset postedOn = DateFormat(dateTime, "dd mmm yyyy") & ' ' & TimeFormat(dateTime, "hh:mm tt") >
				<li class="media well well-small">
					<a class="pull-left" href="#viewing is 'self' ? '?user=' & handle : '##'#">
						<img class="media-object img-circle" src="/avatars/#userInitials#.jpg">
					</a>
					<div class="media-body">
						<h4 class="media-heading">#fullName# <small class="pull-right">#postedOn#</small></h4>
						<div class="media">#message#</div>
					</div>
				</li>
			</cfoutput>
			</ul>
			<cfoutput><p><a class="btn" href="?user=#url.user#&load=#url.load+10#">Load more &raquo;</a></p></cfoutput>
		</div>
		<div class="span3">
			<h3>Following</h3>
			<ul class="unstyled">
				<cfoutput query="following"><cfset class = incommon ? ' <i class="icon-ok-circle"></i> ' : ""><li><a href="?user=#handle#">#firstname & ' ' & lastname#</a>#class#</li></cfoutput>
			</ul>
			<h3>Followers</h3>
			<ul class="unstyled">
				<cfoutput query="followers"><cfset class = incommon ? ' <i class="icon-ok-circle"></i> ' : ""><li><a href="?user=#handle#">#firstname & ' ' & lastname#</a>#class#</li></cfoutput>
			</ul>
		</div>
	</div>

	<cfelse>
			
		<div class="well form-horizontal">
			To experiment with the demo app please run the import scripts:
			<ol>
				<li><a href="_import/people.cfm">people</a></li>
				<li><a href="_import/avatars.cfm">avatars</a></li>
				<li><a href="_import/followers.cfm">followers</a></li>
				<li><a href="_import/messages.cfm">messages</a></li>
			</ol>
			Then <a href="?restart=1">restart the application</a>.
		</div>
	
	</cfif>
	<hr>
	<footer><p>&copy; Company 2012</p></footer>

	</div> <!-- /container -->

	<!-- Le javascript
	================================================== -->
	<!-- Placed at the end of the document so the pages load faster -->
	<script src="http://code.jquery.com/jquery-latest.js"></script>
	<script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/js/bootstrap.min.js"></script>

	</body>
</html>
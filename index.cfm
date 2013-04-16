<cfif application.ready>
	<cfset objPeople = createObject("component","components.people")>
	<cfparam name="url.user" default="andrew_fandrew">
	<cfparam name="url.load" default="10">
	<cfset currentUser = objPeople.findPerson(url.user)>
	
	<cfset userInitialised = structKeyExists(currentUser, "data")>
	<cfif userInitialised>
		<cfset following = objPeople.getFollowing(identifier=currentUser.node)>
		<cfset followers = objPeople.getFollowers(identifier=currentUser.node)>
		<cfset activities = objPeople.getFollowedActivites(identifier=currentUser.node, howmany=url.load)>
	</cfif>
	
	<cfscript>
		function GetEpochTime( datetime ) {
		    return int(DateDiff("s", "January 1 1970 00:00", datetime));
		}
		
		function GetTimeFromEpoch( epoch ) {
		    return dateAdd("s", epoch, "january 1 1970 00:00:00");
		}
	</cfscript>
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
          <a class="brand" href="#">Streams</a>
          <div class="nav-collapse">
            <ul class="nav">
              <li class="active"><a href="#">Home</a></li>
              <li><a href="#about">About</a></li>
              <li><a href="#contact">Contact</a></li>
            </ul>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>

    <div class="container">
    	
		<cfif application.ready>

      	<form action="controller/ctl_message.cfm" method="post" class="well form-horizontal">
            <cfoutput>Hi #currentUser.data[1][1].data.firstname#, want to share something?</cfoutput><br />
            <input type="text" class="input-xlarge span9" name="message" id="input01" />
			<cfoutput><input type="hidden" name="user" value="#url.user#" /></cfoutput>
			<button class="btn btn-primary btn-large" type="submit">
                Comment
                <i class="icon-comment icon-white"></i>
            </button>
        </form>
		
		

      <!-- Example row of columns -->
      <div class="row">
        <div class="span3">
          <h2>Filter</h2>
            <ul class="nav nav-tabs nav-stacked">
                <li class="active">
                <a href="#">Projects <span class="badge">1</span></a>
                </li>
                <li><a href="#">Networks <span class="badge">7</span></a></li>
                <li><a href="#">People <span class="badge">0</span></a></li>
                <li><a href="#">Forums <span class="badge">12</span></a></li>
            </ul>
        </div>
        <div class="span6">
          <cfoutput>
		  <h2>Activity</h2>
          <ul>
          	<cfloop array="#activities.data#" index="activity">
		  		<li>#activity[2] & ' ' & activity[3]# - #activity[1]# (#GetTimeFromEpoch(activity[5])#)</li>
			</cfloop>
          </ul>
          <p><a class="btn" href="?user=#url.user#&load=#url.load+10#">Load more &raquo;</a></p>
		  </cfoutput>
       </div>
        <div class="span3">
          <h3>Following</h3>
          <ul>
		  	<cfoutput><cfloop array="#following.data#" index="person">
		  		<li><a href="?user=#person[3]#">#person[1] & ' ' & person[2]#</a></li>
			</cfloop></cfoutput>
		  </ul>
          <h3>Followers</h3>
          <ul>
		  	<cfoutput><cfloop array="#followers.data#" index="person">
		  		<li><a href="?user=#person[3]#">#person[1] & ' ' & person[2]#</a></li>
			</cfloop></cfoutput>
		  </ul>
        </div>
      </div>
	  
	  <cfelse>
			
			<form action="controller/ctl_message.cfm" method="post" class="well form-horizontal">
            To experiment with the demo app please run the import scripts:
			<ol>
				<li><a href="_import/people.cfm">people</a></li>
				<li><a href="_import/followers.cfm">followers</a></li>
				<li><a href="_import/messages.cfm">messages</a></li>
			</ol>
			Then <a href="?restart=1">restart the application</a>.
        	</form>
		
		</cfif>

      <hr>

      <footer>
        <p>&copy; Company 2012</p>
      </footer>

    </div> <!-- /container -->

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="http://code.jquery.com/jquery-latest.js"></script>
	<script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/js/bootstrap.min.js"></script>

  </body>
</html>
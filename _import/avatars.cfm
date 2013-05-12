<cfparam name="url.start" default="1">

<cftry>

	<cfset filePath = ExpandPath("/")>
	<cfset filePathAvatars = filePath & "/avatars/">
	<cfset filePathData = filePath & "/_import/data/users-sample.json">

	<cffile action="read" file="#filePathData#" variable="fileContents">

	<cfif IsJSON(fileContents)>
		<cfset users =  deserializeJSON(fileContents)>
	<cfelse>
		<cfthrow message="can't convert the contents of #filePath#">
	</cfif>
	
	<cfif not DirectoryExists(filePathAvatars)>
		<cfdirectory action="create" directory="#filePathAvatars#">
	</cfif>
	
	<cfloop array="#users#" index="user">
		<cfset initials = Ucase(left(user.f_name, 1) & left(user.l_name, 1))>
		<cfset bcg = left(hash(initials), 6)>
		<cfset r = "#FormatBaseN(255-InputBaseN(mid(bcg, 1, 2), 16), 16)#">
		<cfset g = "#FormatBaseN(255-InputBaseN(mid(bcg, 3, 2), 16), 16)#">
		<cfset b = "#FormatBaseN(255-InputBaseN(mid(bcg, 5, 2), 16), 16)#">
		<cfset fg = UCase(len(r) lt 2 ? (r & RepeatString(0, (2-len(r)))) : r) &
					UCase(len(g) lt 2 ? (g & RepeatString(0, (2-len(g)))) : g) & 
					UCase(len(b) lt 2 ? (b & RepeatString(0, (2-len(b)))) : b)>
		<cfset image = ImageNew("", 50, 50, "rgb", bcg)>
		<cfset m = {font="impact", size=25, style="bold"}>
		<cfset ImageSetDrawingColor(image, fg)>
		<cfset pos = getCenteredTextPosition(image, initials, m)>
		<cfset ImageDrawText(image, initials, pos.x, pos.y, m)>
		<cfoutput>#filePathAvatars##initials#.jpg</cfoutput><br>
		<cfimage action="write" quality="1" overwrite="yes" destination="#filePathAvatars##initials#.jpg" source="#image#">
	</cfloop>
	
	<!---
	This code is credited to Ben Nadel, Barney Boisvert, and a user named C S
	--->
	<cffunction name="getCenteredTextPosition" access="public" returnType="struct" output="false">
		<cfargument name="image" type="any" required="true">
		<cfargument name="text" type="string" required="true">
		<cfargument name="fontname" type="any" required="true" hint="This can either be the name of a font, or a structure containing style,size,font, like you would use for imageDrawText">
		<cfargument name="fonttype" type="string" required="false" hint="Must be ITALIC, PLAIN, or BOLD">
		<cfargument name="fontsize" type="string" required="false">
		
		<cfset var buffered = imageGetBufferedImage(arguments.image)>
		<cfset var context = buffered.getGraphics().getFontRenderContext()>
		<cfset var font = createObject("java", "java.awt.Font")>
		<cfset var textFont = "">
		<cfset var textLayout = "">
		<cfset var textBounds = "">
		<cfset var result = structNew()>
		<cfset var fp = "">
		<cfset var width = "">
		<cfset var height = "">
		
		<!--- Handle arguments.fontName possibly being a structure. --->
		<cfif isStruct(arguments.fontname)>
			<cfset arguments.fonttype = arguments.fontname.style>
			<cfset arguments.fontsize = arguments.fontname.size>
			<cfset arguments.fontname = arguments.fontname.font>
		</cfif>
		
		<!--- possibly refactor --->	
		<cfif arguments.fonttype is "plain">
			<cfset fp = font.PLAIN>
		<cfelseif arguments.fonttype is "bold">
			<cfset fp = font.BOLD>
		<cfelse>
			<cfset fp = font.ITALIC>
		</cfif>
	
		<cfset textFont = font.init(arguments.fontname, fp, javacast("int", arguments.fontsize))>
		<cfset textLayout = createObject("java", "java.awt.font.TextLayout").init( arguments.text, textFont, context)>
		<cfset textBounds = textLayout.getBounds()>
		<cfset width = textBounds.getWidth()>
		<cfset height = textBounds.getHeight()>
		
		<cfset result.x = (arguments.image.width/2 - width/2)>
		<cfset result.y = (arguments.image.height/2 + height/2)>
	
		<cfreturn result>
	</cffunction>
	
	<cfcatch>
		<cfdump var="#cfcatch#">
	</cfcatch>
	
</cftry>
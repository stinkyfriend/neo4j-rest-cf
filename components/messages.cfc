component
{
	public any function add( message ) hint="Add a message to current user's activity." {
		
		str = {};
		str["message"] = trim(arguments.message);
		
		objBatch = CreateObject("component","core.batch");
		
		batchID = objBatch.build("node", str);
		
		ref_relationship = {	from_node=application.requires["MESSAGES_REFERENCE"], 
								to_node="{#batchID#}", 
								type="MESSAGES"};

		objBatch.build("relationship", ref_relationship);

		relationship = {	from_node=session.user.getNodeID(), 
							to_node="{#batchID#}", 
							type="PENNED", 
							data={"posted_on"=application.lib.GetEpochTime(now())}};
		objBatch.build("relationship", relationship);
		
		objBatch.send();
	}

}
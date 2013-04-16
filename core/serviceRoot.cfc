component 
{
	this.core = CreateObject("component","core");
	
	public any function getServiceRoot( ) hint="Gets the service root." {
		result = this.core.makeRequest( );
		return result;
	}
}
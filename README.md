neo4j-rest-cf
=============

This is a sample ColdFusion app using Neo4j via the REST API.

This project has 4 distinct areas:
# The import of dummy data, this is useful because you can see how to get data into your Neo4j instance - this is in the '_import' folder.
# The communication or gateway between the app and Neo4j's REST API. I have actually re-purposed a REST client I have used with many REST APIs just tweaked a couple of properties and added a couple of extra helper functions - this is in the 'core' folder.
# An admin view on your data, admin.cfm. This essentially allows you to browse your data (nodesA-[relationships]-nodesB). Although you're better off using Neo4j's web admin interface - very slick.
# The sample application, index.cfm - not really that fancy but it is a starting point.


 
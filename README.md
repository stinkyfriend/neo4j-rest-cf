neo4j-rest-cf
=============

This is a sample ColdFusion app using Neo4j via the REST API.

### What you'll need ###

1. Neo4j (plenty of installation guidance around the interwebs).
2. ColdFusion 9 (well, this is what I have used).

### About the sample app ###

The app is basic and doesn't stretch Neo4j's legs at all. The data is not as 
highly 'related' as it can be but it is a start. It is a good intro to Graph DBs, 
Cypher, Neo4j's REST API and using all of that with ColdFusion.

It is a very simple twitter-esque app, using Twitter Bootstrap. When you 
setup the app it creates 20 users; 50 tweets per user are generated; 
avatars are created per user; and then the [:FOLLOWS] relationship is added between users.

When using the app you will be browsing as a dummy user, 'Andrew Fandrew'. 
You will be able to add messages (tweets); and view messages (tweets) of the people you're 
following. You can browse the other users and see their tweets, followers, and who they're following.

The project has 4 distinct areas:

1. Import
2. Gateway
3. Admin
4. Sample

### Import ###
The import of dummy data, this is useful because you can see how to 
get data into your Neo4j instance - this is in the _import_ folder.

### Gateway ###
The communication or gateway between the app and Neo4j's REST API. 
I have actually re-purposed a REST client I have used with many REST APIs 
just tweaked a couple of properties and added a couple of extra helper functions - this is in the _core_ folder.

### Admin ###
An admin view on your data, _admin.cfm_. This essentially allows you 
to browse your data (nodesA-[relationships]-nodesB). Although you're 
probably better off using Neo4j's web admin interface - very slick.

### Sample ###
The sample application, index.cfm - not really that fancy but it is a starting point.
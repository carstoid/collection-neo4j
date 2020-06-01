LOAD CSV WITH HEADERS FROM 'file:///creators.csv' AS row
MERGE (e:Entity {entityId: row.id})
;

LOAD CSV WITH HEADERS FROM 'file:///creators.csv' AS row
MATCH (e:Entity {entityId: row.id})
SET e.name=row.displayname
;

LOAD CSV WITH HEADERS FROM 'file:///creators.csv' AS row
MATCH (e:Entity {entityId: row.id})
SET e.firstName=row.forename,
    e.lastName=row.surname,
    e.lifespan=row.lifespan,
    e.ulan=row.ulan,
    e.note=row.note
;

LOAD CSV WITH HEADERS FROM 'file:///creators.csv' AS row
MATCH (e:Entity {entityId: row.id})
UNWIND split(row.nationalities, ',') AS country
MERGE (p:Place {name: country})
MERGE (e)-[ecr:RESIDENT_OF]->(p)
;

LOAD CSV WITH HEADERS FROM 'file:///creators.csv' AS row
MATCH (e:Entity {entityId: row.id})
SET e.roles = split(row.roles, ',')
;

LOAD CSV WITH HEADERS FROM 'file:///creators.csv' AS row
MATCH (e:Entity {entityId: row.id})
UNWIND split(row.projects, ',') as project
MERGE (t:Thing {thingId: project})
MERGE (e)-[etr:AUTHORED]->(t)
;

// only succeeds after lowering periodic commit to 100 (80% mem usage on local docker)
// takes 6mins to run
:auto USING PERIODIC COMMIT 100
LOAD CSV WITH HEADERS FROM 'file:///creators.csv' AS row
MATCH (e:Entity {entityId: row.id})
UNWIND split(row.assets, ',') AS asset
MERGE (i:Image {imageId: asset})
MERGE (e)-[eir:AUTHORED]->(i)
;
// id,creators,assets,projectsrelated,name,altname,yearbegin,yearend,placenames,lat,lng,types,note

LOAD CSV WITH HEADERS FROM 'file:///projects.csv' AS row
MERGE (t:Thing {thingId: row.id})
;

LOAD CSV WITH HEADERS FROM 'file:///projects.csv' AS row
MATCH (t:Thing {thingId: row.id})
SET t.name = row.name
;

LOAD CSV WITH HEADERS FROM 'file:///projects.csv' AS row
MATCH (t:Thing {thingId: row.id})
SET t.altName = row.altname,
    t.yearBegin = toInteger(row.yearbegin),
    t.yearEnd = toInteger(row.yearend),
    t.lat = toFloat(row.lat),
    t.lng = toFloat(row.lng),
    t.note = row.note
;

LOAD CSV WITH HEADERS FROM 'file:///projects.csv' AS row
MATCH (t:Thing {thingId: row.id})
UNWIND split(row.placenames, ',') AS place
MERGE (p:Place {name: place})
MERGE (t)-[r:LOCATED_IN]->(p)
;

LOAD CSV WITH HEADERS FROM 'file:///projects.csv' AS row
MATCH (t:Thing {thingId: row.id})
SET t.types = split(row.types, ',')
;

LOAD CSV WITH HEADERS FROM 'file:///projects.csv' AS row
MATCH (t:Thing {thingId: row.id})
UNWIND split(row.projectsrelated, ',') as project
MERGE (tr:Thing {thingId: project})
MERGE (t)-[r:RELATED_TO]->(tr)
;

LOAD CSV WITH HEADERS FROM 'file:///projects.csv' AS row
MATCH (t:Thing {thingId: row.id})
UNWIND split(row.creators, ',') as creator
MERGE (e:Entity {entityId: creator})
MERGE (e)-[r:AUTHORED]->(t)
;

// 7 mins to complete
:auto USING PERIODIC COMMIT 100
LOAD CSV WITH HEADERS FROM 'file:///projects.csv' AS row
MATCH (t:Thing {thingId: row.id})
UNWIND split(row.assets, ',') AS asset
MERGE (i:Image {imageId: asset})
MERGE (i)-[eir:DEPICTS]->(t)
;

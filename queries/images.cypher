// id,collection,date,type,subtype,sourcelabel,sourcetype,sourcecall,note

// 24mins
:auto USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///images.csv' AS row
MERGE (i:Image {imageId: row.id})
;

// 45 mins
:auto USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///images.csv' AS row
WITH row WHERE row.collection IS NOT NULL
MATCH (i:Image {imageId: row.id})
MERGE (c:Collection {collectionId: row.collection})
MERGE (c)-[r:INCLUDES]->(i)
;

// 40 mins
:auto USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///images.csv' AS row
MATCH (i:Image {imageId: row.id})
SET i.type = row.type,
    i.subtype = row.subtype,
    i.sourceLabel = row.sourcelabel,
    i.sourceType = row.sourcetype,
    i.sourceCall = row.sourcecall,
    i.date = row.date,
    i.note = row.note
;

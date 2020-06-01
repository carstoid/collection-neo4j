# Collection → Neo4j

This repository includes materials used to create an instance of the Neo4j graph database from a collection of project, creator and image records originally exported from Filemaker.

After running `docker-compose up` to start the container, move all source .csv files to the bind-mounted import folder at `~/neo4j/import`. Using the [Neo4j Browser](http://localhost:7474/browser/) you can then run the individual `queries` to import different parts of the dataset.

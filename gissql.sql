CREATE EXTENSION postgis;
CREATE TABLE gistable (id SERIAL PRIMARY KEY, name TEXT, geom GEOMETRY(Point, 4326));
INSERT INTO gistable (name, geom) VALUES ('Point A', ST_SetSRID(ST_MakePoint(-73.985, 40.748), 4326));
INSERT INTO gistable (name, geom) VALUES ('Point B', ST_SetSRID(ST_MakePoint(-73.991, 40.753), 4326));
INSERT INTO gistable (name, geom) VALUES ('Point C', ST_SetSRID(ST_MakePoint(-73.979, 40.762), 4326));

select * from gistable; --show the records

--a) select locations of specific features
SELECT ST_AsText(geom) FROM gistable WHERE name = 'Point A';

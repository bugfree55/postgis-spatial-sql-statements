--show postgis version first
SELECT PostGIS_Version();
CREATE EXTENSION postgis;
CREATE TABLE gistable (id SERIAL PRIMARY KEY, name TEXT, geom GEOMETRY(Point, 4326));
INSERT INTO gistable (name, geom) VALUES ('Point A', ST_SetSRID(ST_MakePoint(-73.985, 40.748), 4326));
INSERT INTO gistable (name, geom) VALUES ('Point B', ST_SetSRID(ST_MakePoint(-73.991, 40.753), 4326));
INSERT INTO gistable (name, geom) VALUES ('Point C', ST_SetSRID(ST_MakePoint(-73.979, 40.762), 4326));

delete from city_boundary;
INSERT INTO city_boundary (name, geom) VALUES
('Manhattan', ST_GeomFromText('POLYGON((-74.047285 40.882076,-73.906588 40.881583,-73.907660 40.696331,-74.032066 40.701908,-74.047285 40.882076))', 4326)),
('Brooklyn', ST_GeomFromText('POLYGON((-73.986282 40.733469,-73.833365 40.733208,-73.834524 40.569399,-74.050508 40.579656,-73.986282 40.733469))', 4326)),
('Queens', ST_GeomFromText('POLYGON((-73.700272 40.798664,-73.703137 40.738207,-73.931606 40.697162,-73.912787 40.611047,-73.782296 40.594946,-73.700272 40.798664))', 4326)),
('Bronx', ST_GeomFromText('POLYGON((-73.933408 40.963488,-73.793983 40.963058,-73.756573 40.872126,-73.909425 40.800380,-73.933408 40.963488))', 4326)),
('Staten Island', ST_GeomFromText('POLYGON((-74.246569 40.637536,-74.049864 40.647332,-74.059982 40.497270,-74.255682 40.504651,-74.246569 40.637536))', 4326)),
('Newark', ST_GeomFromText('POLYGON((-74.192526 40.855802,-74.140777 40.843057,-74.168128 40.794630,-74.221267 40.806814,-74.192526 40.855802))', 4326)),
('Jersey City', ST_GeomFromText('POLYGON((-74.088557 40.733553,-74.020892 40.713855,-74.036796 40.682434,-74.082142 40.691124,-74.088557 40.733553))', 4326)),
('Hoboken', ST_GeomFromText('POLYGON((-74.044936 40.767943,-74.016196 40.750579,-74.022610 40.737831,-74.049033 40.752671,-74.044936 40.767943))', 4326)),
('Yonkers', ST_GeomFromText('POLYGON((-73.888378 40.962853,-73.867630 40.940170,-73.922011 40.916204,-73.934546 40.933605,-73.888378 40.962853))', 4326)),
('New Rochelle', ST_GeomFromText('POLYGON((-73.808141 40.972950,-73.769391 40.946601,-73.793931 40.928431,-73.832682 40.954780,-73.808141 40.972950))', 4326));
select * from gistable; --show the records

--a) select locations of specific features
SELECT ST_AsText(geom) FROM gistable WHERE name != 'Point A';

--b) calculate distance between points
SELECT ST_Distance(ST_SetSRID(ST_MakePoint(-73.985, 40.748), 4326)::geography, ST_SetSRID(ST_MakePoint(-74.005, 40.712), 4326)::geography) as distance_in_meters FROM gistable WHERE id != 1;

--c)
SELECT g.group_id, g.group_name, ST_Area(ST_Intersection(g.geom, c.geom)) as area_within_city
FROM groups g, city_boundary c
WHERE ST_Intersects(g.geom, c.geom);

--d) Speeding up the queires execution time.
-- first create an index which speeds up retrieval of records
CREATE INDEX city_boundary_geom_idx ON city_boundary USING GIST (geom);
--use subquery to select table then apply spatial operations on the smaller data subset
SELECT name, ST_Distance(geom::geography, ST_MakePoint(-73.985428, 40.748817)::geography) AS distance
FROM city_boundary
ORDER BY distance;

--e) sorting and limit
select * from city_boundary order by id desc limit 1; --select the last record by Id


--f) N-optimization of queries
-- use indexes to speed up retrieval of queries to improve query performance on db
CREATE INDEX groups_name_idx ON groups(group_name);
select distinct (group_name) from groups;

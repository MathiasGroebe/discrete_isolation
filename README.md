# Discrete isolation
PostgreSQL/PostGIS implementation of the discrete isolation. The resulting value can used for point selection purposes. It needs a single point geometry and a numerical value. For usage you need the data in a PostgreSQL database with the PostGIS extension. It works well with around 10,000 points, with more points you have to consider a long execution time. If you have less then 1,000 point take a look at the free (QGIS Plugin)[https://github.com/MathiasGroebe/point_selection/].

## Usage

Here some sample data using peaks. The geometry is just for the illustration shown as Well-known text.

| id | name              | elevation | isolation | geom::geometry(Point, 3857)            |
|----|-------------------|-----------|-----------|----------------------------------------|
| 1  | Cottaer Spitzberg | 391       |           | POINT (1554915.030049 6603385.479223)  |
| 2  | Mt. Everest       | 8848.86   |           | POINT (9676427.650365 3247440.479570)  |
| 3  | Zugspitze         | 2962      |           | POINT (1222988.989970 6011100.150710)  |
| 4  | Dürrer Berg       | 437       |           | POINT (1553173.319730 6597213.489256)  |

The syntax for the function is the follwing:
    
    discrete_isolation(table_name::text, name_of_geometry_column::text, name_of_elevation_column::text,
                        geometry_of_point::geometry, elevation_of_point::numeric (, max_search_radius::numeric))

All calculation are made within the given spatial referenc system, also the isolation is measured in this systems. For best results, project first the data and afterwards calculate the isolation

For calculating the discrete isolation in our example run the followinng query:

    UPDATE peaks
    SET isolation = discrete_isolation('peaks', 'geom', 'elevation', geom, elevation)
    
It will fill the isolation colum in the sample table called "peaks". If you want to limit the search radius, you can use the following query. 

    UPDATE peaks
    SET isolation = discrete_isolation('peaks', 'geom', 'elevation', geom, elevation, 1)
    



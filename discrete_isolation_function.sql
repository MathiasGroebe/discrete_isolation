CREATE OR REPLACE FUNCTION discrete_isolation(peak_table text, peak_table_geom_column_name text, elevation_column text, peak_geometry geometry, elevation_value numeric) returns decimal as
$$
DECLARE isolation_value decimal;
BEGIN

IF elevation_value IS NULL THEN RETURN NULL;

ELSE
	
	EXECUTE  'SELECT ST_Distance(''' || peak_geometry::text || '''::geometry, ' || peak_table_geom_column_name || ') as distance
	FROM ' || peak_table || '
	WHERE '|| elevation_column ||' > ' || elevation_value || '
	ORDER BY distance
	LIMIT 1' INTO isolation_value;

	IF isolation_value IS NULL THEN RETURN 30000000; -- set value for the highest peak
	END IF;

RETURN isolation_value;
END IF;

END;
$$ LANGUAGE plpgsql PARALLEL SAFE COST 60;

-- Second version of the function with a reduced complexity by limiting the search radius

CREATE OR REPLACE FUNCTION discrete_isolation(peak_table text, peak_table_geom_column_name text, elevation_column text, peak_geometry geometry, elevation_value numeric, max_search_radius numeric) returns decimal as
$$
DECLARE isolation_value decimal;
BEGIN

IF elevation_value IS NULL THEN RETURN NULL;

ELSE
	
	EXECUTE  'SELECT ST_Distance(''' || peak_geometry::text || '''::geometry, ' || peak_table_geom_column_name || ') as distance
	FROM ' || peak_table || '
	WHERE '|| elevation_column ||' > ' || elevation_value || ' AND ST_DWithin(''' || peak_geometry::text || '''::geometry, ' || peak_table_geom_column_name ||', ' || max_search_radius || ')
	ORDER BY distance
	LIMIT 1' INTO isolation_value;

	IF isolation_value IS NULL THEN RETURN max_search_radius; -- set value maxium distance
	END IF;

RETURN isolation_value;
END IF;

END;
$$ LANGUAGE plpgsql PARALLEL SAFE COST 30;

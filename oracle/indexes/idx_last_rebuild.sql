--
--   Last rebuild time for indexes
--
--   @tested on: 10g
--


SELECT
	dbo.owner,
	dbi.index_name,
	dbo.last_ddl_time,
	dbo.created,
	dbi.temporary AS index_is_temporary,
	dbt.temporary AS table_is_temporary
FROM
	dba_objects dbo
JOIN
	dba_indexes dbi ON (dbo.owner = dbi.owner AND dbo.object_name = dbi.index_name)
JOIN
	dba_tables dbt ON (dbi.owner = dbo.owner AND dbi.table_name = dbt.table_name)
WHERE
	object_type = 'INDEX'
ORDER BY
	last_ddl_time DESC, created DESC;
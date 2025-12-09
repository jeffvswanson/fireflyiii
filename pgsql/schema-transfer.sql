DO LANGUAGE plpgsql
$BODY$
DECLARE
   ye_olde_schema NAME = 'public';
   ye_new_schema NAME = 'budget';
   alter_sql TEXT;
BEGIN
  FOR alter_sql IN
    SELECT 
        format('ALTER TABLE %I.%I SET SCHEMA %I', n.nspname, c.relname, ye_new_schema)
      FROM pg_class AS c
      JOIN pg_namespace AS n ON n.oid = c.relnamespace
      WHERE
        n.nspname = ye_olde_schema
        AND
        c.relkind = 'r'
  LOOP
    RAISE NOTICE 'Running statement: %', alter_sql;
    EXECUTE alter_sql;
  END LOOP;
END;
$BODY$;

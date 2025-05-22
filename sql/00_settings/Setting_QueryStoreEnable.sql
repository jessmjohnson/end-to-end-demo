
-- This script sets up the database for the demo.
-- Enables Query Store, and creates the necessary schemas.
ALTER DATABASE dspendtoenddemo
SET QUERY_STORE = ON;
GO;


-- Validate the Query Store settings
-- Check if Query Store is enabled
SELECT desired_state_desc,actual_state_desc, readonly_reason, current_storage_size_mb, max_storage_size_mb, max_plans_per_query 
FROM sys.database_query_store_options;

-- desired_state_desc: Indicates the requested operation mode (e.g., READ_WRITE, READ_ONLY, OFF).
-- actual_state_desc: Shows the current operation mode of the Query Store.
-- readonly_reason: Provides reasons if the Query Store is in read-only mode 1 2.V
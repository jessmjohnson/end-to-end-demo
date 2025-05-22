-- 1) Create the user from your ADF managed identity
CREATE USER [adfendtoenddemo] 
  FROM EXTERNAL PROVIDER;
GO

-- 2) Add them to the db_datareader role
EXEC sp_addrolemember  
     @rolename = N'db_datareader', 
     @membername = N'adfendtoenddemo';
GO

-- 3) And to the db_datawriter role
EXEC sp_addrolemember  
     @rolename = N'db_datawriter', 
     @membername = N'adfendtoenddemo';
GO

-- 4) Database level permissions
GRANT VIEW DATABASE STATE TO [adfendtoenddemo];
GO

-- 5) Grant bulk‑ops permission to your ADF MSI user
GRANT ADMINISTER DATABASE BULK OPERATIONS TO adfendtoenddemo;
GO

SELECT 
*
FROM sys.database_permissions p
JOIN sys.database_principals dp
  ON p.grantee_principal_id = dp.principal_id
WHERE permission_name = 'ADMINISTER DATABASE BULK OPERATIONS';

----------------------------------
-- Grants For Schema::Control
----------------------------------
GRANT EXECUTE 
  ON SCHEMA::Control 
  TO adfendtoenddemo;
GO

GRANT SELECT 
  ON SCHEMA::Control 
  TO adfendtoenddemo;
GO

GRANT ALTER, INSERT 
  ON SCHEMA::Control 
  TO adfendtoenddemo;
GO

----------------------------------
-- Grants for schema::Telemetry
----------------------------------
GRANT SELECT 
  ON SCHEMA::Telemetry 
  TO adfendtoenddemo;
GO

GRANT EXECUTE 
  ON SCHEMA::Telemetry 
  TO adfendtoenddemo;
GO

GRANT ALTER, INSERT 
  ON SCHEMA::Telemetry 
  TO adfendtoenddemo;
GO

----------------------------------
-- Grants for schema:: Bronze
----------------------------------
GRANT SELECT 
  ON SCHEMA::Bronze 
  TO adfendtoenddemo;
GO
GRANT EXECUTE 
  ON SCHEMA::Bronze 
  TO adfendtoenddemo;
GO

GRANT ALTER, INSERT 
  ON SCHEMA::Bronze 
  TO adfendtoenddemo;
GO

----------------------------------
-- Grants for schema:: Silver
----------------------------------
GRANT SELECT 
  ON SCHEMA::Silver 
  TO adfendtoenddemo;
GO

GRANT EXECUTE 
  ON SCHEMA::Silver 
  TO adfendtoenddemo;
GO

GRANT ALTER, INSERT 
  ON SCHEMA::Silver 
  TO adfendtoenddemo;
GO

----------------------------------
-- Grants for schema:: Gold
----------------------------------
GRANT SELECT 
  ON SCHEMA::Gold 
  TO adfendtoenddemo;
GO

GRANT EXECUTE 
  ON SCHEMA::Gold 
  TO adfendtoenddemo;
GO

GRANT ALTER, INSERT 
  ON SCHEMA::Gold 
  TO adfendtoenddemo;
GO
IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'POWERPLAY\SqlServiceAccounts')
CREATE LOGIN [POWERPLAY\SqlServiceAccounts] FROM WINDOWS
GO
CREATE USER [POWERPLAY\SqlServiceAccounts] FOR LOGIN [POWERPLAY\SqlServiceAccounts]
GO

IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'POWERPLAY\it.wallboard')
CREATE LOGIN [POWERPLAY\it.wallboard] FROM WINDOWS
GO
CREATE USER [POWERPLAY\it.wallboard] FOR LOGIN [POWERPLAY\it.wallboard]
GO

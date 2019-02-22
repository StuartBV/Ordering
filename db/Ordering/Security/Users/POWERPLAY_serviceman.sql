IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'POWERPLAY\serviceman')
CREATE LOGIN [POWERPLAY\serviceman] FROM WINDOWS
GO
CREATE USER [POWERPLAY\serviceman] FOR LOGIN [POWERPLAY\serviceman]
GO

IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'POWERPLAY\IT Development')
CREATE LOGIN [POWERPLAY\IT Development] FROM WINDOWS
GO
CREATE USER [IT Development] FOR LOGIN [POWERPLAY\IT Development]
GO

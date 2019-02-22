IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'powerplay\octopus')
CREATE LOGIN [powerplay\octopus] FROM WINDOWS
GO
CREATE USER [powerplay\octopus] FOR LOGIN [powerplay\octopus]
GO

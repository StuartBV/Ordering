SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE trigger [TR_DataTypePolicy] on database for create_table, alter_table
as
declare @eventdata as xml, @tablename as sysname, @schemaname as sysname

set @eventdata = eventdata();
set @tablename = cast(@eventdata.query('data(//ObjectName)') as sysname);
set @schemaname = cast(@eventdata.query('data(//SchemaName)') as sysname);

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = @schemaname and TABLE_NAME = @tablename and DATA_TYPE in ('nvarchar','nchar','ntext'))
begin
	raiserror('Please do not use Unicode data types',16,1)
	rollback
end


GO

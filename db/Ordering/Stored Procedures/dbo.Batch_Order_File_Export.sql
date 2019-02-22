SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Batch_Order_File_Export]
@batchid int,
@userid userid,
@supplierid int,
@file varchar(100),
@path varchar(100)
as
set nocount on
set transaction isolation level read uncommitted

declare @sql varchar(255),@bcpcmd varchar(512)

set @sql='exec Ordering.dbo.BATCH_Order_Get @batchid='+cast(@batchid as varchar)
set @bcpcmd=ppd3.dbo.BcpCommand() + '"'+@sql+'" queryout "' +@path + @file + '" -r\n -c -t, -S'+@@servername+' -T'
exec master.dbo.xp_cmdshell @bcpcmd, no_output	
GO

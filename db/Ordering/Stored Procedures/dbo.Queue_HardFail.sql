SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Queue_HardFail]
@queueid int,
@syscomments varchar(max)
as
update dbo.Queue_Queue
set RetryCount=99,[SysComments] = @syscomments,AlteredDate=getdate(),AlteredBy='sys.queue_hard_fail'
where Id=@queueid

GO

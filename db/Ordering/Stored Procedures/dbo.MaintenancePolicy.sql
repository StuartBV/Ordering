SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[MaintenancePolicy] as
set nocount on
declare @dt date=getdate(), @months int=72

delete from Queue_Queue where datediff(mm,DateSent,@dt)>36
delete from AmazonLog where datediff(mm,CreateDate,@dt)>@months
delete from x from ORDERING_MessageLogging x where not exists (select * from Queue_Queue q where q.id=x.QueueID)
GO

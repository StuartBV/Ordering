SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Batch_Order_MarkAsSent]
@batchid int,
@userid userid='sys.process'
as
set nocount on
set transaction isolation level read uncommitted
declare @dt datetime=getdate()

-- Mark Orders as sent
update Batch_Orders set
	datesent=@dt,
	alteredby=@userid
where batchid=@batchid

--Mark File as sent
update Batch_Files set
	datesent=@dt,
	altereddate=@dt,
	alteredby=@userid
where BatchId=@batchid
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Sender_BatchOrder_Send]
@queueid int
as
set nocount on
set transaction isolation level read uncommitted

insert into BATCH_Orders(DeliveryId,CreatedBy,CreateDate,SupplierId)
select q.DeliveryId,'sys.process',getdate(),d.SupplierId
from QUEUE_Queue q
join ORDERING_Delivery d on d.id=q.DeliveryId
where q.id=@queueid
GO

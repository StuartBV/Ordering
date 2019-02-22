SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Queue_QueueItem_Insert] as
set nocount on
set transaction isolation level read uncommitted

insert into QUEUE_Queue(DeliveryId,CreatedBy)
select od.id,od.CreatedBy
from ORDERING_Delivery od 
where ([status]=0 or od.SupplierId = 6560)
and not exists(	select * from QUEUE_Queue q where q.deliveryid=od.Id)

update q set
	q.datesent=getdate(),
	q.AlteredDate=getdate(),
	q.alteredby='sys'
from Queue_Queue q
where q.DateSent is null and exists (select * from Ordering_Delivery od where od.id=q.DeliveryId and od.SupplierId=6560)
GO

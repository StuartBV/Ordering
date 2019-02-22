SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[PowerplayStockOrdered] as
-- This view includes q.oos in order that it can be updated. It is updated by trigger productinventory.updatestock which uses productcode and supplierid to join on.
-- when stock is booked in for web, the queue rows of orders with affected items are reset to allow them to be retried.
-- there is an additional trigger on queue_queue that resets all items for the order to 5 ready for powerplay order to try again

select q.oos,x.ProductCode,x.SupplierId, q.altereddate,q.alteredby
from
QUEUE_Queue q join (
	select distinct i.DeliveryId,i.productcode,d.SupplierId
	from ORDERING_DeliveryItems i join ORDERING_Delivery d on d.[id]=i.DeliveryId
	where i.[status]=15
)x on q.DeliveryId=x.DeliveryId and q.oos=1
 
GO

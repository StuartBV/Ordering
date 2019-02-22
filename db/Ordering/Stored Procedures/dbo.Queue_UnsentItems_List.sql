SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Queue_UnsentItems_List]
as
set nocount on
set transaction isolation level read uncommitted

select top 100 
	q.id,
	isnull(s.OrderSenderId,0) OrderSenderId,
	od.Id as DeliveryId,
	od.SupplierId,
	od.ProductFulfilmentType,
	pdft.ShouldSendInvoice
from QUEUE_Queue q
join ORDERING_Delivery od on od.id=q.DeliveryId
join ORDERING_ProductFulfilmentTypes pdft on pdft.Id=od.ProductFulfilmentType
left join dbo.OrderSenders_Config s on dbo.OrderSenders_ConfigId_Get(q.id)=s.id
where q.DateSent is null
and q.RetryCount<5
and q.oos=0
order by q.id asc
GO

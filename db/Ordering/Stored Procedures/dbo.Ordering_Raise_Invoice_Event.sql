SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ordering_Raise_Invoice_Event]
as 
insert	into Ordering_Events (DeliveryId, [Type], Channel, SupplierID, CreatedBy)
select	q.DeliveryId, 800, od.Channel, od.SupplierId, 'sys'
from	Queue_Queue q
join 	Ordering_Delivery od on od.Id=q.DeliveryId
join 	ORDERING_ProductFulfilmentTypes pdft on pdft.Id=od.ProductFulfilmentType
left join Validator2.dbo.ClientSettings cs on od.InscoId = cs.InscoId
where	pdft.ShouldSendInvoice = 1
		and od.SourceType not in (2,4,6)
		and q.DateSent is not null
		and q.OOS=0
		and (od.ProductFulfilmentType not in (3, 8) or isnull(cs.CashPaymentBankId, 0) > 0)
		and not exists ( select	* from Ordering_Events e where	e.DeliveryId=q.DeliveryId and e.[Type]=800 )
		and od.Channel != 'DAG'
order by q.DateSent

GO

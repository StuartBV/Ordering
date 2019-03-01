SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ordering_Raise_Invoice_Event]
as 
insert into Ordering_Events (DeliveryId, [Type], Channel, SupplierID, CreatedBy)
select q.DeliveryId, 800, od.Channel, od.SupplierId, 'sys'
from Queue_Queue q
inner join Ordering_Delivery od on od.Id=q.DeliveryId
left join Validator2.dbo.ClientSettings cs on od.InscoId=cs.InscoId
where
	not exists (select * from Ordering_Events e where e.DeliveryId=q.DeliveryId and e.[Type]=800 )
	and exists (select * from ORDERING_ProductFulfilmentTypes ft where ft.Id=od.ProductFulfilmentType and ft.ShouldSendInvoice=1)
	and od.SourceType not in (2, 4, 6)
	and q.DateSent > (select code from syslookup where tablename='Ordering_Raise_Invoice_Event' )
	and q.OOS=0
	and (od.ProductFulfilmentType not in (3, 8) or IsNull(cs.CashPaymentBankId, 0) > 0)
	and od.Channel != 'DAG'

-- Keep the date this was last run, used above for performance to avoid where datesent is not null and scanning the table
-- Just needs to find rows where the datesent has recently been updated
update syslookup set code= Convert(char(10),Cast(GetDate() as date),112), extracode=Convert(char(8),GetDate(),114)
where tablename='Ordering_Raise_Invoice_Event'

GO

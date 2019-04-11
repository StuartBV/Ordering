SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ordering_Invoice_Order_Insert]
@deliveryid int, 
@invoiceid int out
as
set nocount on
insert into Invoicing.dbo.Invoicing_Orders (CustomerId, SourceKey, SourceType, SupplierId, Reference, [Status], CountryId, CreatedBy, 
	Category, SupplierName, DeliveryId, OrderDate, OrderSentDate, Channel, InscoID, ExcessCollected)
select CustomerId, SourceKey, SourceType, SupplierId, Reference, [Status], CountryId, d.CreatedBy,
	Category, SupplierName, d.[Id], d.CreateDate, q.DateSent, d.Channel, d.InscoId, IsNull(c.Excess,0) Excess
from Ordering_Delivery d join Queue_Queue q on q.DeliveryId=d.[Id]
left join Ordering_Claims c on c.DeliveryId=d.id and c.ExcessCollectedByBV=1
where d.[Id]=@deliveryid
and not exists(select * from Invoicing.dbo.Invoicing_Orders i where i.DeliveryId=d.[Id])

select @invoiceid=Scope_Identity()

GO

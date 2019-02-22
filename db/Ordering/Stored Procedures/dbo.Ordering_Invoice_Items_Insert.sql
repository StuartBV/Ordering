SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Ordering_Invoice_Items_Insert]
@deliveryid int
as
insert into Invoicing.dbo.INVOICING_Items
	(OrderId,SourceKey,SourceType,ProductCode,Make,Model,PriceNet,[Status],VATRate,
	Installation,CreateDate,CreatedBy,AlteredDate,AlteredBy,Category,ItemReference,DeliveryItemId,DeliveryId,VatDeducted)
select
	o.id,di.SourceKey,di.SourceType,di.ProductCode,di.Make,di.Model,di.PriceNet,di.[Status],di.VATRate,
	Installation,di.CreateDate,di.CreatedBy,di.AlteredDate,di.AlteredBy,di.Category,di.ItemReference,di.itemid,od.id, isnull(di.VatDeducted,0)
from ORDERING_Delivery od 
join Invoicing.dbo.INVOICING_Orders o on o.Sourcetype=od.sourcetype and o.SourceKey=od.sourcekey and o.DeliveryId=od.Id
join ORDERING_DeliveryItems di on di.DeliveryId=@deliveryid
where od.id=@deliveryid and not exists(select * from INVOICING.dbo.INVOICING_Items i where i.deliveryitemid=di.itemid)


GO

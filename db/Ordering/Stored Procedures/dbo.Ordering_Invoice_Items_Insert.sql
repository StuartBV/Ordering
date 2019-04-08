SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ordering_Invoice_Items_Insert]
@deliveryid int
as
insert into Invoicing.dbo.INVOICING_Items
	(OrderId, SourceKey, SourceType, ProductCode, Make, Model, PriceNet, [Status], VATRate, 
	Installation, CreateDate, CreatedBy, AlteredDate, AlteredBy, Category, ItemReference, DeliveryItemId, DeliveryId, VatDeducted)

select
	di.deliveryid, di.SourceKey, di.SourceType, di.ProductCode, di.Make, di.Model, di.PriceNet, di.[Status], di.VATRate, 
	Installation, di.CreateDate, di.CreatedBy, di.AlteredDate, di.AlteredBy, di.Category, di.ItemReference, di.itemid, di.deliveryid, isnull(di.VatDeducted, 0)
from
ORDERING_DeliveryItems di
where di.DeliveryId=@deliveryId
and exists (select * from Invoicing.dbo.INVOICING_Orders o where o.DeliveryId=di.DeliveryId ) 
and not exists(select * from INVOICING.dbo.INVOICING_Items i where i.deliveryitemid=di.itemid)


GO

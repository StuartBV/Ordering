SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ordering_Invoice_ItemCharges_Insert]
@deliveryid int
as
insert into Invoicing.dbo.INVOICING_ItemCharges
(itemid,deliveryid,deliveryItemId,[Type],SupplierChargeId,Catnum,Description,PriceNet,VatRate,CreateDate,CreatedBy)

select i.ItemId,od.id,di.ItemId,[Type],SupplierChargeId,Catnum,Description,dic.PriceNet,dic.VatRate,getdate(),dic.CreatedBy
from ORDERING_Delivery od join Invoicing.dbo.INVOICING_Orders o on o.Sourcetype=od.sourcetype and o.SourceKey=od.sourcekey and o.DeliveryId=od.id	
join ORDERING_DeliveryItems di on di.DeliveryId=@deliveryid
join Invoicing.dbo.INVOICING_Items i on i.deliveryItemId=di.ItemId
join ORDERING_DeliveryItemCharges dic on dic.DeliveryItemId=di.ItemId
where od.id=@deliveryid and not exists(	select * from INVOICING.dbo.INVOICING_ItemCharges i where i.deliveryitemid=di.itemid)
GO

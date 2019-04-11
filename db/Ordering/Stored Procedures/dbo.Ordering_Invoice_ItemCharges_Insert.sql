SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ordering_Invoice_ItemCharges_Insert]
@deliveryid int
as
set nocount on
insert into Invoicing.dbo.Invoicing_ItemCharges (ItemId, DeliveryId, DeliveryItemId, [Type], SupplierChargeId, Catnum, [Description], PriceNet, VatRate, CreatedBy)

select i.ItemId, od.Id, di.ItemId, [Type], SupplierChargeId, Catnum, [Description], dic.PriceNet, dic.VatRate, dic.CreatedBy
from Ordering_Delivery od
join Invoicing.dbo.Invoicing_Orders o on o.SourceType=od.SourceType and o.SourceKey=od.SourceKey and o.DeliveryId=od.Id	
join Ordering_DeliveryItems di on di.DeliveryId=@deliveryid
join Invoicing.dbo.INVOICING_Items i on i.DeliveryItemId=di.ItemId
join Ordering_DeliveryItemCharges dic on dic.DeliveryItemId=di.ItemId
where od.Id=@deliveryid and not exists(select * from Invoicing.dbo.Invoicing_ItemCharges i where i.DeliveryItemId=di.ItemId)

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Sender_PowerplaySender_DeliveryItems_Insert]
@deliveryid int
as
insert into ppd3.dbo.Order_Powerplay_DeliveryItems(DeliveryId,ItemId,SourceKey,SourceType,ProductCode, Make,Model,PriceNet,[Status],
	VATRate,PriceGross,CreateDate,CreatedBy,AlteredDate,AlteredBy)
select DeliveryId,ItemId,SourceKey,SourceType,ProductCode,Make,Model,odi.SupplierCostPrice,[Status],
	VATRate,odi.SupplierGrossPrice,CreateDate,CreatedBy,AlteredDate,AlteredBy
from Ordering_DeliveryItems odi
where odi.DeliveryId=@deliveryid and not exists(select * from PPD3.dbo.Order_Powerplay_DeliveryItems p where p.DeliveryId=odi.DeliveryId and p.ItemId=odi.ItemId) 
GO

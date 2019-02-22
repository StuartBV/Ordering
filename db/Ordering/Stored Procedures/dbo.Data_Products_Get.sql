SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Data_Products_Get]
@orderid int
as
set nocount on
set transaction isolation level read uncommitted

select	 
		odi.ItemId OrderLineReference, 
		odi.SupplierCostPrice as UnitPrice,isnull(odi.RRP,0) RRP,
		odi.CreateDate as DateAddedToClaim,
		odi.ProductCode ProductID,	0 UpgradeAmount,
		case when od.ProductFulfilmentType=1 then 1 else 0 end as SendVouchers,
		0 UpgradeVatRate,	odi.vatrate ItemVatRate,	'' as ModelCode, 6 NULineStatus,
		odi.Make+' '+odi.model as ProductDesc
from dbo.ORDERING_Delivery od
join dbo.ORDERING_DeliveryItems odi on od.id=odi.DeliveryId
where od.id=@orderid

union --item charges

select	 
		odi.ItemId OrderLineReference, 
		odic.PriceNet UnitPrice,isnull(odic.RRP,0),
		odic.CreateDate as DateAddedToClaim,
		odic.Catnum ProductID,0 UpgradeAmount,
		case when od.ProductFulfilmentType=1 then 1 else 0 end as SendVouchers,
		0 UpgradeVatRate,	odic.vatrate ItemVatRate,'' as ModelCode, 6 NULineStatus,
		odic.[Description] as ProductDesc
from dbo.ORDERING_Delivery od
join dbo.ORDERING_DeliveryItems odi on od.id=odi.DeliveryId
join dbo.ORDERING_DeliveryItemCharges odic on odic.DeliveryItemId=odi.ItemId
where od.id=@orderid

GO

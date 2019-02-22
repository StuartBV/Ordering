SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Ordering_OrderValues] 
as

select	deliveryid, 
		sum(i.pricegross + isnull(x.ItemChargesGross,0)) PriceGross, 
		sum(i.PriceNet + isnull(x.ItemChargesNet,0)) PriceNet, 
		count(*) Items
from ORDERING_DeliveryItems i
left join (
	select c.DeliveryItemId as ItemId,
		   sum(c.PriceGross) as ItemChargesGross,
		   sum(c.PriceNet) as ItemChargesNet
	from ORDERING_DeliveryItemCharges c 
	group by c.Deliveryitemid
)x on i.itemid=x.ItemId
group by i.DeliveryId
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Ordering_ItemValues] as
select deliveryid, sum(i.pricegross + isnull(c.PriceGross,0)) PriceGross, sum(i.pricenet + isnull(c.PriceNet,0)) PriceNet,
	count(distinct i.itemid) Items
from ORDERING_DeliveryItems i
left join ORDERING_DeliveryItemCharges c on c.DeliveryItemId=i.ItemId
group by i.DeliveryId
GO

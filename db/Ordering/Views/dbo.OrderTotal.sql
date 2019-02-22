SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[OrderTotal] as

select i.deliveryid,i.pricenet + isnull(o.PriceNet,0) PriceGross,i.pricegross + isnull(o.PriceGross,0) PriceNet
 from
Ordering_ItemValues i
left join ORDERING_Delivery_Orders o on o.DeliveryId=i.deliveryid
GO

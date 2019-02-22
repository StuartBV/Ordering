SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[PowerplayStockRequired] as
-- NOTE
-- Until stock allocation can be made to work for V2 orders, we have to return all items that are in an order, not just the ones that need stock
-- as there is nothing which will indicate which items have stock (ie stock allocation!)

select  p.Distributor,p.prodid, x.PriceNet,x.VATRate,x.itemID,x.[status] from (
	select od.SupplierId,odi.ProductCode, odi.PriceNet,odi.VATRate, odi.ItemId,odi.[status]
	from QUEUE_Queue q join ORDERING_Delivery od on od.[id]=q.deliveryID
	join ORDERING_DeliveryItems odi on od.id=odi.DeliveryId
	where q.OOS=1 and odi.[status]=5 and od.SupplierId != 6504 --Buy It Direct (Aviva)
) x
left join (ppd3.dbo.products p join ppd3.dbo.productinventory pri on pri.prodid=p.prodid) on p.Distributor=x.SupplierId and p.catnum=x.ProductCode
where p.prodid is not null
GO

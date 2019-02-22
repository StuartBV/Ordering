SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Ordering_ProductList_View_Totals]
as

select pv.Deliveryid, sum(pv.productpriceincvat) as PoTotal, od.[status], 0 as partcancelled,
	isnull(od.category,'Unknown') as commodity, od.SupplierId, 'Ordering System' as OriginatingSystem 
from Ordering_Delivery od
join Ordering_productlist_view pv on pv.Deliveryid=od.DeliveryID
group by pv.Deliveryid,od.[status], od.OrderRef,od.SupplierId,od.Category
GO

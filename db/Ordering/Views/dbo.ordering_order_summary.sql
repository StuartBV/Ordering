SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[ordering_order_summary]
as

select  od.id as orderid,
		od.orderref,
		sum(pv.productpriceincvat) as pototal,
		od.[status],
		isnull(od.category,'unknown') as commodity,
		od.supplierid,
		od.altereddate,
		od.createdate
from ordering.dbo.ordering_delivery od
join ordering.dbo.ordering_productlist_view pv on pv.deliveryid=od.id
group by od.id, od.orderref, od.[status], isnull(od.category,'unknown'), od.supplierid,
od.altereddate, od.createdate
GO

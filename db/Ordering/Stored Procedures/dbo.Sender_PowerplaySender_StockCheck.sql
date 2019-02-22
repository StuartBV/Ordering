SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Sender_PowerplaySender_StockCheck]
@deliveryID int
as
declare @result int

select @result=case when count(*)=sum(free) then 0 else -1 end	-- 0=we have stock for all items, -1=error, not all items have stock so some require ordering
from (
	select case when QtyReq<=pri.QtyFree then 1 else 0 end Free
		 from (
			select od.SupplierId,odi.ProductCode,count(*) QtyReq
			from ORDERING_Delivery od
			join ORDERING_DeliveryItems odi on od.id=odi.DeliveryId
			where odi.DeliveryId=@deliveryID
			group by odi.ProductCode,od.SupplierId
		) x
		left join (ppd3.dbo.products p join ppd3.dbo.productinventory pri on pri.prodid=p.prodid) on p.Distributor=x.SupplierId and p.catnum=x.ProductCode
)z

return @result
GO

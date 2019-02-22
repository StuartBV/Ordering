SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Sender_PowerplaySender_Stock_Allocate]
@deliveryID int
as
update pri set
 pri.weballoc=pri.weballoc + case when pri.qtyfreeweb>=x.QtyRequired then x.QtyRequired else 0 end,
 pri.insalloc=pri.insalloc+case when pri.qtyfreeweb< x.QtyRequired and pri.qtyfreeins>=x.QtyRequired then x.QtyRequired else 0 end
from(
	select pri.prodid,count(*) QtyRequired
	from Ordering.dbo.ORDERING_Delivery od join Ordering.dbo.ORDERING_DeliveryItems odi on od.id=odi.DeliveryId
	left join ppd3.dbo.products p on p.Distributor=od.SupplierId and p.catnum=odi.ProductCode
	left join ppd3.dbo.ProductInventory pri on p.ProdID=pri.ProdID
	where od.id=@deliveryID
	group by pri.prodid
)x
join ppd3.dbo.ProductInventory pri on x.ProdID=pri.ProdID
GO

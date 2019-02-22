SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Sender_Email_Products_List]
@queueId int
as
set nocount on
set transaction isolation level read uncommitted

select v.Deliveryid,v.ProductCode,v.productmake,v.productmodel,v.productprice,v.productpriceincvat,v.productdeliveryprice,
	v.productinstallprice,v.productdisposalprice,v.productQty,v.VATRate
from 
QUEUE_Queue q
join ORDERING_ProductList_View v on v.Deliveryid=q.DeliveryId
where q.Id=@queueID
GO

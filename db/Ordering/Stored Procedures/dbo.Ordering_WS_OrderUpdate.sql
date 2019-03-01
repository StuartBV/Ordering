SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ordering_WS_OrderUpdate]
@deliveryid int,
@supplierref varchar(50)='Not Supplied',
@courierref varchar(50)=null,
@userID UserID ='sys.webservice',
@Force bit=0
as
set nocount on
update od set
	od.[Status]=20,
	od.SupplierRef=@supplierref,
	od.CourierRef=IsNull(@courierref,@supplierref),
	od.CourierID=24,
	od.AlteredDate=GetDate(),
	od.AlteredBy=@userID
from Ordering_Delivery od 
where od.Id=@deliveryid and (od.[Status]=5 or @Force=1)
	and not exists (select * from Ordering_DeliveryItems odi where odi.DeliveryId=@deliveryid and Status != 20) --Complete

GO

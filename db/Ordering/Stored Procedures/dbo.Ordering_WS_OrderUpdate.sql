SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Ordering_WS_OrderUpdate]
@deliveryid int,
@supplierref varchar(50)='Not Supplied',
@courierref varchar(50)=null,
@userID userid ='sys.webservice'
as
set nocount on
update od set
	od.[status]=20,
	od.supplierRef=@supplierref,
	od.courierRef=isnull(@courierref,@supplierref),
	od.courierID=24,
	od.altereddate=getdate(),
	od.alteredby=@userid
from ORDERING_Delivery od 
where od.Id=@deliveryid and od.[Status]=5
	and not exists (select * from  dbo.ORDERING_DeliveryItems odi where odi.DeliveryId=@deliveryid and status != 20) --Complete

GO

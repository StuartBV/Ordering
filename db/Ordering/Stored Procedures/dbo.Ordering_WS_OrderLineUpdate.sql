SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ordering_WS_OrderLineUpdate]
@deliveryid int,
@itemid int,
@status int,
@userID userid='sys.webservice'
as
set nocount on
update odi set
	odi.[status]=@status, 
	odi.altereddate=getdate(),
	odi.alteredby=@userid
from ORDERING_Delivery od join Ordering.dbo.ORDERING_DeliveryItems odi on odi.DeliveryId=od.id and odi.ItemId=@ItemId and odi.[Status]<=5
where od.ID=@deliveryId

GO

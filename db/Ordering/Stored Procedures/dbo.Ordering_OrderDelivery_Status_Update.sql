SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Ordering_OrderDelivery_Status_Update]
	@OrderDeliveryId int,
	@status tinyint,
	@userid userid,
	@itemId int = NULL,
	@trackingref varchar(30) = NULL
as
set nocount ON

update odi set
	[Status]=@status, 
	alteredby=@userid, 
	altereddate=getdate()
from ORDERING_DeliveryItems odi
where odi.DeliveryId=@orderdeliveryid and odi.itemId = COALESCE(@itemId,odi.itemId)

-- RB: 27/03/2014 update the associated checkout basket item
update cbi SET
Status = @status,
AlteredBy = @userid,
AlteredDate = GETDATE(),
TrackingRef = @trackingref
from Validator2.dbo.Checkout_BasketItems cbi join ORDERING_DeliveryItems odi ON cbi.BasketItemId=odi.SourceKey
where odi.ItemId = @itemId AND odi.sourcetype = 1

Update od set
	[Status]=odi.LowestStatus, -- RB: 27/03/2014 set the Ordering Delivery Status to the lowest status of any associated delivery item
	alteredby=@userid,
	altereddate=getdate()
from ORDERING_Delivery od JOIN 
(select MIN(odItem.Status) AS LowestStatus,odItem.DeliveryId 
from ORDERING_DeliveryItems odItem where odItem.DeliveryId = @orderdeliveryid
group by odItem.DeliveryId) odi
on od.DeliveryID=odi.DeliveryId
where od.id=@orderdeliveryid
GO

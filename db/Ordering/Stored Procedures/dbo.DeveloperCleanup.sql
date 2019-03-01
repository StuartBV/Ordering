SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[DeveloperCleanup]
@SourceType int
as

if (@SourceType<>14 and @SourceType<>15)
begin
	raiserror('Invalid SourceType value. Please provide 14 or 15, as all other values are reserved for the clients.', 17, 1)
	return 0
end

delete from sub
from Ordering_Cancellations sub
join Ordering_DeliveryItems odi on odi.ItemId=sub.DeliveryItemId
where odi.SourceType=@SourceType

delete from sub
from Ordering_CancellationLogs sub
join Ordering_DeliveryItems odi on odi.ItemId=sub.DeliveryItemId
where odi.SourceType=@SourceType

delete from sub
from Ordering_DeliveryItemCharges sub
join Ordering_DeliveryItems odi on odi.ItemId=sub.DeliveryItemId
where odi.SourceType=@SourceType

delete from sub
from Ordering_CashSettlements sub
join Ordering_Delivery od on od.DeliveryID=sub.Deliveryid
where od.SourceType=@SourceType

delete from sub
from Ordering_Address sub
join Ordering_Delivery od on od.DeliveryID=sub.DeliveryId
where od.SourceType=@SourceType

delete from sub
from Ordering_Address sub
join Ordering_Delivery od on od.DeliveryID=sub.DeliveryId
where od.SourceType=@SourceType

delete from sub
from Ordering_Delivery_Orders sub
join Ordering_Delivery od on od.DeliveryID=sub.DeliveryId
where od.SourceType=@SourceType

delete from sub
from Ordering_Events sub
join Ordering_Delivery od on od.DeliveryID=sub.DeliveryId
where od.SourceType=@SourceType

delete from sub
from Queue_Queue sub
join Ordering_Delivery od on od.DeliveryID=sub.DeliveryId
where od.SourceType=@SourceType


delete from Ordering_DeliveryItems
where SourceType=@SourceType

delete from Ordering_Delivery
where SourceType=@SourceType

-- NEVER use select *. You will never need all columns. Select what you NEED. Facepalm. See me
select odi.SourceType--, can.*
from Ordering_Cancellations can
join Ordering_DeliveryItems odi on odi.ItemId=can.DeliveryItemId
where odi.SourceType=@SourceType
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Sender_Manual_Send] 
@queueid int,
@userid userid='sender_manual_send'
as
set nocount on

-- Mark as confirmed as order will be processed manually

declare @deliveryid int

select @deliveryid=deliveryid
from QUEUE_Queue
where id=@queueid

exec ordering_OrderDelivery_Status_Update @OrderDeliveryId=@deliveryid, @status=20,@userid=@userid

GO

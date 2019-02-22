SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Paul Young
-- Create date: 24/9/2012
-- Description:	
-- =============================================
CREATE procedure [dbo].[Sender_WebService_OutOfStock]
@QueueId int
as
set nocount on

update Queue_Queue set 
	oos=1,
	altereddate=getdate(),
	alteredby='SP Sender_WebService_OutOfStock'
where id=@queueID

select d.Reference
from dbo.Queue_Queue q join dbo.Ordering_Delivery d on q.DeliveryId=d.DeliveryID
where q.Id=@QueueId
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[API_RemoveOrderCancellation]
@SourceKey int, 
@SourceType int,
@Userid UserID,
@Notes varchar(500),
@HandlerName varchar(50)
as
set nocount on

declare @ItemId int

select @ItemId=Max(ItemId)
from Ordering_DeliveryItems
where SourceType=@SourceType and SourceKey=@SourceKey

--select top 1 @ItemId=ItemId from Ordering_DeliveryItems where SourceType=@SourceType and SourceKey=@SourceKey order by DeliveryId desc

delete from Ordering_Cancellations
where DeliveryItemId=@ItemId

insert into Ordering_CancellationLogs (DeliveryItemId, [Status], HandlerName, Notes, CreatedBy)
select @ItemId, 9, @HandlerName, @Notes, @Userid
GO

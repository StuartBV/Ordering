SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[API_UpdateOrderCancellationStatus]
@SourceKey int, 
@SourceType int, 
@UserId UserID, 
@Reason varchar(200), 
@OtherInfo varchar(500), 
@HandlerName varchar(50), 
@CollectionFee decimal (5,2), 
@RestockingFee decimal (5,2), 
@Notes varchar(500), 
@CancellationStatus int
as
set nocount on

declare @ItemId int

select @ItemId=Max(ItemId)
from Ordering_DeliveryItems
where SourceType=@SourceType and SourceKey=@SourceKey

--select top (1) @ItemId=ItemId from Ordering_DeliveryItems where SourceType=@SourceType and SourceKey=@SourceKey order by DeliveryId desc

update Ordering_Cancellations set 
	[Status]=@CancellationStatus, 
	CollectionFee=@CollectionFee, 
	RestockingFee=@RestockingFee, 
	AlteredBy=@UserId, 
	AlteredDate=GetDate()
where DeliveryItemId=@ItemId

insert into Ordering_CancellationLogs (DeliveryItemId, [Status], HandlerName, Reason, OtherInfo, Notes, CollectionFee, RestockingFee, CreatedBy)
select @ItemId, @CancellationStatus, @HandlerName, @Reason, @OtherInfo, @Notes, @CollectionFee, @RestockingFee, @UserId


-- Never use select *. Do not pass go, do not collect £200. See me.
--select * from Ordering_CancellationLogs

GO

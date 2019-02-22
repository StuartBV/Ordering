SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[API_UpdateOrderCancellationStatus]
@SourceKey int, 
@SourceType int,
@Userid UserID,
@Reason varchar(50),
@OtherInfo varchar(500),
@HandlerName varchar(50),
@CollectionFee decimal (18,2),
@RestockingFee decimal (18,2),
@Notes varchar(500),
@CancellationStatus int
as
set nocount on

DECLARE @ItemId int

select top (1) @ItemId=ItemId from Ordering_DeliveryItems where SourceType=@SourceType AND SourceKey=@SourceKey ORDER BY DeliveryId DESC

update Ordering_Cancellations
set 
	Status = @CancellationStatus, 
	CollectionFee = @CollectionFee,
	RestockingFee = @RestockingFee,
	AlteredBy = @Userid,
	AlteredDate = GETDATE()
 where DeliveryItemId = @ItemId

insert into dbo.Ordering_CancellationLogs (DeliveryItemId, Status, HandlerName,Reason, OtherInfo, Notes, CollectionFee,RestockingFee,CreatedBy)
select @ItemId, @CancellationStatus, @HandlerName,@Reason,@OtherInfo,  @Notes,@CollectionFee,@RestockingFee, @Userid

select * from Ordering_CancellationLogs

GO

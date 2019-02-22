SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[API_CancelOrder]
@SourceKey int, 
@SourceType int,
@Userid UserID,
@Reason varchar(50),
@Condition varchar(50),
@OtherInfo varchar(500),
@HandlerName varchar(50),
@Email varchar(200)
as
set nocount on

DECLARE @ItemId int

select top (1) @ItemId=ItemId from Ordering_DeliveryItems where SourceType=@SourceType AND SourceKey=@SourceKey ORDER BY DeliveryId DESC

insert into Ordering_Cancellations (Reason, Condition, OtherInfo, Status, DeliveryItemId, CreatedBy, HandlerName, Email)
select @Reason, @Condition, @OtherInfo, 1, @ItemId, @Userid, @HandlerName, @Email

insert into dbo.Ordering_CancellationLogs (DeliveryItemId, Status, HandlerName, Reason, Condition, OtherInfo, CreatedBy)
select @ItemId, 1, @HandlerName, @reason,@Condition, @OtherInfo, @Userid
GO

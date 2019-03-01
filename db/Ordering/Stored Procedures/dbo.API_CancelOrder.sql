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

declare @ItemId int

select @ItemId=Max(ItemId)
from Ordering_DeliveryItems
where SourceType=@SourceType and SourceKey=@SourceKey

/* -- SD says what's wrong with using Max()?
select top (1) @ItemId=ItemId
from Ordering_DeliveryItems
where SourceType=@SourceType and SourceKey=@SourceKey
order by DeliveryId desc
*/

insert into Ordering_Cancellations (Reason, Condition, OtherInfo, [Status], DeliveryItemId, CreatedBy, HandlerName, Email)
select @Reason, @Condition, @OtherInfo, 1, @ItemId, @Userid, @HandlerName, @Email

-- Why is this table called Logs yet every other one of the 55,215 log tables aren't :-/ A "log" is implied to be plural
insert into Ordering_CancellationLogs (DeliveryItemId, [Status], HandlerName, Reason, Condition, OtherInfo, CreatedBy)
select @ItemId, 1, @HandlerName, @Reason,@Condition, @OtherInfo, @Userid
GO

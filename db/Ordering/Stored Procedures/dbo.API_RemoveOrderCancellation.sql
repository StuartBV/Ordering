SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[API_RemoveOrderCancellation]
@SourceKey int, 
@SourceType int,
@Userid UserID,
@Notes varchar(500),
@HandlerName varchar(50)
as
set nocount on

DECLARE @ItemId int

select top (1) @ItemId=ItemId from Ordering_DeliveryItems where SourceType=@SourceType AND SourceKey=@SourceKey ORDER BY DeliveryId DESC

DELETE FROM dbo.Ordering_Cancellations WHERE DeliveryItemId = @ItemId

insert into dbo.Ordering_CancellationLogs (DeliveryItemId, Status, HandlerName, Notes, CreatedBy)
select @ItemId, 9, @HandlerName, @Notes, @Userid
GO

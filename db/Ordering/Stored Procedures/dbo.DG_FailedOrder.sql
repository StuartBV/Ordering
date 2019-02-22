SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Paul Young
-- Create date: 5/10/2017
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[DG_FailedOrder] 
	@QueueId int,
	@PendingRef varchar(20)
AS
BEGIN
	SET NOCOUNT ON;

	declare @vno int, @retryCount int
	
	select @retryCount = RetryCount 
	from dbo.Queue_Queue
	where Id = @QueueId

	if @retryCount < 4
		return
	
	select @vno = Vno 
	from VALIDATOR2.dbo.DG_Plan 
	where OrderRef = @PendingRef
	
	update VALIDATOR2.dbo.DG_Plan
	set StatusCode = 4
	where Vno = @vno
	
	update VALIDATOR2.dbo.Validations
	set VStatus = 4, ItemType = 'Pending Orders'
	where Vno = @vno
END
GO

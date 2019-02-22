SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Paul Young
-- Create date: 6/10/2016
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[DG_UpdatePlan] 
	@PendingRef varchar(20), 
	@SalesDocumentNumber varchar(50),
	@EstimatedDeliveryDate datetime
AS
BEGIN
	--update VALIDATOR2.dbo.DG_Plan
	--set OrderRef = @SalesDocumentNumber,
	--EstimatedDeliveryDate = @EstimatedDeliveryDate,
	--StatusCode = 20
	--where OrderRef = @PendingRef

	declare @vno int, @reason varchar(1000), @userid UserID = 'OrderingService.HughesDAGOrderSender'

	select @vno = p.vno, @reason = 'OrderingService - HughesDAGOrderSender - Set OrderRef as: ' + @SalesDocumentNumber + ', StatusCode: 20, EstimatedDeliveryDate: ' + cast(@EstimatedDeliveryDate as varchar)
	from VALIDATOR2.dbo.DG_Plan p 
	where p.OrderRef = @PendingRef

	exec validator2.dbo.DG_UpdatePlan @Vno = @vno, @OrderRef = @SalesDocumentNumber, @EstimatedDeliveryDate = @EstimatedDeliveryDate, @StatusCode = 20, @reason = @reason, @UserId = @userid

END

GO

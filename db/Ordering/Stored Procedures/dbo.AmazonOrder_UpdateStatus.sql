SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AmazonOrder_UpdateStatus] 
@DeliveryId int , @basketId int
AS
begin
	declare @Status int = 20
	-- Update amazon order status to be completed once amazon GC has been sent
	
	update dbo.Checkout_BasketItems set [Status] = @Status 
	where BasketItemId = @basketId

	update dbo.Ordering_Delivery set [Status] = @Status 
	where DeliveryID = @DeliveryId

	update dbo.Ordering_DeliveryItems set [Status] = @Status 
	where DeliveryId = @DeliveryId
end 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Data_OrderDetails_Get]
	@orderId int
AS
SET NOCOUNT ON

exec DATA_Guid_Set @orderId=@orderId, @userid='SYS'
exec DATA_Delivery_Get @orderId=@orderId
exec DATA_Customer_Get @orderId=@orderId
exec DATA_Claim_Get @orderId=@orderId
exec DATA_Products_Get @orderId=@orderId

--// Update any totals here?

GO

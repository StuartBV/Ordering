SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Sender_PowerplaySender_Send]
@queueid int
as
set nocount on
set xact_abort on

declare @deliveryid int, @error int

select @deliveryid=DeliveryId from QUEUE_Queue where [id]=@queueid

exec @error=SENDER_PowerplaySender_StockCheck @deliveryID

if @error=0	-- All stock is available therefore place order
begin
	begin tran
	exec Sender_PowerplaySender_Stock_Allocate				@deliveryid=@deliveryid
	exec Sender_PowerplaySender_Delivery_Insert				@deliveryid=@deliveryid
	exec Sender_PowerplaySender_DeliveryItems_Insert	@deliveryid=@deliveryid
	exec Sender_PowerplaySender_Customer_Insert			@deliveryid=@deliveryid
	exec Sender_PowerplaySender_Address_Insert				@deliveryid=@deliveryid
	commit tran
		return 0
end
else
begin
	-- OOS rows are considered by CMS Purchase Orders by way of the view PowerplayStockRequired
	-- When a PO is confirmed the item status is set to 15 to indicate item is ordered
	update QUEUE_Queue set 
	oos=1,
	altereddate=getdate(),alteredby='Sender_PowerplaySender_Send'
	where id=@queueID
	return -1
end
GO

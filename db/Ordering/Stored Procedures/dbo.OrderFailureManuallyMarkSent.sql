SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[OrderFailureManuallyMarkSent]
@DeliveryId int,
@UserId UserID
as
set nocount on
-- Force failed delivery through to raise invoice

update Queue_Queue set
	RetryCount=0,
	DateSent=GetDate(),
	AlteredBy=@UserId,
	AlteredDate=GetDate(),
	SysComments='Delivery manually confirmed'
where DeliveryId=@DeliveryId and DateSent is null

exec Ordering_Raise_Invoice_Event

exec Ordering_ManualPOConfirm	@deliveryID=@DeliveryId, @userID=@UserId, @supplierref='OrderFailureManuallyMarkSent', @courierref='Manual', @Force=1
GO

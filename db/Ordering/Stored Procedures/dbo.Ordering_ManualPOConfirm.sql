SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ordering_ManualPOConfirm]
@deliveryID varchar(10),
@userID UserID,
@supplierref varchar(50)='Manual',
@courierref varchar(50)='Manual',
@Force bit=0
as
set nocount on

if exists (select * from Ordering_Delivery where ([Status]=5 or @Force=1) and Id=@deliveryID)
begin

	update Ordering_DeliveryItems set
		[Status]=20,
		AlteredDate=GetDate(),
		AlteredBy=@userID
	where DeliveryId=@deliveryID
	
	exec ORDERING_WS_OrderUpdate @deliveryid=@deliveryID, @supplierref=@supplierref,@courierref=@courierref, @userID=@userID, @Force=@Force
	
end
else
begin
	raiserror('The order is not currently Waiting Confirmation',15,1)
end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create Procedure [dbo].[Ordering_ManualPOConfirm]
@deliveryID varchar(10),
@supplierref varchar(50)='',
@courierref varchar(50)='',
@userID varchar(20)
AS
set nocount on

if exists (select * from ORDERING_Delivery where [status]=5 and [id]=@deliveryID)
begin

	update ORDERING_DeliveryItems set
		status=20,
		altereddate=getdate(), AlteredBy=@userID
	where DeliveryId=@deliveryID
	
	exec ORDERING_WS_OrderUpdate @deliveryid=@deliveryID, @supplierref=@supplierref,@courierref=@courierref, @userID=@userID
	
end
else
begin
	raiserror('The order is not currently Waiting Confirmation',15,1)
end


GO

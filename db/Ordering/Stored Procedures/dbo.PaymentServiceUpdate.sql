SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[PaymentServiceUpdate]
@guid varchar(38),
@success bit
as

set xact_abort on
declare @deliveryid int

IF @success = 1
begin
	begin tran
		select @deliveryid=Id from Ordering_Delivery where Guid=@guid

		update Ordering_Delivery set Status=20, AlteredDate=getdate(), AlteredBy='sys.paymentservice'
		where Id=@deliveryid

		update Ordering_DeliveryItems set Status=20, AlteredDate=getdate(), AlteredBy='sys.paymentservice'
		where DeliveryId=@deliveryid

	COMMIT
end
GO

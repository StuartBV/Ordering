SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PaymentServiceUpdate]
@guid varchar(36),
@success bit
as

set xact_abort on
declare @deliveryid int

if @success=1
begin
	select @deliveryid=Id from Ordering_Delivery where [Guid]=@guid

	begin tran
		update Ordering_Delivery set
			[Status]=20,
			AlteredDate=GetDate(),
			AlteredBy='sys.paymentservice'
		where Id=@deliveryid

		update Ordering_DeliveryItems set
			[Status]=20,
			AlteredDate=GetDate(),
			AlteredBy='sys.paymentservice'
		where DeliveryId=@deliveryid
	commit
end

GO

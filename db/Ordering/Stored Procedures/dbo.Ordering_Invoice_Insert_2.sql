SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Ordering_Invoice_Insert_2]
@DeliveryID int
as

set xact_abort on
set nocount on
--set transaction isolation level read uncommitted

declare @invoiceid int

begin tran

	exec ORDERING_Invoice_Order_Insert @deliveryid=@deliveryid, @invoiceid=@invoiceid out
	
	exec ORDERING_Invoice_Order_Charges_Insert @deliveryid=@deliveryid
	
	exec ORDERING_Invoice_Items_Insert @deliveryid=@deliveryid	

	exec ORDERING_Invoice_ItemCharges_Insert @deliveryid=@deliveryid

	exec ORDERING_Invoice_Customer_Insert @deliveryid=@deliveryid	,@invoiceid=@invoiceid

	exec ORDERING_Invoice_Address_Insert @deliveryid=@deliveryid
	
	update ordering_delivery
	set MarkedForInvoiceDate=getdate()
	where id=@deliveryID

commit tran
GO

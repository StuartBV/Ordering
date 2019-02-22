SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Batch_Order_Send_Amazon]
@userid userid ='sys.process'
as
set nocount on
--Not 100% convinced this is actually used mp - 09/08/2012
exec BATCH_Order_Send	@supplierid=6502,@path='\\Exciton\ITReports\AmazonVoucherOrders',@userid=@userid
GO

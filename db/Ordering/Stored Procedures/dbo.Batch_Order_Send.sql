SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Batch_Order_Send]
@supplierid int,
@path varchar(100),
@userid userid
as
set nocount on
declare @batchid int, @filename varchar(50), @file varchar(100),@sql varchar(255),@bcpcmd varchar(512),@FileSequenceNo char(9)

select @FileName=[filename]
from BATCH_Supplier_Config
where SupplierId=@SupplierID

if @filename is null
begin
	raiserror('Supplier not setup in BATCH_Supplier_Config table',18,1)
	return
end	


if exists(select * from BATCH_Orders bo where bo.DateSent is null and bo.SupplierId=@supplierid)
begin
	exec @batchid=BATCH_Order_Create @userid=@userid, @supplierid=@supplierid

	if exists(select * from BATCH_Order_Data d where d.batchid=@batchid and (isnull(d.Email,'')='' or isnull(d.amount,0)<1)	)
	begin
		raiserror('BATCH FILE ORDER ERROR: Zero/Negative PoTotal values or No Email address exists for the next file to be sent.',18,1)
		return
	end


	select @FileSequenceNo=replicate('0',9-len(@batchid)) + cast(@batchid as varchar), @file = @Filename + @FileSequenceNo +'.csv',
		@path=@path+case when ppd3.dbo.ServerType()!='Live' then '\TEST' else '' end+'\'

	exec BATCH_Order_File_Export @batchid=@batchid,@userid =@userid,@supplierid=@supplierid,@file=@file,@path=@path
	exec BATCH_Order_Email_Send	@batchid=@batchid,@userid =@userid,@supplierid=@supplierid,@file=@file,@path=@path
	exec BATCH_Order_Email_SendToCustomer @batchid=@batchid, @supplierid=@supplierid
	exec BATCH_Order_MarkAsSent	@batchid=@batchid
end
GO

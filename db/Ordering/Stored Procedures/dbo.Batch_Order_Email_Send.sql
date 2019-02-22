SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Batch_Order_Email_Send]
@batchid int,
@userid userid='sys.process',
@supplierid int,
@file varchar(100),
@path varchar(100)
as
set nocount on
set transaction isolation level read uncommitted

declare @now datetime=getdate(),@Recipient varchar(200),@subject varchar(200),@body varchar(500),
	@orderfilepath varchar(200),@SenderName varchar(200),@bcc varchar(200),@senderemail varchar(200)

select @subject=SenderCompanyName + ' Order: ' + @file,
	@orderfilepath = @path + @file,
	@body='Please find attached Order for ' + cast(@now as varchar),
	@SenderName=SenderCompanyName,
	@bcc=case ppd3.dbo.ServerType()
		when 'Live' then 'itsupport@bevalued.co.uk' + 
			case when @supplierid=6502 then ';lisa.irons@bevalued.co.uk' else '' end --35954 - very badly added Lisa Irons to amazon batch order emails
		else 'dev-system@bevalued.co.uk' end,
	@SenderEmail=SenderEmail
from BATCH_Supplier_Config
where SupplierId=@supplierid

select @Recipient=d.DFEmail
from ppd3.dbo.Distributor d
where d.id=@supplierid

exec ppd3.dbo.SendMail @Recipient=@Recipient, @SenderEmail=@SenderEmail, @SenderName=@SenderName, @Subject=@subject, @Body=@body,  @attach=@orderfilepath, @bcc=@bcc
GO

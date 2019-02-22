SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Batch_Order_Email_SendToCustomer]
@Batchid int,
@supplierid int
as

declare @SendCustomerEmail bit, @Email varchar(300), @fromEmail varchar(200),@fromname varchar(200),
	@attachment varchar(200),@body varchar(max),@subject varchar(200),@EmailSubject varchar(200)

select @SendCustomerEmail=SendCustomerEmail, @fromEmail=CustomerEmailFromAddress, @fromName=CustomerEmailFromName,
@Attachment=ppd3.dbo.LocalPath() + 'Documents\' + CustomerEmailAttachment,
@body=CustomerEmailBody, @subject=CustomerEmailSubject
from Batch_Supplier_Config
where SupplierId=@supplierid

if @SendCustomerEmail=1
begin
	--Get all the emails into a tmp table
	create table #t (Email varchar(200), EmailSent bit, EmailSubject varchar(200))
	
	insert into #t (Email, EmailSent, EmailSubject)
	select d.Email, 0, replace(@subject,'<InsuranceClaimNo>',od.Reference)
	from Batch_Orders o join Batch_Order_Data d on d.BatchId=o.BatchId
	join Ordering_Delivery od on od.Id=o.DeliveryId
	where o.BatchId=@Batchid and o.DateSent is null
	
	while exists (select * from #t where EmailSent=0)
	begin
		select top 1 @Email=Email, @EmailSubject=EmailSubject 
		from #t where EmailSent=0
		
		exec ppd3.dbo.SendMail @Recipient=@email, @SenderEmail=@fromEmail, @SenderName=@fromName, @Subject=@EmailSubject, @Body=@body, @attach=@attachment
		
		update #t set EmailSent=1 
		where Email=@Email and EmailSent=0
	end
end
GO

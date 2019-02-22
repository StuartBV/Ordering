SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Sender_Email_Data_Get]
@queueId int
as
set nocount on
set transaction isolation level read uncommitted

declare @cr char(1)=char(10),@employeename varchar(100),@customername varchar(100),@customeremail varchar(200), @deliveryId int,
	@suppliername varchar(100),@employeeemail varchar(200),@poref varchar(40),@accountno varchar(50),
	@recipientemail varchar(200), @supplieremail varchar(200), @productfulfilmenttype varchar(500), @servertype varchar(20)=ppd3.dbo.serverType()

select @deliveryId=q.DeliveryId
from QUEUE_Queue q
where q.Id=@queueid

select @customername=isnull(cu.[Title]+' ','')+isnull(cu.[Forename]+' ','')+isnull(cu.[Surname],''),
	@customeremail=cu.[EmailAddress],
	@suppliername =isnull(d.[name],''),
	@employeename=isnull(e.FName+' '+e.sname,od.CreatedBy), 
	@employeeemail=coalesce(nullif(e.WEmail, ''),e.FName+'.'+e.sname+'@BeValued.co.uk' ,'noreply@bevalued.co.uk'), 
	@poref=od.orderref,
	@accountno=isnull('Account No: '+isnull(od.AccountNo,d.accountno),''),
	@supplieremail= d.DFEmail,
	@recipientemail= d.DFEmail, -- this could be overwritten below, but still need to get it out here.
	@productfulfilmenttype=isnull(sl.[description],'Unknown Type')
from ORDERING_Delivery od join ORDERING_Customer cu on cu.id=od.CustomerId
join ORDERING_Address a on a.DeliveryId=od.id
join ppd3.dbo.Distributor d on d.id=od.SupplierId
left join ppd3.dbo.Logon l on l.UserID=od.CreatedBy
left join ppd3.dbo.employees e on e.id=l.UserFK
left join syslookup sl on sl.code=od.productfulfilmenttype and sl.tablename='ProductFulfilmentTypes'
where od.id=@deliveryId

-- Put Dev Testing redirect in here
select @recipientemail=case when @serverType='Live' then @supplieremail else sl.[description] 	end
from ppd3.dbo.syslookup sl
where sl.tablename='EmailRedirect' and sl.code=@serverType

-- Standard email data

select @employeename SenderName, @employeeemail SenderEmail,
	'POWERPLAY PURCHASE ORDER ('+@suppliername+'): '+@customername+' PO REF: '+@poref+ ' Type: '+@productfulfilmenttype [Subject], 
	'PurchaseOrder' TemplateFileName, 
	cast(0 as bit) HtmlEmail
	
if (isnull(@recipientemail,'')='')
begin
	raiserror('No email address configured for Ordering Email',18,1)
	return
end

select @recipientemail Email, 1 EmailType -- TO
union 
select EmailAddress as Email, RecipientType as EmailType
from dbo.SENDER_Email_AdditionalRecipients r
where r.ServerType=@servertype

select '' [PathToAttachment] where 1=0

exec SENDER_Email_Tokens_Get @queueId=@queueid

GO

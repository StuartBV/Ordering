SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Ordering_Invoice_Customer_Insert]
@deliveryid int,
@invoiceId int
as

set nocount on
declare @customerid int

insert into Invoicing.dbo.INVOICING_Customer(Title,Forename,Surname,EmailAddress,MobilePhone,DaytimePhone,EveningPhone,CreatedBy,InvoiceId,DeliveryId)
select Title,Forename,Surname,EmailAddress,MobilePhone,DaytimePhone,EveningPhone,c.CreatedBy,@InvoiceId,	d.id
FROM dbo.ORDERING_Delivery d
join ordering.dbo.ORDERING_Customer c on c.id=d.customerid
where d.id=@deliveryid
and not exists(
	select * from Invoicing.dbo.INVOICING_Customer ic where ic.deliveryId=d.id)

set @customerid=scope_identity()

update o set o.customerid=@customerid
from dbo.ORDERING_Delivery od
join Invoicing.dbo.INVOICING_Orders o on 
	o.SourceKey=od.SourceKey
	and o.SourceType=od.SourceType
where od.id=@deliveryid

GO

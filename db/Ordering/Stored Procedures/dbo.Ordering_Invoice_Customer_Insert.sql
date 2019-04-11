SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ordering_Invoice_Customer_Insert]
@deliveryid int, 
@invoiceId int
as
set nocount on
declare @customerid int

insert into Invoicing.dbo.Invoicing_Customer(Title, Forename, Surname, EmailAddress, MobilePhone, DaytimePhone, EveningPhone, CreatedBy, InvoiceId, DeliveryId)
select Title, Forename, Surname, EmailAddress, MobilePhone, DaytimePhone, EveningPhone, c.CreatedBy, @invoiceId, d.Id
from Ordering_Delivery d
join Ordering.dbo.Ordering_Customer c on c.Id=d.CustomerId
where d.Id=@deliveryid
and not exists(select * from Invoicing.dbo.Invoicing_Customer ic where ic.DeliveryId=d.Id)

set @customerid=Scope_Identity()

update o set o.CustomerId=@customerid
from Ordering_Delivery od
join Invoicing.dbo.Invoicing_Orders o on o.SourceKey=od.SourceKey and o.SourceType=od.SourceType
where od.Id=@deliveryid

GO

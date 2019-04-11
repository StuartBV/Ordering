SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ordering_Invoice_Address_Insert]
@deliveryid int
as
set nocount on
insert into Invoicing.dbo.Invoicing_Address(Address1, Address2, Town, County, Country, Postcode, ContactTel, CreatedBy, OrderId, DeliveryId)

select Address1, Address2, Town, County, Country, Upper(Postcode), ContactTel, a.CreatedBy, o.Id, d.Id
from Ordering_Address a join Ordering_Delivery d on a.DeliveryId=d.Id
join Invoicing.dbo.Invoicing_Orders o on o.SourceKey=d.SourceKey and o.SourceType=d.SourceType and o.DeliveryId=d.Id
where a.DeliveryId=@deliveryid
and not exists(select * from Invoicing.dbo.Invoicing_Address a where a.DeliveryId=d.Id)

GO

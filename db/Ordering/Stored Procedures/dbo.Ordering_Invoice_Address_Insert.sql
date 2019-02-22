SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ordering_Invoice_Address_Insert]
@deliveryid int
as
insert into invoicing.dbo.INVOICING_Address(Address1,Address2,Town,County,Country,Postcode,ContactTel,CreatedBy,OrderId,deliveryid)

select Address1,Address2,Town,County,Country,upper(Postcode),ContactTel,a.CreatedBy,o.id,d.id
from ORDERING_Address a join ORDERING_Delivery d on a.DeliveryId=d.Id
join invoicing.dbo.INVOICING_Orders o on o.SourceKey=d.SourceKey and o.SourceType=d.SourceType and o.DeliveryId=d.Id
where a.DeliveryId=@deliveryid
and not exists(select * from invoicing.dbo.INVOICING_Address a where a.deliveryid=d.id)
GO

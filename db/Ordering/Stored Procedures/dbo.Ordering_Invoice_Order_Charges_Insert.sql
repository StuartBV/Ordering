SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ordering_Invoice_Order_Charges_Insert]
@deliveryid int
as
insert into Invoicing.dbo.INVOICING_Order_Charges (InvoiceId,FulfilmentType,ServiceCode,PriceNet,VatRate,CreateDate,CreatedBy,DeliveryId)
select o.Id,do.FulfilmentType, isnull(do.ServiceCode,0),do.PriceNet,do.VatRate,getdate(),d.CreatedBy,d.id
FROM ORDERING_Delivery d join Invoicing.dbo.INVOICING_Orders o on o.DeliveryId=d.id
join ORDERING_Delivery_Orders do on do.DeliveryId=d.id
where d.id=@deliveryid and not exists(select * from Invoicing.dbo.INVOICING_Order_Charges ioc1 where ioc1.deliveryid=d.id)
and d.supplierid != 6665 -- SVM John Lewis no order charge

GO

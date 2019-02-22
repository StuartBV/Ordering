SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ordering_Invoice_Order_Insert]
@deliveryid int,
@invoiceid int out
as

insert into Invoicing.dbo.Invoicing_Orders (CustomerId,SourceKey,SourceType,SupplierId,Reference,[Status],CountryId,CreateDate,CreatedBy,
	Category,suppliername,DeliveryId,OrderDate,OrderSentDate,channel,InscoID)
select CustomerId,SourceKey,SourceType,SupplierId,Reference,[Status],CountryId,getdate(),d.CreatedBy, Category,suppliername,d.[id],d.CreateDate,q.DateSent,d.channel,d.InscoID
FROM Ordering_Delivery d join Queue_Queue q on q.DeliveryId=d.[id]
where d.[id]=@deliveryid and not exists(select * from Invoicing.dbo.Invoicing_Orders io1 where io1.deliveryid=d.[id])

select @invoiceid=scope_identity()
GO

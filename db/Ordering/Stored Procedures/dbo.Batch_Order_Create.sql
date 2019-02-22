SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Batch_Order_Create]
@userid userid,
@supplierid int
as
set nocount on
set transaction isolation level read uncommitted

declare @now datetime, @batchid int
set @now=getdate()

--// insert header row and get batch id

insert into BATCH_Files(SupplierId,CreatedBy,CreateDate)
select @SupplierId,@userid,@now

set @batchid=scope_identity()

update bo set bo.batchid=@batchid
from BATCH_Orders bo
where bo.DateSent is null
and bo.SupplierId=@supplierid

--// Retrieve data for file

insert into BATCH_Order_Data(batchid, PoRef, Email,
				[Message], [To], [From], [Amount], 
				createdby, createdate)
select bo.batchid, d.orderref, isnull(c.EmailAddress,''),
		cfg.FileMessage, c.name, cfg.FileCompanyName, cast(ov.PriceGross as varchar), 
		@userid, @now
from BATCH_Orders bo
join BATCH_Supplier_Config cfg on cfg.SupplierId=bo.SupplierId
join ORDERING_Delivery d on d.Id=bo.DeliveryId
join ORDERING_Customer c on c.Id=d.CustomerId
join Ordering_OrderValues ov on ov.deliveryid=bo.DeliveryId
where bo.batchid=@batchid
and not exists(
	SELECT * FROM BATCH_Order_Data bod
	where bod.poref=d.OrderRef
)

return @batchid
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[MissingStockDetail]
@deliveryid int,
@result varchar(max) output
as
set nocount on
set transaction isolation level read uncommitted

declare @productlist varchar(1000)=''
set @result=''

select @productlist=@productlist + odi.ProductCode + ': '+ odi.Make + ' - ' + odi.Model + char(10)
from dbo.ORDERING_DeliveryItems odi
where odi.DeliveryId=@deliveryId

select @result='DeliveryId: '+ cast(od.Id as varchar(20)) + char(10) +
	'Ref: ' + od.Reference + char(10) + 
	'QueueId: ' + cast(q.ID as varchar(20)) + char(10) + 
	'Supplier: '+ d.Name + char(10) + 
	'Product List:
	'+ @productlist
from ordering.dbo.ORDERING_Delivery od
join ordering.dbo.QUEUE_Queue q on q.DeliveryId=od.Id
join ppd3.dbo.Distributor d on d.Id=od.SupplierId
where od.Id=@deliveryid

select @result

GO

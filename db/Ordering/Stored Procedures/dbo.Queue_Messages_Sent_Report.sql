SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Queue_Messages_Sent_Report]
@date datetime=null 
AS
set xact_abort on
set nocount on

declare @datefrom datetime,@dateto datetime, @now datetime

set @now=getdate()
set @datefrom=cast(convert(char(10),isnull(@date,@now-1),103) as datetime)
set @dateto=dateadd(dd,1,@datefrom)

select	distinct q.Id as QueueId, 
		q.DeliveryId,
		od.SupplierId,
		isnull(od.SupplierName,'Unknown Supplier') as SupplierName,
		isnull(cast(isnull([cos].Id,0) as varchar),'') as SenderId,
		isnull([cos].Name,'Powerplay DF (No Sender)') SentByMethod,
		isnull(od.Reference,'') Reference,
		od.OrderRef,
		isnull(oc.Forename,'') + ' ' + isnull(oc.Surname,'') as CustomerName,
		isnull(oa.PostCode,'') as PostCode,
		isnull(od.channel,'Unknown Hub') as Hub,
		isnull(od.category,'Unknown Category') as ProductOrderType,
		isnull(sys.Description,'Unknown Product Fulfilment Type') as ProductFulfilmentType,
		isnull(convert(char(10),od.CreateDate,103) + ' ' + convert(char(8),od.CreateDate,108),'') as OrderCreated,
		isnull(od.CreatedBy,'') OrderCreatedBy,
		isnull(convert(char(10),q.DateSent,103) + ' ' + convert(char(8),q.DateSent,108),'') as DateSent,
		isnull(convert(char(10),q.LastRetryAttempt,103) + ' ' + convert(char(8),q.LastRetryAttempt,108),'') as LastRetryAttempt
from ordering.dbo.QUEUE_Queue q
join ordering.dbo.ORDERING_Delivery od on od.id=q.deliveryid
left join ordering.dbo.ORDERING_Address oa on oa.DeliveryId=od.id
left join ordering.dbo.ORDERING_Customer oc on oc.Id=od.CustomerId
left join ordering.dbo.OrderSenders_Config [osc] on [osc].Id=ordering.dbo.OrderSenders_ConfigId_Get(q.Id) 
left join ordering.dbo.CONFIG_OrderSenders [cos] on [cos].Id=osc.OrderSenderId
left join ordering.dbo.sysLookup sys on sys.TableName='ProductFulfilmentTypes' and sys.code=od.ProductFulfilmentType
where (q.DateSent between @datefrom and @dateto or q.LastRetryAttempt between @datefrom and @dateto)

GO

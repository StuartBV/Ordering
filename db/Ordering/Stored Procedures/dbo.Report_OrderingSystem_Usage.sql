SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Report_OrderingSystem_Usage]
@from varchar(10),
@to varchar(10),
@channel varchar(50)=''
as
set nocount on
set dateformat dmy

declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

select distinct q.Id as QueueId, q.DeliveryId, od.SupplierId,
	isnull(od.SupplierName,'Unknown Supplier') as SupplierName,
	isnull(cast(isnull(os.Id,0) as varchar),'') as SenderId,
	isnull(os.Name,'Powerplay DF (No Sender)') SentByMethod,
	isnull(od.Reference,'') Reference,
	od.OrderRef,
	isnull(oc.Forename,'') + ' ' + isnull(oc.Surname,'') as CustomerName,
	isnull(oa.Postcode,'') as PostCode,
	isnull(od.Channel,'Unknown Hub') as Hub,
	isnull(od.Category,'Unknown Category') as ProductOrderType,
	isnull(sl.[Description],'Unknown Product Fulfilment Type') as ProductFulfilmentType,
	isnull(convert(char(10),od.CreateDate,103) + ' ' + convert(char(8),od.CreateDate,108),'') as OrderCreated,
	COALESCE(cb.CreatedBy,ISNULL(od.CreatedBy,'')) OrderCreatedBy, --COALESCE Added by LI Atom: 68144
	isnull(convert(char(10),q.DateSent,103) + ' ' + convert(char(8),q.DateSent,108),'') as DateSent,
	isnull(convert(char(10),q.LastRetryAttempt,103) + ' ' + convert(char(8),q.LastRetryAttempt,108),'') as LastRetryAttempt,
	isnull(ou.Name,'Unknown') OUName
from Queue_Queue q
inner join Ordering_Delivery od on od.Id=q.DeliveryId and od.SourceType=1
left join Ordering_Address oa on oa.DeliveryId=od.Id
left  join Ordering_Customer oc on oc.Id=od.CustomerId
--left join OrderSenders_Config osc on osc.Id=dbo.OrderSenders_ConfigId_Get(q.Id) --OMG this sucks!!
--left join Config_OrderSenders os on os.Id=osc.OrderSenderId
left join sysLookup sl on sl.TableName='ProductFulfilmentTypes' and sl.Code=od.ProductFulfilmentType
left join SSO_User u on u.Username=od.CreatedBy
left join SSO_OrganisationalUnit ou on ou.Id=u.OrganisationalUnitId
LEFT JOIN validator2.dbo.Checkout_Baskets cb ON cb.InsuranceClaimNo = od.Reference --Added by LI Atom: 68144
outer apply( -- SD added this in to replace the gratuitous use of inline function above, now removed. report now 1000 x faster.
	select os.Name, os.Id
	from Config_OrderSenders os
	where os.Id=(
		select top 1 OrderSenderId 
		from OrderSenders_Config c
		where isnull(nullif(c.SupplierId,0),od.SupplierId)=od.SupplierId and isnull(nullif(c.ProductFulfilmentType,0),od.ProductFulfilmentType)=od.ProductFulfilmentType
		order by case when c.ProductFulfilmentType=od.ProductFulfilmentType then power(2,1) else 0 end + case when c.SupplierId=od.SupplierId then power(2,0) else 0 end desc
	)
)os
where (q.DateSent between @fd and @td or q.LastRetryAttempt between @fd and @td)
and (od.Channel=@channel or @channel='') 
option(force order)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[CashSettlement_Get]
@QueueId int
as

set nocount on

update od set Guid=newid() from dbo.Ordering_Delivery od
join dbo.Queue_Queue qq on qq.DeliveryId = od.DeliveryID
where qq.Id=@QueueId and od.Guid is null

select	cs.BankId,
		od.Guid,
		cs.PayeeName,
		cs.BankSortCode,
		cs.BankAccountNo,
		od.SourceKey as SourceSystemRef,
		c.InsuranceClaimNo,
		c.InsurancePolicyNo,
		od.Channel,
		case when od.SourceType not in (1,2,3,4,6) then 6 else od.SourceType end as OriginatingSystem,
		cs.Amount
from Queue_Queue q
join Ordering_Delivery od on od.Id=q.DeliveryId
join Ordering_Claims c on c.DeliveryId=od.Id
join Ordering_CashSettlements cs on cs.DeliveryId=od.Id
where q.Id=@QueueId

GO

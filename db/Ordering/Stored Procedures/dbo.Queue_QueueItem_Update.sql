SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Queue_QueueItem_Update]
@QueueID int,
@Success bit
as
set nocount on
set transaction isolation level read committed

declare @now datetime

select @now=getdate()

--// Update Queue
update q set 
	q.[DateSent]=case when @success=1 then @now else q.[DateSent] end,
	q.RetryCount=case when @success=1 then q.RetryCount else q.RetryCount+1 end,
	q.LastRetryAttempt=case when @success=1 then q.LastRetryAttempt else @now end,
	q.AlteredDate=@now,
	q.AlteredBy='sys'
from QUEUE_Queue q 
where q.[ID]=@queueid

if @Success=1
begin

	--// Update Order
	update od set od.[status]= case when od.SupplierId in (6207,6196,6502,6573,6657,6665) then 20 else 5 end
	from QUEUE_Queue q
	join ORDERING_Delivery od on od.id=q.DeliveryId and od.[status]=0
	where q.[ID]=@queueid 

	--// Update Order Items
	update odi set odi.[status]=case when od.SupplierId in (6207,6196,6502,6573,6657,6665) then 20 else 5 end
	from QUEUE_Queue q
	join ORDERING_DeliveryItems odi on odi.deliveryid=q.DeliveryId and odi.[status]=0
	join ORDERING_Delivery od on od.id=odi.deliveryid
	where q.[ID]=@queueid 

	--Update Validator Basket Items
	update cbi set cbi.Status=20
	from QUEUE_Queue q
	join ORDERING_DeliveryItems odi on odi.deliveryid=q.DeliveryId and odi.[status]=20 and odi.SourceType=1
	join Checkout_BasketItems cbi on odi.SourceKey = cbi.BasketItemId and cbi.Status <> 20
	where q.ID=@QueueID

	--// Clear Bank Details
	update b set b.BankAccountNo=replicate('*',len(b.BankAccountNo)-2) + right(b.BankAccountNo,2),
		b.BankSortCode=replicate('*',len(b.BankSortCode)-2) + right(b.BankSortCode,2)
	from Ordering_CashSettlements b
	join QUEUE_Queue q on q.DeliveryId=b.Deliveryid
	where q.Id=@QueueID

end

GO

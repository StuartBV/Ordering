SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[OrderSenders_ConfigId_Get](@queueId int)
returns int
as
begin
	return isnull((
		select top 1 c.Id
		from Queue_Queue q
		join Ordering_Delivery od on od.Id=q.DeliveryId
		join OrderSenders_Config c
			on IsNull(NullIf(c.SupplierId,0), od.SupplierId)=od.SupplierId
			and IsNull(NullIf(c.ProductFulfilmentType,0) ,od.ProductFulfilmentType)=od.ProductFulfilmentType
			and (c.SourceType='*' or od.SourceType=Cast(c.SourceType as tinyint))
		where q.Id=@queueId
		order by
			case when c.SourceType='*' then 0 else 4 end +
			case when c.ProductFulfilmentType=od.ProductFulfilmentType then 2 else 0 end +
			case when c.SupplierId=od.SupplierId then 1 else 0 end 
		desc
	),0)
end


GO

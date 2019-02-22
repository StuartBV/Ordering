SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[AmazonOrder_Get]
	@QueueId int
as
    begin
        set nocount on;
        declare @DeliveryId int
        set @DeliveryId = (SELECT DeliveryId FROM dbo.Queue_Queue where id = @QueueId)
        
        declare @SupplierId int
        set @SupplierId = 6502
        
        select top 1
                q.DeliveryId ,
                oc.Name ,
                oc.EmailAddress ,
                oc.MobilePhone ,
                od.SendEmail ,
                od.SendSms ,
                q.RetryCount ,
                od.OrderRef,
                od.SupplierId,
                ( select    top 1 cbi.CatNum
                  from      dbo.Ordering_DeliveryItems odi
                            join dbo.Checkout_BasketItems cbi on cbi.BasketItemId = odi.SourceKey and odi.SourceType = 1
                  where     odi.DeliveryId = @DeliveryId
                            and cbi.SupplierId = @SupplierId
                ) as [ASIN],
                
                ( select    coalesce(sum(odi.RRP), 0)
                  from      dbo.Ordering_DeliveryItems odi
                  where     [DeliveryId] = @DeliveryId
                ) +
                ( select    coalesce(sum(odic.PriceGross), 0) 
                  from      dbo.Ordering_DeliveryItems odi
                            left join dbo.Ordering_DeliveryItemCharges odic on odic.DeliveryItemId = odi.ItemId
                  where     [DeliveryId] = @DeliveryId
                ) as Amount,
                cu.Unit as CurrencyCode,
                od.Reference,
                od.Seq
        from    dbo.Queue_Queue q
                join dbo.Ordering_Delivery od on od.DeliveryID = q.DeliveryId
                join dbo.Ordering_Customer oc on oc.Id = od.CustomerId
                join PPD3.dbo.Countries co on od.CountryId = co.CountryID
                join PPD3.dbo.Currencies cu on co.CurrencyID = cu.CurrencyID
        where   q.Id = @QueueId	    
    end

GO

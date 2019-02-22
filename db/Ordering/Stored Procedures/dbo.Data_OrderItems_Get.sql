SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Data_OrderItems_Get] @DeliveryId int
as
    begin
        set nocount on;
		select 
			convert(decimal(10,2), isnull(odi.PriceNet * odi.VATRate, 0)) as SalePriceIncVat ,
            convert(decimal(10,2), odi.PriceNet) as SalePriceExVat ,
            convert(int, (odi.VATRate - 1) * 100) as VatRatePercentage,
			odi.ProductCode ,
			odi.Make ,
			odi.Model ,
			odi.ItemId
		from Ordering_DeliveryItems odi
		where odi.DeliveryId = @DeliveryId
		order by odi.ItemId

		select
			odi.ItemId,
			case dic.[Type] 
				when 2 then 1 
				when 3 then 2 
			end as ServiceTypeId ,
			--case when isnull(od.SupplierId,0) = 6680 then convert(decimal(10,2), dic.PriceNet) -- D&G AO.com - dg_rangeitem install, disposal already includes VAT as it's require for getauthority 
			--	else convert(decimal(10,2), dic.PriceGross) 
			--end as ChargeIncVat,
			dic.PriceGross as ChargeIncVat,
			dic.Catnum
        from Ordering_DeliveryItemCharges dic 
		join Ordering_DeliveryItems odi on odi.ItemId = dic.DeliveryItemId
		join Ordering_Delivery od on od.Id = odi.DeliveryId
		where   odi.DeliveryId = @DeliveryId

		select convert(decimal(10,2), isnull(PriceGross, 0)) as BaseDeliveryChargeAmount 
		from Ordering_Delivery_Orders 
		where DeliveryId = @DeliveryId

    end

GO

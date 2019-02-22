SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Data_OrderItems_Get_Hughes] @DeliveryId int
as
    begin
        set nocount on;
		select 
			convert(decimal(10,2), isnull(odi.PriceNet,0)) as SalePriceIncVat,
            convert(decimal(10,2), isnull(odi.PriceNet / odi.VATRate, 0)) as SalePriceExVat,
            odi.VATRate,
			odi.ProductCode ,
			odi.Make ,
			odi.Model ,
			odi.ItemId
		from Ordering_DeliveryItems odi
		where odi.DeliveryId = @DeliveryId
		order by odi.ItemId

		select 
			x.ItemId, 
			x.ServiceTypeId, 
			x.ChargeExVat, 
			round(x.ChargeExVat * x.VATRate,2) as ChargeIncVat,
			x.Catnum 
		from (
			select
				odi.ItemId,
				dic.[Type] AS ServiceTypeId ,
				case
					when dic.PriceNet = 0 or dic.Catnum = 'DELSTD' then 20 
					else dic.PriceNet 
				end AS ChargeExVat,
				odi.VATRate,
				dic.Catnum
			from Ordering_DeliveryItemCharges dic 
			join Ordering_DeliveryItems odi on odi.ItemId = dic.DeliveryItemId
			join Ordering_Delivery od on od.Id = odi.DeliveryId
			WHERE odi.DeliveryId = @DeliveryId AND dic.Catnum <> 'EXTINS'
		) x
    end

GO

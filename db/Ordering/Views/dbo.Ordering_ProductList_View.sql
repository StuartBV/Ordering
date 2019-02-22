SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[Ordering_ProductList_View]
as

select di.Deliveryid, ProductCode, 'Product' as [type], isnull(di.make,'') productmake, isnull(di.model,'') productmodel,
	cast(sum(di.SupplierCostPrice) as decimal(8,2)) productprice, cast(sum(di.SupplierGrossPrice) as decimal(8,2))productpriceincvat,
	cast(0.00 as decimal(8,2)) productdeliveryprice, cast(0.00 as decimal(8,2)) productinstallprice, cast(0.00 as decimal(8,2)) productdisposalprice,
	count(*) ProductQty, di.VATRate
from Ordering_DeliveryItems di 
group by di.ProductCode,di.VATRate,di.make,di.model, di.DeliveryId
union all
select di.DeliveryID, dic.Catnum as ProductCode, 'Charges' as [type],
		case dic.[Type]
			when 1 then 'Delivery'
			when 2 then 'Install'
			when 3 then 'Disposal'
			else 'ERROR!!'
		end + ' for ' + di.ProductCode as ProductMake,
		dic.[Description] as ProductModel, sum(cast(dic.PriceNet as decimal(8,2))) as ProductPrice, sum(cast(dic.PriceGross as decimal(8,2))) as ProductPriceIncVat,
		case dic.[Type]
			when 1 then sum(cast(dic.PriceNet as decimal(8,2)))
			else cast(0.00 as decimal(8,2))
		end productdeliveryprice,
		case dic.[Type]
			when 2 then sum(cast(dic.PriceNet as decimal(8,2)))
			else cast(0.00 as decimal(8,2))
		end productinstallprice,
		case dic.[Type]
			when 3 then sum(cast(dic.PriceNet as decimal(8,2)))
			else cast(0.00 as decimal(8,2))
		end productdisposalprice,
		count(*) as ProductQty,dic.VatRate
from Ordering_DeliveryItems di
join Ordering_DeliveryItemCharges dic on dic.DeliveryItemId=di.ItemId
group by di.ProductCode, dic.Catnum, dic.VatRate, dic.[Description],dic.[type],
	case dic.[Type]
		when 1 then 'Delivery'
		when 2 then 'Install'
		else 'ERROR!!'
		end + ' for ' + di.ProductCode, di.deliveryid
union all
select  o.DeliveryId, cast(o.ServiceCode as varchar) as ProductCode, 'Charges' as [type], 'Delivery' as ProductMake,
		'Charge' as ProductModel, o.PriceNet as ProductPrice, o.PriceGross as ProductPriceIncVat,
		cast(0.00 as decimal(8,2)) productdeliveryprice, cast(0.00 as decimal(8,2)) productinstallprice, cast(0.00 as decimal(8,2)) productdisposalprice,
		1 as ProductQty, o.VatRate
from ORDERING_Delivery_Orders o
where o.PriceNet>0
GO

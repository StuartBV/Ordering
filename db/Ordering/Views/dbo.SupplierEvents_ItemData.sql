SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[SupplierEvents_ItemData] as

select
	di.Deliveryid as ID,	[ProductCode],
	di.ItemId,
	isnull(di.make,'')  + ' '+ 	isnull(di.model,'')  [description],
	cast(di.[pricenet] as decimal(8,2)) NetPrice,
	cast(di.pricegross as decimal(8,2))GrossPrice,
	cast(di.pricegross-di.pricenet as decimal(8,2))VatAmount,
	di.[VATRate],
	isnull(di.Category,'') Category,
	'P' as CategoryType,	-- Product
	di.CreateDate
from ORDERING_DeliveryItems di 

union all

select  di.Deliveryid as ID,
		dic.Catnum as ProductCode,
		di.ItemId,
		dic.[Description],
		cast(dic.PriceNet as decimal(8,2)) as ProductPrice,
		cast(dic.PriceGross as decimal(8,2)) as ProductPriceIncVat,
		cast(dic.pricegross-dic.pricenet as decimal(8,2))VatAmount,
		di.[VATRate],
			isnull(di.Category,'') Category,
		case dic.[Type]
			when 1 then 'D'
			when 3 then 'X'
		else 'I' -- Amended by SD, caters for all other activities related to installing
		end CategoryType,
		di.CreateDate
from ORDERING_DeliveryItems di
join ORDERING_DeliveryItemCharges dic on dic.DeliveryItemId=di.ItemId

union all

select  o.DeliveryId as ID,
		cast(o.ServiceCode as varchar) as ProductCode,
		0 as itemID,
		'Delivery charge' as [description],
		cast(o.PriceNet as decimal(8,2)) as NetPrice,
		cast(o.PriceGross as decimal(8,2)) as GrossPrice,
		cast(o.PriceGross-o.PriceNet as decimal(8,2)) as VatAmount,
		o.VatRate,
		'Delivery' as Category,
		'D' as CategoryType,
		o.CreateDate
from ORDERING_Delivery_Orders o
where o.PriceNet>0

GO

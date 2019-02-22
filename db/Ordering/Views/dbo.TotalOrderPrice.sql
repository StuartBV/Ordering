SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[TotalOrderPrice]
as

select deliveryID,sum(ProductPriceIncVat)ProductPriceIncVat from (
	select Deliveryid, isnull(SupplierGrossPrice, cast(PriceNet * VATRate as smallmoney)) productpriceincvat
	from Ordering_DeliveryItems
	union all
	select di.DeliveryID, dic.PriceGross as ProductPriceIncVat
	from Ordering_DeliveryItems di
	join Ordering_DeliveryItemCharges dic on dic.DeliveryItemId=di.ItemId
	union all
	select  DeliveryId, PriceGross as ProductPriceIncVat
	from Ordering_Delivery_Orders
) x
group by deliveryID

GO

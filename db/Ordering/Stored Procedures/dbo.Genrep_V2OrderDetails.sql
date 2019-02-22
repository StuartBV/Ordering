SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Genrep_V2OrderDetails]
@from varchar(10),
@to varchar(10)
as
set nocount on
set dateformat dmy
declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

select d.id DeliveryID,d.CreateDate CreateDate,d.OrderRef,d.DeliveryDate,d.channel, di.Name SupplierName,case when vs.SupplierID is null then 'PP invoice' else 'Supplier Invoice' end WhoInvoices,
	ft.[Description] ProductFulfilmentType,	o.ServiceCode,o.PriceGross OrderDeliveryGross,
	i.ItemReference,i.ProductCode,i.make,i.model,i.PriceGross,isnull(i.SupplierGrossPrice,0) SupplierGrossPrice,i.Category,
	isnull(chDel.PriceGross,0) DeliveryCharge, isnull(chDel.Description,'') ChargeDescription,
	isnull(chIns.PriceGross,0) InstallCharge, isnull(chIns.Description,'') ChargeDescription,
	isnull(oi.Id,0) InvoiceNo,
	isnull(ic.name,'') InsuranceCompany	-- Added so we can identify the client for PP channel orders GP 14/11/2012
from ORDERING_Delivery d join ORDERING_DeliveryItems i on i.DeliveryId=d.id
left join ORDERING_DeliveryItemCharges chDel on chDel.DeliveryItemId=i.ItemId and chDel.[Type]=1
left join ORDERING_DeliveryItemCharges chIns on chIns.DeliveryItemId=i.ItemId and chIns.[Type]=2
left join ORDERING_Delivery_Orders o on o.DeliveryId=d.[id]
left join ppd3.dbo.Distributor di on di.id=d.SupplierId
left join ppd3.dbo.ValidationSuppliers vs on vs.[type]=d.Channel and vs.SupplierID=d.SupplierId
left join ppd3.dbo.InsuranceCos ic on ic.id=d.InscoID
left join sysLookup ft on ft.TableName='ProductFulfilmentTypes' and ft.code=cast(o.FulfilmentType as varchar)
left join Invoicing.dbo.INVOICING_Orders oi on d.DeliveryID=oi.DeliveryId
where d.[status]>0 and d.CreateDate between @fd and @td
order by 1
GO

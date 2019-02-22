SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Report_V2OrderDetails]
@from varchar(10),
@to varchar(10),
@InscoId int=0
as
set transaction isolation level read uncommitted
set nocount on
set dateformat dmy
declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

select d.Id DeliveryID,d.CreateDate CreateDate,d.OrderRef,d.DeliveryDate,d.Channel, di.Name SupplierName,case when vs.SupplierId is null then 'PP invoice' else 'Supplier Invoice' end WhoInvoices,
	ft.[Description] ProductFulfilmentType,	o.ServiceCode,o.PriceGross OrderDeliveryGross,
	i.ItemReference,i.ProductCode,i.Make,i.Model,i.PriceGross,isnull(i.SupplierGrossPrice,0) SupplierGrossPrice,i.Category,
	isnull(chDel.PriceGross,0) DeliveryCharge, isnull(chDel.[Description],'') ChargeDescription,
	isnull(chIns.PriceGross,0) InstallCharge, isnull(chIns.[Description],'') ChargeDescription,
	isnull(oi.Id,0) InvoiceNo,
	isnull(ic.Name,'') InsuranceCompany	-- Added so we can identify the client for PP channel orders GP 14/11/2012
from Ordering_Delivery d 
join Ordering_DeliveryItems i on i.DeliveryId=d.Id
left join ORDERING_DeliveryItemCharges chDel on chDel.DeliveryItemId=i.ItemId and chDel.[Type]=1
left join ORDERING_DeliveryItemCharges chIns on chIns.DeliveryItemId=i.ItemId and chIns.[Type]=2
left join ORDERING_Delivery_Orders o on o.DeliveryId=d.[Id]
left join sysLookup ft on ft.TableName='ProductFulfilmentTypes' and ft.Code=cast(o.FulfilmentType as varchar)
left join SN_Invoicing_Orders oi on oi.DeliveryId=d.Id
left join SN_Distributor di on di.Id=d.SupplierId
left join SN_ValidationSuppliers vs on vs.[Type]=d.Channel and vs.SupplierId=d.SupplierId
left join SN_InsuranceCos ic on ic.ID=d.InscoId
where d.CreateDate between @fd and @td and d.SourceType=1 and d.[Status]>0 and (@InscoId=0 or d.inscoid=@InscoId)
order by 1
GO

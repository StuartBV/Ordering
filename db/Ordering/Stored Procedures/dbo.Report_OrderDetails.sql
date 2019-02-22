SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Report_OrderDetails]
@from varchar(10), 
@to varchar(10), 
@InscoId int=0, 
@Channel varchar(50)='', 
@Type tinyint=0 --SourceType
as
set nocount on
set dateformat dmy
declare @fd datetime, @td datetime

select @fd=cast(@from as datetime), @td=dateadd(d, 1, cast(@to as datetime))

select d.Id DeliveryID, d.CreateDate CreateDate, d.OrderRef, d.DeliveryDate, d.Channel, di.[Name] SupplierName,
	case when vs.SupplierID is null then 'PP invoice' else 'Supplier Invoice' end WhoInvoices, 
	ft.[Description] ProductFulfilmentType, o.ServiceCode, o.PriceGross OrderDeliveryGross, 
	i.ItemReference, i.ProductCode, i.Make, i.Model, i.PriceGross, isnull(i.SupplierGrossPrice, 0) SupplierGrossPrice, i.Category, 
	isnull(chDel.PriceGross, 0) DeliveryCharge, isnull(chDel.[Description], '') ChargeDescription, 
	isnull(chIns.PriceGross, 0) InstallCharge, isnull(chIns.[Description], '') ChargeDescription, 
	isnull(oi.Id, 0) InvoiceNo, 
	isnull(ic.[Name], '') InsuranceCompany, 	-- Added so we can identify the client for PP channel orders GP 14/11/2012
	d.SourceKey BasketID, 
	d.Reference ClaimID, --This column and the one above was added for support 62655
	isnull(ost.[Name], '') OrderFrom, 
	i.Make, 
	i.Model
from Ordering_Delivery d 
join Ordering_DeliveryItems i on i.DeliveryId=d.Id
left join ORDERING_DeliveryItemCharges chDel on chDel.DeliveryItemId=i.ItemId and chDel.[Type]=1
left join ORDERING_DeliveryItemCharges chIns on chIns.DeliveryItemId=i.ItemId and chIns.[Type]=2
left join ORDERING_Delivery_Orders o on o.DeliveryId=d.[Id]
left join sysLookup ft on ft.TableName='ProductFulfilmentTypes' and ft.Code=cast(o.FulfilmentType as varchar)
left join SN_Invoicing_Orders oi on oi.DeliveryID=d.Id
left join SN_Distributor di on di.ID=d.SupplierId
left join SN_ValidationSuppliers vs on vs.[Type]=d.Channel and vs.SupplierID=d.SupplierId
left join SN_InsuranceCos ic on ic.ID=d.InscoId
left join dbo.ORDERING_SourceTypes ost on d.SourceType=ost.Id
where d.CreateDate between @fd and @td 
and d.[Status]>0
and (@InscoId=0 or d.InscoId=@InscoId)
and (@Channel='' or d.Channel=@Channel)
and (@Type=0 or (@Type=1 and d.SourceType not in (2, 4, 6)) or @Type=d.SourceType)
order by 1



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Report_V4_Orders_Commercial]
@channel varchar(10) = null,
@from varchar(10),
@to varchar(10)
as
set nocount on

declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

select odi.ItemReference as VNO,
od.Reference as ClaimReference,
ocl.InsurancePolicyNo as PolicyNumber,
od.OrderRef,
ocl.Excess,	
odi.Make, 
odi.Model,
odi.Category as Commodity,
pft.[Description] as ProductFulfilmentType, 
od.SupplierName,
coalesce(odi.PriceGross + isnull(odic.TotalDelivery,0) + isnull(odic.TotalInstall,0) + isnull(odic.TotalDisposal,0) + isnull(odic.TotalOther,0), ocs.Amount, 0) as SettlementValue,
coalesce(odi.PriceGross + isnull(odic.TotalDelivery,0) + isnull(odic.TotalInstall,0) + isnull(odic.TotalDisposal,0) + isnull(odic.TotalOther,0) - isnull(odi.ExcessDeducted,0), ocs.Amount, 0) as SettlementValueMinusExcess,
odi.SupplierCostPrice,
odi.SupplierGrossPrice,
isnull(convert(char(10), od.CreateDate, 103), '') + ' ' + isnull(convert(char(5), od.CreateDate, 14), '') as OrderedDate,
od.CreatedBy as OrderedBy,
oc.Surname,
isnull(oa.Address1,'') Address1,
isnull(oa.Address2, '')Address2,
isnull(oa.Town,'') Town,
isnull(oa.County,'') County,
isnull(oa.Postcode,'') Postcode, 
isnull(oc.MobilePhone,'') MobileNumber, 
isnull(oc.DaytimePhone, '') DaytimeNumber, 
isnull(oc.EveningPhone, '') EveningNumber,
isnull(oc.EmailAddress,'') EmailAddress, 
isnull(convert(char(10), od.DeliveryDate, 103), '') DeliveryDate,
isnull(odic.TotalDelivery,0) TotalDeliveryCostGross,
isnull(odic.TotalInstall,0) TotalInstallCostGross, 
isnull(odic.TotalDisposal,0) TotalDisposalCostGross,
isnull(odic.TotalOther,0) TotalOtherCostGross,
odi.RRP,
odi.RRP - odi.ExcessDeducted as RRPMinusExcess,
case when qq.DateSent is null then 'Not Sent' else 'Sent' + ' - ' + isnull(convert(char(10),qq.DateSent,103),0) end [Order Sent?],
od.VatRate,
odi.VatDeducted,
odi.ExcessDeducted
from Ordering_Delivery od
join Ordering_DeliveryItems odi on odi.DeliveryId = od.Id and odi.SourceType not in (1,2,3,4,6)
left join Queue_Queue qq on qq.DeliveryId = od.DeliveryID
left join Ordering_Claims ocl on ocl.DeliveryId=od.DeliveryID
left join ORDERING_ProductFulfilmentTypes pft on pft.Id=od.ProductFulfilmentType
left join Ordering_Customer oc on oc.Id=od.CustomerId
left join Ordering_Address oa on oa.DeliveryId=od.DeliveryID
left join ORDERING_DeliveryItemCharges_Totals odic on odic.DeliveryItemId=odi.ItemId
left join Ordering_CashSettlements ocs on ocs.Deliveryid = od.DeliveryID
where od.CreateDate between @fd and @td
and (od.Channel=@channel or @channel is null)

order by VNO


GO

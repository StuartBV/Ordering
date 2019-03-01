SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[API_GetOrderStatus]
@sourcekey int, 
@sourcetype int,
@singleItem bit=0
as
set nocount on

select 
	od.SourceKey,
	od.DeliveryID,
	od.OrderRef, 
	od.Reference,
	od.CreateDate OrderedDate,
	Coalesce(d.DFEmail,d.Email) SupplierEmail,
	od.ProductFulfilmentType FulfilmentType,
	od.SupplierId,
	od.SupplierName,
	cu.Title,
	cu.[Name],
	a.Address1,
	a.Address2,
	a.Town,
	a.Postcode,
	Phone=IsNull(cu.MobilePhone, IsNull(cu.DaytimePhone, IsNull(cu.EveningPhone, ''))),
	Email=cu.EmailAddress,
	oc.InsurancePolicyNo,
	oc.IncidentDate,
	ic.[Name] Client
from Ordering_Delivery od 
join PPD3.dbo.Distributor d on d.ID=od.SupplierId
join Ordering_Customer cu on cu.Id=od.CustomerId
join Ordering_Address a on a.DeliveryId=od.Id
join dbo.InsuranceCos ic on od.InscoId=ic.ID
left join dbo.Ordering_Claims oc on oc.DeliveryId=od.DeliveryID
where (@singleItem=0 and od.SourceKey=@sourcekey and od.SourceType=@sourcetype) or 
	 (
		@singleItem=1 --and od.DeliveryID=(select top(1) odi.DeliveryId from Ordering_DeliveryItems odi where odi.SourceKey=@sourcekey and odi.SourceType=@sourcetype order by odi.CreateDate desc))
		and od.DeliveryID=(select Max(DeliveryId) from Ordering_DeliveryItems where SourceKey=@sourcekey and SourceType=@sourcetype)
		)
order by od.DeliveryID desc

select 
	odi.SourceKey,
	odi.DeliveryId,
	odi.ItemReference,
	odi.Make,
	odi.Model,
	odi.ProductCode,
	odi.PriceNet,
	odi.PriceGross,
	DeliveryPriceNet=IsNull(charges.DeliveryPriceNet, Convert(money, 0)),
	DeliveryPriceGross=IsNull(charges.DeliveryPriceGross, Convert(money, 0)),
	InstallationPriceNet=IsNull(charges.InstallationPriceNet, Convert(money, 0)),
	InstallationPriceGross=IsNull(charges.InstallationPriceGross, Convert(money, 0)),
	DisposalPriceNet=IsNull(charges.DisposalPriceNet, Convert(money, 0)),
	DisposalPriceGross=IsNull(charges.DisposalPriceGross, Convert(money, 0)),
	odi.[Status],
	CancellationStatus=oc.[Status],
	oc.Reason,
	oc.Condition,
	oc.CreateDate RequestedDate,
	oc.HandlerName,
	oc.Email,
	oc.OtherInfo,
	oc.CollectionFee,
	oc.RestockingFee
from Ordering_DeliveryItems odi
join Ordering_Delivery od on od.Id=odi.DeliveryId
join PPD3.dbo.Distributor d on d.ID=od.SupplierId
join Ordering_Customer cu on cu.Id=od.CustomerId
join Ordering_Address a on a.DeliveryId=od.Id
left join Ordering_Cancellations oc on odi.ItemId=oc.DeliveryItemId
left outer join (
select oic.DeliveryItemId, 
	DeliveryPriceNet=Sum(case when oic.[Type]=1 then oic.PriceNet else Convert(money, 0) end),
	DeliveryPriceGross=Sum(case when oic.[Type]=1 then oic.PriceGross else Convert(money, 0) end),
	InstallationPriceNet=Sum(case when oic.[Type]=2 then oic.PriceNet else Convert(money, 0) end),
	InstallationPriceGross=Sum(case when oic.[Type]=2 then oic.PriceGross else Convert(money, 0) end),
	DisposalPriceNet=Sum(case when oic.[Type]=3 then oic.PriceNet else Convert(money, 0) end),
	DisposalPriceGross=Sum(case when oic.[Type]=3 then oic.PriceGross else Convert(money, 0) end)
	from Ordering_DeliveryItemCharges oic
	group by oic.DeliveryItemId
) charges on charges.DeliveryItemId=odi.ItemId
	where (@singleItem=0 and od.SourceKey=@sourcekey and od.SourceType=@sourcetype) or
	 (@singleItem=1 and odi.SourceKey=@sourcekey and odi.SourceType=@sourcetype)

select 
	odi.SourceKey,
	odi.DeliveryId,
	oc.[Status],
	oc.HandlerName,
	oc.Reason,
	oc.Condition,
	oc.Notes,
	oc.OtherInfo,
	oc.CollectionFee,
	oc.RestockingFee,
	oc.CreateDate
from Ordering_DeliveryItems odi
join Ordering_Delivery od on od.Id=odi.DeliveryId
join Ordering_CancellationLogs oc on odi.ItemId=oc.DeliveryItemId
where (@singleItem=0 and od.SourceKey=@sourcekey and od.SourceType=@sourcetype)
	or (@singleItem=1 and odi.SourceKey=@sourcekey and odi.SourceType=@sourcetype)

GO

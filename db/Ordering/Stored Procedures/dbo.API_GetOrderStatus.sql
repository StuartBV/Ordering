SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[API_GetOrderStatus]
@sourcekey int, 
@sourcetype int,
@singleItem bit=0
as
set nocount on
set transaction isolation level read uncommitted

select 
	od.SourceKey,
	od.DeliveryId,
	od.OrderRef, 
	od.Reference,
	od.CreateDate as OrderedDate,
	coalesce(d.dfEmail,d.email) as SupplierEmail,
	od.ProductFulfilmentType as FulfilmentType,
	od.SupplierId,
	od.SupplierName,
	cu.Title,
	cu.Name,
	a.Address1,
	a.Address2,
	a.Town,
	a.Postcode,
	Phone=ISNULL(cu.MobilePhone, ISNULL(cu.DaytimePhone, ISNULL(cu.EveningPhone, ''))),
	Email=cu.EmailAddress,
	oc.InsurancePolicyNo,
	oc.IncidentDate,
	ic.Name AS Client
from Ordering_Delivery od 
join PPD3.dbo.Distributor d on d.id = od.SupplierId
join Ordering_Customer cu on cu.id = od.CustomerId
join Ordering_Address a on a.DeliveryId = od.id
JOIN dbo.InsuranceCos ic ON od.InscoId = ic.Id
LEFT JOIN dbo.Ordering_Claims oc ON oc.DeliveryId = od.DeliveryID
where (@singleItem=0 AND od.SourceKey = @sourcekey and od.SourceType = @sourcetype) OR 
	  (@singleItem=1 AND od.DeliveryID = (SELECT TOP(1) odi.DeliveryId FROM Ordering_DeliveryItems odi WHERE odi.SourceKey=@sourcekey AND odi.SourceType=@sourcetype ORDER BY odi.CreateDate DESC))
order by od.DeliveryID DESC

select  
	odi.SourceKey,
	odi.DeliveryId,
	odi.ItemReference,
	odi.Make,
	odi.Model,
	odi.ProductCode,
	odi.PriceNet,
	odi.PriceGross,
	DeliveryPriceNet=ISNULL(charges.DeliveryPriceNet, convert(money, 0)),
	DeliveryPriceGross=ISNULL(charges.DeliveryPriceGross, convert(money, 0)),
	InstallationPriceNet=ISNULL(charges.InstallationPriceNet, convert(money, 0)),
	InstallationPriceGross=ISNULL(charges.InstallationPriceGross, convert(money, 0)),
	DisposalPriceNet=ISNULL(charges.DisposalPriceNet, convert(money, 0)),
	DisposalPriceGross=ISNULL(charges.DisposalPriceGross, convert(money, 0)),
	odi.Status,
	CancellationStatus=oc.Status,
	oc.Reason,
	oc.Condition,
	oc.CreateDate as RequestedDate,
	oc.HandlerName,
	oc.Email,
	oc.OtherInfo,
	oc.CollectionFee,
	oc.RestockingFee
from Ordering_DeliveryItems odi
join Ordering_Delivery od on od.id = odi.DeliveryId
join PPD3.dbo.Distributor d on d.id = od.SupplierId
join Ordering_Customer cu on cu.id = od.CustomerId
join Ordering_Address a on a.DeliveryId = od.id
left join Ordering_Cancellations oc on odi.ItemId = oc.DeliveryItemId
left outer join (Select oic.DeliveryItemId, 
				DeliveryPriceNet=SUM(CASE WHEN oic.[Type]=1 THEN oic.PriceNet ELSE convert(money, 0) END),
				DeliveryPriceGross=SUM(CASE WHEN oic.[Type]=1 THEN oic.PriceGross ELSE convert(money, 0) END),
				InstallationPriceNet=SUM(CASE WHEN oic.[Type]=2 THEN oic.PriceNet ELSE convert(money, 0) END),
				InstallationPriceGross=SUM(CASE WHEN oic.[Type]=2 THEN oic.PriceGross ELSE convert(money, 0) END),
				DisposalPriceNet=SUM(CASE WHEN oic.[Type]=3 THEN oic.PriceNet ELSE convert(money, 0) END),
				DisposalPriceGross=SUM(CASE WHEN oic.[Type]=3 THEN oic.PriceGross ELSE convert(money, 0) END)
from Ordering_DeliveryItemCharges oic group by oic.DeliveryItemId) as charges on charges.DeliveryItemId=odi.ItemId
where (@singleItem=0 AND od.SourceKey = @sourcekey and od.SourceType = @sourcetype) OR
	  (@singleItem=1 AND odi.SourceKey = @sourcekey and odi.SourceType = @sourcetype)

select 
	odi.SourceKey,
	odi.DeliveryId,
	oc.Status,
	oc.HandlerName,
	oc.Reason,
	oc.Condition,
	oc.Notes,
	oc.OtherInfo,
	oc.CollectionFee,
	oc.RestockingFee,
	oc.CreateDate
from dbo.Ordering_DeliveryItems odi
join Ordering_Delivery od on od.id = odi.DeliveryId
JOIN Ordering_CancellationLogs oc ON odi.ItemId=oc.DeliveryItemId
where (@singleItem=0 AND od.SourceKey = @sourcekey and od.SourceType = @sourcetype) OR
	  (@singleItem=1 AND odi.SourceKey = @sourcekey and odi.SourceType = @sourcetype)

GO

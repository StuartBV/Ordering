SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[genrep_A3Orders]
@from varchar(10),
@to varchar(10),
@ParentOU int=0,
@clientID int
as
set nocount on
set dateformat dmy
set transaction isolation level read uncommitted
declare @fd datetime,@td datetime, @oupath varchar(max) --@oupath added by JD, Atom: 66783

select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))
select @oupath=oupath from SSO_OrganisationalUnitPaths where ID=@clientID --added by JD, Atom: 66783

select od.Reference ClaimReference, ocl.InsurancePolicyNo PolicyNumber,
	case when v2p.Code=100 then v.OtherPeril else isnull(v2p.[Description], 'Unspecified') end Peril,
	isnull(cp.Name,'') CorporatePartner,
	od.OrderRef, 
	isnull(convert(varchar, bi.vno), 'Non-validated') VNO, 
	ocl.Excess, 
	isnull(convert(char(10), ocl.IncidentDate, 103), '') IncidentDate, 
	od.DeliveryNotes,	odi.Make, odi.Model, 
	case when c3.CatName is null
		then case when c2.CatName is null then odi.Category else c2.CatName	end
	else c3.CatName end Commodity, 
	case when c3.CatName is null then odi.Category else c2.CatName end CommodityL2, 
	isnull(c3.CatName,'') CommodityL3, 
	isnull(productFulfilmentType.[Description], '') as ProductFulfilmentType, 
	od.SupplierName, 
	case when exists (select * from AmazonLog l	where l.PORef='D' + cast(od.Id as varchar)	or l.PORef like od.Reference + '%')
		then bi.SettlementValue + isnull(odic.TotalDelivery,0) + isnull(odic.TotalInstall,0) + isnull(odic.TotalDisposal,0)
	else 0 end AmazonGCAmount,
	bi.SettlementValue, 
	odi.SupplierCostPrice, odi.SupplierGrossPrice, 
	COALESCE(authorisations.CreateDate, ISNULL(convert(char(10), od.CreateDate, 103), '')) AS OrderedDate, 
	COALESCE(authorisations.CreateDate, ISNULL(convert(char(5), od.CreateDate, 14), '')) AS OrderedTime, 
	COALESCE(authorisations.UserId, od.CreatedBy) AS OrderedBy,
	oc.Surname,
	isnull(oa.Address1,'') Address1,
	isnull(oa.Address2, '')Address2,
	isnull(oa.Town,'') Town,
	isnull(oa.County,'') County,
	isnull(oa.Postcode,'') Postcode, 
	isnull(oc.MobilePhone,'') MobileNumber, isnull(oc.DaytimePhone, '') DaytimeNumber, isnull(oc.EveningPhone, '') EveningNumber,
	isnull(oc.EmailAddress,'') EmailAddress, isnull(convert(char(10), od.DeliveryDate, 103), '') DeliveryDate, 
	isnull(odic.TotalDelivery,0) TotalDeliveryCostGross, 
	isnull(odic.TotalInstall,0) TotalInstallCostGross, 
	isnull(odic.TotalDisposal,0) TotalDisposalCostGross,
	isnull(sl.[Description],'') + case when cbsr.Reason=15 then ' - ' + isnull(cbsr.OtherReasonText, '') else '' end ReasonForCash,
	case when bi.RRP > odi.RRP then bi.RRP else odi.rrp end [RRP],
	v.OriginalReleaseDate [Release Date],
	v.OUPath [Team OU],
	v.PolicyNo [Policy Number],
	v.Ref [Claim Number],
	cp.Name [Corporate Partner],
	isnull(convert(char(10), ocl.IncidentDate, 103), '') [Incident Date]
from
Ordering_Delivery od 
join Ordering_DeliveryItems odi on odi.DeliveryId=od.Id and odi.SourceType=1
join Validator2.dbo.Checkout_BasketItems bi on odi.SourceKey=bi.BasketItemId and (bi.ServiceRestriction in (0,1,2,3,6,10,11,12) --LI Added 12 here per: Atom 66783
or bi.ProductFulfilmentType in (6, 7, 12)) --Exclude Swap Out UNLESS Amazon voucher selected (replaced !=9 with in clause)
join SSO_User u2 on u2.Username=bi.CreatedBy
join SSO_OrganisationalUnit ou on ou.Id=u2.OrganisationalUnitId --and ((@ParentOU>0 and ou.ParentId=@ParentOU) or (@InsuranceCoId>0 and ou.inscoId=@InsuranceCoId)) [comment out JD Atom: 66783]
join SSO_OrganisationalUnitPaths oup on ou.Id = oup.Id -- added by LI atom: 66783 to use in the and below
left join Ordering_Address oa on oa.DeliveryId=od.DeliveryID
left join Ordering_Customer oc on oc.Id=od.CustomerId
left join Ordering_Claims ocl on ocl.DeliveryId=od.DeliveryID
left join ORDERING_DeliveryItemCharges_Totals odic on odic.DeliveryItemId=odi.ItemId	
left join sn_Validations v on v.Vno=bi.vno
left join sn_V2Perils v2p on v.PerilCode=v2p.Code
left join sn_Checkout_BasketValidations bv on bv.BasketId=od.SourceKey and bv.vno=bi.vno
left join sn_Categories c on c.CatName=odi.Category and c.[Enabled]=1 --and c.level1Id=0
left join sn_Categories c2 on c2.CatID=c.ParentId
left join sn_Categories c3 on c3.CatID=c2.ParentId
left join sysLookup productFulfilmentType on productFulfilmentType.TableName='ProductFulfilmentTypes' and productFulfilmentType.Code=od.ProductFulfilmentType
left join sn_Checkout_Basket_SettlementReasons cbsr on cbsr.BasketID=od.SourceKey
	and ((cbsr.ReasonFor=0 and od.ProductFulfilmentType=3) or (cbsr.ReasonFor=1 and od.ProductFulfilmentType=6))
left join sn_V2SysLookup sl on sl.TableName='CashSettlementReason' and sl.Code=cbsr.Reason
left join sn_CorporatePartners cp on cp.Id=v.CorporatePartnerId
outer apply (SELECT TOP 1 Vno, Txt, UserID, CreateDate from validator2.dbo.Log WHERE Type = 86 and Vno=v.Vno and Txt = 'Basket ' + CONVERT(VARCHAR, bi.BasketId) +' status has been set to Waiting by ' + bi.CreatedBy ORDER BY Createdate DESC) authorisations -- new for RSA orders post authorisation baskets 20/12/2016 Ant Wilson
where od.CreateDate between @fd and @td  and ((@ParentOU>0 and ou.ParentId=@ParentOU) or oup.OuPath like @oupath + '%') --added by JD, Atom: 66783 | changed by LI on the same support to be oup.OUPath rather than v.OUPath as the non-validated items do not have a validation
order by od.CreateDate
option(force order)
GO

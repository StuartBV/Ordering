SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[OrderSearch]
@searchtext varchar(50),
@inscoid int=null
as
set nocount on
------ =============================================
------ Author:		danf
------ Create date: 24/11/2016
------ Modified by SD 03/02/2016
------ Description:	Returns information for searches in the Order Admin System
------ =============================================

--Removes preceding D when used as part of search string where necessary
	set @searchtext = case when @searchtext like 'D%/%' then @searchtext
	else
		case when left(@searchtext,1)='D' and (len(@searchtext) < 7 or left(@searchtext,2) in ('1','2','3','4','5','6','7','8','9','0')) --Added to exclude Claim Reference beginning with 'D'
			then substring(@searchtext,2,20)
			else @searchtext
		end
	end

-- This can be improved drastically by search validations seperately and unioning 
		--Validator Search
select 'Validator' [Source], cbi.VNO, 0 ClaimID, od.Channel, ic.Name InsCo, od.InscoId, od.Reference InsuranceClaimNo, d.Name Supplier, cbi.Category,
case when cbi.Excess > 0 then
	case 
		when od.ProductFulfilmentType=2 then 'Taken by BeValued'
		when od.ProductFulfilmentType=1 then 'Deducted from Voucher'
		when od.ProductFulfilmentType=3 then 'Deducted from Cash Settlement'
	end
end as ExcessMethod,
cbi.Excess, od.Id DID,
isnull(osc.OrderSenderId,0) as OrderSenderId,
cos.Name SendMethod,
case when osc.OrderSenderId in (8,9,11) then 1 else 0 end as CanDownload,
case when osc.OrderSenderId in (0,1,2,3,4,5,6,7,10,12,13) or od.SupplierId=10000100 then 1 else 0 end as CanView,
od.SourceKey BasketId, od.OrderRef,
isnull(sl.[Description], od.[Status]) as [Status],
case when osc.OrderSenderId=11 and datepart(hour,od.CreateDate) >=12  
	then 'APPLEORDER_' + convert(char(10), od.CreateDate + 1,126)
	when osc.OrderSenderId=11 
	then 'APPLEORDER_' + convert(char(10), od.CreateDate,126)
	when osc.OrderSenderId=9 and datepart(hour,od.CreateDate) < 12 
	then 'CPWORDER' + convert(char(8), od.CreateDate,112) + '_1200'
	when osc.OrderSenderId=9 and datepart(hour,od.CreateDate) between 12 and 14
	then 'CPWORDER' + convert(char(8), od.CreateDate,112) + '_1500'
	when osc.OrderSenderId=9 and datepart(hour,od.CreateDate) between 15 and 17 
	then 'CPWORDER' + convert(char(8), od.CreateDate,112) + '_1800'
	when osc.OrderSenderId=9 
	then 'CPWORDER' + convert(char(8), od.CreateDate + 1,112) + '_1200'
	end [FileName],
od.CreateDate
from Ordering_Delivery od
join SN_InsuranceCos ic on od.InscoId=ic.ID
join SN_Distributor d on d.id=od.SupplierId
join Validator2.dbo.Checkout_Baskets cb on cb.Id=od.SourceKey and od.SourceType=1
join Checkout_BasketItems cbi on cbi.BasketId=cb.Id
left join OrderSenders_Config osc on osc.ProductFulfilmentType=od.ProductFulfilmentType and osc.SupplierId=od.SupplierId
left join Config_OrderSenders cos on cos.Id=isnull(osc.OrderSenderId,0)
left join sysLookup sl on sl.TableName='ORDERING_Delivery_Status' and sl.Code=od.Status
where od.InscoId=isnull(@inscoid, od.InscoId) and 
	(
		cast(cbi.vno as varchar)=@searchtext or
		cast(od.Id as varchar)=@searchtext or
		cast(od.SourceKey as varchar)=@searchtext or
		od.OrderRef=@searchtext or
		od.Reference=@searchtext
	)

union all

--declare @searchtext varchar(100)='1949792/978209', @inscoid int=null
select distinct
	'CMS' [Source], 0 VNO, c.ClaimId, c.Channel,ic.Name InsCo, c.InsuranceCoID, c.InsuranceClaimNo,
	d.Name Supplier, sdi.Commodity Category, sc.[Description] ExcessMethod, sp.Excess, 
	c.DID DID,
	case when d.id=6520 then 8 else d.SendMethod end OrderSenderId,
		case when sm.[Description]='Ordering Service' then 'AO Order Sender' 
		else 
		case when d.id=6520 then 'Specsavers Order Sender' 
		else
	sm.[Description] end end as SendMethod,
	case when d.id=6520 then 1 else 0 end as CanDownload, 
	case when d.id=6520 then 0 else 1 end as CanView, 
	0 as BasketId, 
	c.MatchRef as OrderRef,
	isnull(sl.[Description], 
	c.[Status]) [Status],
	null [FileName], 
	c.CreateDate
from (
		select case when sd.Distributor=6657 then sd.SupplierRef else sd.did end as did, sd.claimid, c.channel, c.InsuranceCoID, c.InsuranceClaimNo, sd.Distributor, sd.[status], sd.matchref, sd.createdate
		from SN_SupplierDelivery sd
		join SN_Claims c on c.claimid=sd.claimid
		where (cast(sd.DId as varchar)=@searchtext or sd.MatchRef=@searchtext) and (@inscoid is null or c.InsuranceCoID=@inscoid)
		union all
		select case when sd.Distributor=6657 then sd.SupplierRef else sd.did end as did, sd.claimid, c.channel, c.InsuranceCoID, c.InsuranceClaimNo, sd.Distributor, sd.[status], sd.matchref, sd.createdate
		from sn_claims c join SN_SupplierDelivery sd on sd.claimid=c.claimid	--with(index(Idx_insuranceClaimNo))
		where (cast(c.ClaimId as varchar)=@searchtext or c.InsuranceClaimNo=@searchtext) and (@inscoid is null or c.InsuranceCoID=@inscoid)
	) c
join SN_InsuranceCos ic on ic.ID=c.InsuranceCoID
join SN_Distributor d on d.ID=c.Distributor
left join SN_SupplierDeliveryItems sdi on sdi.DID=c.DID
left join SN_SupplierPayments sp on sp.ClaimID=c.ClaimID
left join dbo.Ordering_Delivery od on od.Reference=c.ClaimID and od.SourceKey=c.DID and od.SourceType=2
left join SN_PPD3_SysLookup sl on sl.TableName='DFstatus' and sl.Code=c.[Status] 
left join SN_PPD3_SysLookup sm on sm.TableName='SendMethod' and sm.Code=d.SendMethod
left join sysLookup sc on sp.SupplierCollectsExcess=sc.Code and sc.TableName='SupplierCollectsXS'

union all

select 'Claim Companion' [Source], 0, 0 ClaimID, od.Channel, ic.Name InsCo, od.InscoId, od.Reference InsuranceClaimNo, d.Name Supplier, od.Category,
'' as ExcessMethod,
isnull(odi.ExcessDeducted,0) as Excess, 
od.Id DID,
isnull(osc.OrderSenderId,0) as OrderSenderId,
cos.Name SendMethod,
case when osc.OrderSenderId in (8,9,11) then 1 else 0 end as CanDownload,
case when osc.OrderSenderId in (0,1,2,3,4,5,6,7,10,12,13) or od.SupplierId=10000100 then 1 else 0 end as CanView,
od.SourceKey BasketId, od.OrderRef,
isnull(sl.[Description], od.[Status]) as [Status],
case when osc.OrderSenderId=11 and datepart(hour,od.CreateDate) >=12  
	then 'APPLEORDER_' + convert(char(10), od.CreateDate + 1,126)
	when osc.OrderSenderId=11 
	then 'APPLEORDER_' + convert(char(10), od.CreateDate,126)
	when osc.OrderSenderId=9 and datepart(hour,od.CreateDate) < 12 
	then 'CPWORDER' + convert(char(8), od.CreateDate,112) + '_1200'
	when osc.OrderSenderId=9 and datepart(hour,od.CreateDate) between 12 and 14
	then 'CPWORDER' + convert(char(8), od.CreateDate,112) + '_1500'
	when osc.OrderSenderId=9 and datepart(hour,od.CreateDate) between 15 and 17 
	then 'CPWORDER' + convert(char(8), od.CreateDate,112) + '_1800'
	when osc.OrderSenderId=9 
	then 'CPWORDER' + convert(char(8), od.CreateDate + 1,112) + '_1200'
	end [FileName],
od.CreateDate
from Ordering_Delivery od
join dbo.Ordering_DeliveryItems odi on odi.DeliveryId = od.Id
join SN_InsuranceCos ic on od.InscoId=ic.ID
join SN_Distributor d on d.id=od.SupplierId
left join OrderSenders_Config osc on osc.ProductFulfilmentType=od.ProductFulfilmentType and osc.SupplierId=od.SupplierId
left join Config_OrderSenders cos on cos.Id=isnull(osc.OrderSenderId,0)
left join sysLookup sl on sl.TableName='ORDERING_Delivery_Status' and sl.Code=od.Status
where od.InscoId=isnull(@inscoid, od.InscoId) and od.SourceType=3 and
	(
		cast(od.Id as varchar)=@searchtext or
		cast(od.SourceKey as varchar)=@searchtext or
		od.OrderRef=@searchtext or
		od.Reference=@searchtext
	)

union all

select 'Validator4' [Source], odi.SourceKey, 0 ClaimID, od.Channel, ic.Name InsCo, od.InscoId, od.Reference InsuranceClaimNo, d.Name Supplier, odi.Category,
case when isnull(odi.ExcessDeducted,0) > 0 then 
	case when od.ProductFulfilmentType = 1 
		then 'Deducted from Voucher'
		when od.ProductFulfilmentType=7
		then 'Deducted from Cash'
	end
	else 'Excess taken by client'
end as ExcessMethod,
isnull(odi.ExcessDeducted,0) as Excess, od.Id DID,
isnull(osc.OrderSenderId,0) as OrderSenderId,
cos.Name SendMethod,
case when osc.OrderSenderId in (8,9,11) then 1 else 0 end as CanDownload,
case when osc.OrderSenderId in (0,1,2,3,4,5,6,7,10,12,13) or od.SupplierId=10000100 then 1 else 0 end as CanView,
od.SourceKey BasketId, od.OrderRef,
isnull(sl.[Description], od.[Status]) as [Status],
case when osc.OrderSenderId=11 and datepart(hour,od.CreateDate) >=12  
	then 'APPLEORDER_' + convert(char(10), od.CreateDate + 1,126)
	when osc.OrderSenderId=11 
	then 'APPLEORDER_' + convert(char(10), od.CreateDate,126)
	when osc.OrderSenderId=9 and datepart(hour,od.CreateDate) < 12 
	then 'CPWORDER' + convert(char(8), od.CreateDate,112) + '_1200'
	when osc.OrderSenderId=9 and datepart(hour,od.CreateDate) between 12 and 14
	then 'CPWORDER' + convert(char(8), od.CreateDate,112) + '_1500'
	when osc.OrderSenderId=9 and datepart(hour,od.CreateDate) between 15 and 17 
	then 'CPWORDER' + convert(char(8), od.CreateDate,112) + '_1800'
	when osc.OrderSenderId=9 
	then 'CPWORDER' + convert(char(8), od.CreateDate + 1,112) + '_1200'
	end [FileName],
od.CreateDate
from dbo.Ordering_Delivery od
join SN_InsuranceCos ic on od.InscoId=ic.ID
join SN_Distributor d on d.id=od.SupplierId
left join dbo.Ordering_DeliveryItems odi on odi.DeliveryId=od.DeliveryID
left join OrderSenders_Config osc on osc.ProductFulfilmentType=od.ProductFulfilmentType and osc.SupplierId=od.SupplierId
left join Config_OrderSenders cos on cos.Id=isnull(osc.OrderSenderId,0)
left join sysLookup sl on sl.TableName='ORDERING_Delivery_Status' and sl.Code=od.Status
where od.InscoId=isnull(@inscoid, od.InscoId) 
and od.SourceType not in (1,2,3,4,6) 
and (
		cast(odi.SourceKey as varchar)=@searchtext or
		cast(odi.ItemReference as varchar)=@searchtext or
		cast(od.Id as varchar)=@searchtext or
		cast(od.SourceKey as varchar)=@searchtext or
		od.OrderRef=@searchtext or
		od.Reference=@searchtext
	)



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Data_Claim_Get]
@orderid int
as
set nocount on
set transaction isolation level read uncommitted

--//TODO: Remove as much of this as possible, particularly the supplier and channel specific columns
-- Note Left join to Order_claims as not all Channels (cough ahem AXA) have rows in this table.
select	
	isnull(c.InsuranceClaimNo,od.Reference) as ClaimNumber,isnull(c.InsurancePolicyNo,'') as PolicyNumber,
	0 Excess, 	c.IncidentDate incidentdate,'' LossAdjusterReference, 0 claimid,
	'' InstructorTypeCode,'' ClaimCentre,null sepsshortcode,'' LossAdjusterCode,'' ReasonCode,
	'1' BennettsInsCoCode,
	case od.supplierid
		when 6143 then 'NU Central Payments PCW'
		when 6196 then 'NU Central Payments Currys'
		else ''
	end DSGInsCoCode,
	case od.supplierid
		when 6143 then '001'
		when 6196 then '002'
		when 6207 then '967'
		else ''
	end DSGInsCo,
	'OS' + cast(od.Id as varchar(20)) + '/' + cast(od.SupplierId as varchar(20)) as EstimateID
From ORDERING_Delivery od 
left join Ordering_Claims c on c.DeliveryId=od.id
where od.id=@orderid
GO

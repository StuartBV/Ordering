SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[ORDERING_DeliveryItemCharges_Totals] as
select DeliveryItemId,
	sum(case when [Type]=1 then PriceGross else 0 end) TotalDelivery, 
	sum(case when [Type]=2 then PriceGross else 0 end) TotalInstall, 
	sum(case when [Type]=3 then PriceGross else 0 end) TotalDisposal,
	sum(case when [Type] not in (1,2,3) then PriceGross else 0 end) TotalOther
from ORDERING_DeliveryItemCharges
group by DeliveryItemId

GO

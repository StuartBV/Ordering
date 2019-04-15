SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ordering_DeliveryItems_PopulateCategoryId] as 
set nocount on
-- TEMP process working around category IDs not populated
update i set
	i.CategoryId=IsNull(c1.CatId,c2.CatId)
from Ordering_DeliveryItems i
left join Checkout_BasketItems bi on bi.BasketItemId=i.SourceKey and i.SourceType in (1,6)
left join Categories c1 on c1.CatName=IsNull(bi.Category,i.Category)
left join Categories c2 on c2.SingleDescription=IsNull(bi.Category,i.Category)
where i.Category is not null and IsNull(c1.CatId,c2.CatId) is not null and i.categoryid=0

GO

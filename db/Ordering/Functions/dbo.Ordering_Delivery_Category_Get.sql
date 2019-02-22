SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[Ordering_Delivery_Category_Get] (@deliveryid int)  
returns varchar(500)
as  
begin
	declare @categories varchar(500)

	select @categories=isnull(@categories+', ','')+x.category
	from (
		select distinct di.category
		from ORDERING_DeliveryItems di
		where di.deliveryid=@deliveryid 
	)x
	return @categories
end

GO

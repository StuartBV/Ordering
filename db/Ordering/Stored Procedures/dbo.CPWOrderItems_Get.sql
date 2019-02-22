SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[CPWOrderItems_Get] @DeliveryId int
as 
begin 
	set nocount on;	
    select distinct
            odi.PriceNet ,
            odi.ProductCode ,
            v.SerialNo ,
            vp.Make ,
            replace(vp.Model,',',';') Model,
            v2p.[Description] as ClaimType ,
            cbi.ProductFulfilmentType ,
            odi.SourceKey ,
            odi.ItemId
    from    dbo.Ordering_DeliveryItems odi
            left join dbo.Validations v on v.Vno = odi.ItemReference
            left join dbo.ValidatorProducts vp on vp.ArticleID = v.OriginalArticleID
            left join dbo.V2Perils v2p on v2p.Code = v.PerilCode
            left join dbo.Checkout_BasketItems cbi on cbi.BasketItemId = odi.SourceKey
    where   odi.DeliveryId = @DeliveryId
    order by odi.ItemId
end 

GO

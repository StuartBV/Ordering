SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Ordering_DeliveryItem_GetByDeliveryIdOrderLineNo]
@deliveryid AS INT,
@lineordernumber AS INT
as

set nocount ON

SELECT  odi.DeliveryId ,
		odi.RowNumber ,
        odi.ItemId ,
        odi.SourceKey ,
        odi.SourceType ,
        odi.ProductCode ,
        odi.Make ,
        odi.Model ,
        odi.PriceNet ,
        odi.RRP ,
        odi.Status ,
        odi.VATRate ,
        odi.PriceGross ,
        odi.Installation ,
        odi.Category ,
        odi.ItemReference ,
        odi.SupplierCostPrice ,
        odi.SupplierGrossPrice ,
        odi.CreateDate ,
        odi.CreatedBy ,
        odi.AlteredDate ,
        odi.AlteredBy,
        ud.GroupEmail,
        ud.Email
FROM		   (SELECT ROW_NUMBER() OVER (ORDER BY DeliveryId asc) AS RowNumber,
				DeliveryId ,
				ItemId ,
				SourceKey ,
				SourceType ,
				ProductCode ,
				Make ,
				Model ,
				PriceNet ,
				RRP ,
				Status ,
				VATRate ,
				PriceGross ,
				Installation ,
				Category ,
				ItemReference ,
				SupplierCostPrice ,
				SupplierGrossPrice ,
				CreateDate ,
				CreatedBy ,
				AlteredDate ,
				AlteredBy
				FROM dbo.Ordering_DeliveryItems
				WHERE DeliveryId = @deliveryid) odi
				left join dbo.User_Data ud on odi.CreatedBy=ud.UserName
WHERE odi.DeliveryId = @deliveryid AND odi.RowNumber= @lineordernumber 


GO

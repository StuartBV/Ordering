SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [dbo].[Checkout_Basket_Orders] as
SELECT  BasketId ,
        SupplierId ,
        FulfilmentType ,
        ServiceCode ,
        PriceNet ,
        VatRate ,
        CreateDate ,
        CreatedBy ,
        AlteredDate ,
        AlteredBy ,
        OrderNotes ,
        SupplierName ,
        AddressId ,
        DeliveryDate ,
        PriceGross
FROM VALIDATOR2..Checkout_Basket_Orders



GO

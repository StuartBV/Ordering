SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE view [dbo].[Checkout_BasketItems] as
SELECT  BasketItemId ,
        BasketId ,
        ValidatedItemId ,
        AddressId ,
        SupplierId ,
        ServiceRestriction ,
        ProductCode ,
        CatNum ,
        Make ,
        Model ,
        Status ,
        PriceNet ,
        VATRate ,
        CreatedBy ,
        CreateDate ,
        AlteredBy ,
        AlteredDate ,
        ProductFulfilmentType ,
        DeliveryDate ,
        InstallRequired ,
        vno ,
        ArticleId ,
        SupplierName ,
        Stock ,
        Category ,
        PriceGross ,
        RRP ,
        SupplierCostPrice ,
        Image ,
        Excess ,
        SettlementValue ,
        SettlementValueNet ,
        EditReason ,
        EditReasonText ,
        AccessoryForId ,
        TrackingRef
FROM VALIDATOR2..Checkout_BasketItems




GO

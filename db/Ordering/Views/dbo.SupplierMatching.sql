SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [dbo].[SupplierMatching] as
SELECT  uID ,
        ArticleID ,
        SupplierID ,
        PGID ,
        Prodid ,
        catid ,
        Channel ,
        Make ,
        CatNum ,
        SupplierName ,
        SupplierView ,
        Model ,
        Format ,
        Formattype ,
        Class ,
        Stock ,
        Price ,
        RRP ,
        delprice ,
        insprice ,
        disprice ,
        incvat ,
        ER ,
        Value1 ,
        HasVSID ,
        ServiceRestriction ,
        SupplierViewCategory ,
        IsSuppliedByPowerplay ,
        CreateDate
FROM VALIDATOR2..SupplierMatching



GO

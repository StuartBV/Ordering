SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[ValidatorProducts] as
select  ArticleID ,
        PGID ,
        CountryID ,
        PGName ,
        Make ,
        Model ,
        MakeMatch ,
        ModelMatch ,
        URL ,
        ImageName ,
        ImageEnabled ,
        Status ,
        OriginalPriceEX ,
        OriginalPricePP ,
        LastPriceEX ,
        LastPricePP ,
        OriginalPrice ,
        LastPrice ,
        VariantCount ,
        Processed ,
        EndDate ,
        Exclusive ,
        hidden ,
        PPModified ,
        Notes ,
        CreateDate ,
        CreatedBy ,
        AlteredDate ,
        AlteredBy ,
        LastPricePPAlteredDate ,
        lastpriceppAlteredBy ,
        ClonedArticleID ,
        Syscomments
from VALIDATOR2.dbo.ValidatorProducts


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[Validations] as
select  Vno ,
        VStatus ,
        ClaimID ,
        InscoID ,
        CatID ,
        Level1ID ,
        ICEItemID ,
        OriginalArticleID ,
        OriginalReleaseDate ,
        PurchaseMonth ,
        PurchaseYear ,
        PurchaseDate ,
        PurchaseLocation ,
        CompletedDate ,
        LogtoClaim ,
        LogItemToClaim ,
        LoggedToClaim ,
        Notes ,
        Channel ,
        Ref ,
        delivery ,
        installation ,
        disposal ,
        nohistory ,
        ModelChosen ,
        OldArtID ,
        OldCatID ,
        OriginalEndDate ,
        PriceMode ,
        SimpleValidation ,
        PolicyNo ,
        JewelleryValidationId ,
        CreateDate ,
        CreatedBy ,
        AlteredDate ,
        AlteredBy ,
        OtherPeril ,
        PerilCode ,
        SerialNo ,
        CorporatePartnerId ,
        OtherCorporatePartner ,
        PatriotCertificateId ,
        PatriotReport ,
        PatriotTransactionId
from VALIDATOR2.dbo.Validations


GO

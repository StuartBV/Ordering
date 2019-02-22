SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[Checkout_Baskets] as
SELECT  Id ,
        Status ,
        Channel ,
        CustomerId ,
        CurrencySymbol ,
        CheckoutNavigationIndex ,
        InsuranceClaimNo ,
        InsurancePolicyNo ,
        IncidentDate ,
        Excess ,
        ClaimID ,
        CreatedBy ,
        CreateDate ,
        AlteredBy ,
        AlteredDate ,
        InscoId ,
        SendEmail ,
        SendSms ,
        ReportedFault
FROM VALIDATOR2..Checkout_Baskets


GO

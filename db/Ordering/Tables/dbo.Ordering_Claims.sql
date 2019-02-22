CREATE TABLE [dbo].[Ordering_Claims]
(
[DeliveryId] [int] NOT NULL,
[InsurancePolicyNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InsuranceClaimNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Excess] [smallmoney] NOT NULL,
[IncidentDate] [smalldatetime] NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Ordering_Claim_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ordering_Claims] ADD CONSTRAINT [PK_Ordering_Claims] PRIMARY KEY CLUSTERED  ([DeliveryId]) ON [PRIMARY]
GO

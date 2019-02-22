CREATE TABLE [dbo].[Ordering_Cancellations]
(
[DeliveryItemId] [int] NOT NULL,
[IncidentDate] [datetime] NULL,
[InsurancePolicyReference] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reason] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Condition] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherInfo] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [tinyint] NOT NULL,
[HandlerName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuranceCompany] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollectionFee] [decimal] (18, 2) NULL,
[RestockingFee] [decimal] (18, 2) NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Cancellations_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL CONSTRAINT [DF_Cancellations_CreatedBy] DEFAULT ('sys'),
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ordering_Cancellations] ADD CONSTRAINT [PK_Ordering_Cancellations] PRIMARY KEY CLUSTERED  ([DeliveryItemId]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO

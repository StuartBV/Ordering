CREATE TABLE [dbo].[Ordering_Address]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[DeliveryId] [int] NULL,
[Address1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Town] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Postcode] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactTel] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF__ORDERING___Creat__07020F21] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL,
[CompanyName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ordering_Address] ADD CONSTRAINT [PK_ORDERING_Address] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_DeliveryId] ON [dbo].[Ordering_Address] ([DeliveryId]) INCLUDE ([Postcode]) WITH (FILLFACTOR=99) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Ordering_ProductFulfilmentTypes]
(
[Id] [int] NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShouldSendInvoice] [bit] NULL,
[CreateDate] [datetime] NULL,
[CreatedBy] [dbo].[UserID] NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ordering_ProductFulfilmentTypes] ADD CONSTRAINT [PK_ORDERING_ProductFulfilmentTypes] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO

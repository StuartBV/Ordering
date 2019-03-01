CREATE TABLE [dbo].[Ordering_Events]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[DeliveryId] [int] NOT NULL,
[Type] [smallint] NOT NULL,
[Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierID] [int] NULL,
[ProcessedDate] [datetime] NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Ordering_Events_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL,
[SysComments] [dbo].[SysComments] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ordering_Events] ADD CONSTRAINT [PK_Ordering_Events] PRIMARY KEY CLUSTERED  ([DeliveryId], [Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_Type] ON [dbo].[Ordering_Events] ([Type], [DeliveryId]) WITH (FILLFACTOR=99) ON [PRIMARY]
GO

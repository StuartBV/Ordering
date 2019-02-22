CREATE TABLE [dbo].[Batch_Orders]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[DeliveryId] [int] NOT NULL,
[SupplierId] [int] NULL,
[BatchId] [int] NULL,
[DateSent] [datetime] NULL,
[CreateDate] [datetime] NULL,
[CreatedBy] [dbo].[UserID] NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Batch_Orders] ADD CONSTRAINT [PK_Batch_Orders] PRIMARY KEY NONCLUSTERED  ([DeliveryId]) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_SENDER_Batch_Orders] ON [dbo].[Batch_Orders] ([BatchId], [DateSent]) ON [PRIMARY]
GO

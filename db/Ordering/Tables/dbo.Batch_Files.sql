CREATE TABLE [dbo].[Batch_Files]
(
[BatchId] [int] NOT NULL IDENTITY(1, 1),
[SupplierId] [int] NULL,
[DateSent] [datetime] NULL,
[CreateDate] [datetime] NOT NULL,
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Batch_Files] ADD CONSTRAINT [PK_BATCH_Files] PRIMARY KEY CLUSTERED  ([BatchId]) ON [PRIMARY]
GO

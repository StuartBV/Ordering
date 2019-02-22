CREATE TABLE [dbo].[Batch_Order_Data]
(
[BatchId] [int] NOT NULL,
[PoRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Email] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Message] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[To] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[From] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [decimal] (8, 2) NULL,
[CreateDate] [datetime] NULL,
[CreatedBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Batch_Order_Data] ADD CONSTRAINT [PK_BATCH_Order_Data] PRIMARY KEY CLUSTERED  ([BatchId], [PoRef]) ON [PRIMARY]
GO

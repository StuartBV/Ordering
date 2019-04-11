CREATE TABLE [dbo].[Ordering_CancellationLogs]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[DeliveryItemId] [int] NOT NULL,
[Status] [tinyint] NOT NULL,
[HandlerName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reason] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherInfo] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollectionFee] [decimal] (5, 2) NULL,
[RestockingFee] [decimal] (5, 2) NULL,
[Condition] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_CancellationLogs_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL CONSTRAINT [DF_CancellationLogs_CreatedBy] DEFAULT ('sys')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ordering_CancellationLogs] ADD CONSTRAINT [PK_Ordering_CancellationLogs] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO

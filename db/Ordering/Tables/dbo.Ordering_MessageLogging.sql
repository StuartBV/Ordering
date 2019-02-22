CREATE TABLE [dbo].[Ordering_MessageLogging]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[QueueID] [int] NULL,
[SenderName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Success] [bit] NULL,
[Request] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Response] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL CONSTRAINT [DF__ORDERING___Creat__1BC821DD] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ordering_MessageLogging] ADD CONSTRAINT [PK_MessageLogging] PRIMARY KEY NONCLUSTERED  ([ID]) ON [PRIMARY]
GO

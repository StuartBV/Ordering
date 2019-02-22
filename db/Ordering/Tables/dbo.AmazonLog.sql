CREATE TABLE [dbo].[AmazonLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SupplierId] [int] NOT NULL,
[PORef] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Amount] [money] NULL,
[EmailAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobilePhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ErrorCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResponseId] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimCode] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpiryDate] [smalldatetime] NULL,
[Asin] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_AmazonLog_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AmazonLog] ADD CONSTRAINT [PK_AmazonLog] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_PORef] ON [dbo].[AmazonLog] ([PORef]) ON [PRIMARY]
GO

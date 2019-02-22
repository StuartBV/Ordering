CREATE TABLE [dbo].[ApiKeys]
(
[KeyId] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApiKey] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_ApiKeys_Key] DEFAULT (newid()),
[CountryRestriction] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_ApiKeys_CountryRestriction] DEFAULT (''),
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequestLimit] [int] NOT NULL,
[RequestPeriod] [int] NOT NULL,
[Disabled] [bit] NOT NULL CONSTRAINT [DF_ApiKeys_Disabled] DEFAULT ((0)),
[Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Client] [int] NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_ApiKeys_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NULL CONSTRAINT [DF_ApiKeys_CreatedBy] DEFAULT ('sys')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ApiKeys] ADD CONSTRAINT [PK_ApiKeys] PRIMARY KEY CLUSTERED  ([KeyId]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'NULL = No claims access, '''' = All channels', 'SCHEMA', N'dbo', 'TABLE', N'ApiKeys', 'COLUMN', N'Channel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'NULL = No claims access, '''' = All clients', 'SCHEMA', N'dbo', 'TABLE', N'ApiKeys', 'COLUMN', N'Client'
GO

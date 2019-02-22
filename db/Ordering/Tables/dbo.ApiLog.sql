CREATE TABLE [dbo].[ApiLog]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[KeyId] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IpAddress] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequestUrl] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PostBody] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateTime] [datetime] NOT NULL,
[Country] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ApiLog] ADD CONSTRAINT [PK_ApiLog] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO

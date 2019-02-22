CREATE TABLE [dbo].[Ordering_Customer]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Title] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Forename] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Surname] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobilePhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DaytimePhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EveningPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] AS ((isnull([title]+' ','')+isnull([forename]+' ',''))+isnull([surname],'')),
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF__ORDERING___Creat__7C8480AE] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ordering_Customer] ADD CONSTRAINT [PK_ORDERING_Customer] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO

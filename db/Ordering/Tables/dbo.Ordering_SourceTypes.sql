CREATE TABLE [dbo].[Ordering_SourceTypes]
(
[Id] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF__ORDERING___Creat__03317E3D] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ordering_SourceTypes] ADD CONSTRAINT [PK_ORDERING_SourceTypes] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO

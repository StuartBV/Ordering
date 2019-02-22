CREATE TABLE [dbo].[Ordering_Conditions]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Type] [tinyint] NOT NULL CONSTRAINT [DF_Ordering_Conditions_Type] DEFAULT ((1)),
[Enabled] [bit] NOT NULL CONSTRAINT [DF_Ordering_Conditions_Enabled] DEFAULT ((1)),
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Ordering_Conditions_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL CONSTRAINT [DF_Ordering_Conditions_CreatedBy] DEFAULT ('sys'),
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ordering_Conditions] ADD CONSTRAINT [PK_Ordering_Conditions] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO

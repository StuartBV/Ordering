CREATE TABLE [dbo].[sysLookup]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TableName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Flags] [real] NULL,
[ExtraCode] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtraDescription] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[sysLookup] ADD CONSTRAINT [PK_sysLookup] PRIMARY KEY NONCLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [Idx_code] ON [dbo].[sysLookup] ([Code], [TableName]) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Client_BusinessAddress]
(
[Id] [int] NOT NULL,
[Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BusinessName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine3] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Town] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Postcode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Client_BusinessAddress] ADD CONSTRAINT [PK_BusinessAddress] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO

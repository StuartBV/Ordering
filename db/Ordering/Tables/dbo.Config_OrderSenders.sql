CREATE TABLE [dbo].[Config_OrderSenders]
(
[Id] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF__CONFIG_Or__Creat__1273C1CD] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Config_OrderSenders] ADD CONSTRAINT [PK_CONFIG_Orderers] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO

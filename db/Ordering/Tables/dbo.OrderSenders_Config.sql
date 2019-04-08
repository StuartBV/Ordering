CREATE TABLE [dbo].[OrderSenders_Config]
(
[SupplierId] [int] NOT NULL,
[ProductFulfilmentType] [smallint] NOT NULL,
[SourceType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [D_OrderSenders_Config_SourceType] DEFAULT ('*'),
[OrderSenderId] [int] NOT NULL,
[Id] [int] NOT NULL IDENTITY(1, 1),
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_OrderSenders_Config_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL CONSTRAINT [DF_OrderSenders_Config_CreatedBy] DEFAULT ('sys'),
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrderSenders_Config] ADD CONSTRAINT [PK_OrderSenders_Config] PRIMARY KEY CLUSTERED  ([SupplierId], [ProductFulfilmentType], [SourceType]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO

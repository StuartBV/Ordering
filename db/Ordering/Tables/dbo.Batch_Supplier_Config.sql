CREATE TABLE [dbo].[Batch_Supplier_Config]
(
[SupplierId] [int] NOT NULL,
[FileName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FileMessage] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FileCompanyName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SenderCompanyName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SenderEmail] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SendCustomerEmail] [bit] NOT NULL CONSTRAINT [DF_BATCH_Supplier_Config_SendCustomerEmail] DEFAULT ((0)),
[CustomerEmailFromAddress] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerEmailFromName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerEmailAttachment] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerEmailBody] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerEmailSubject] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_BATCH_Supplier_Config_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL,
[SysComments] [dbo].[SysComments] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Batch_Supplier_Config] ADD CONSTRAINT [PK_BATCH_Supplier_Config] PRIMARY KEY CLUSTERED  ([SupplierId]) ON [PRIMARY]
GO

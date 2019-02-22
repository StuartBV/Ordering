CREATE TABLE [dbo].[Ordering_DeliveryItems]
(
[DeliveryId] [int] NOT NULL,
[ItemId] [int] NOT NULL IDENTITY(1, 1),
[SourceKey] [int] NULL,
[SourceType] [tinyint] NULL,
[ProductCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Make] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Model] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceNet] [money] NOT NULL,
[RRP] [money] NULL,
[Status] [tinyint] NOT NULL CONSTRAINT [DF__ORDERING___Statu__79A81403] DEFAULT ((0)),
[VATRate] [money] NOT NULL,
[PriceGross] AS (CONVERT([decimal](8,2),[PriceNet]*[VATRate],(0))),
[ExcessDeducted] [money] NULL,
[Installation] [tinyint] NOT NULL CONSTRAINT [DF_ORDERING_DeliveryItems_Installation] DEFAULT ((0)),
[Category] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemReference] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierCostPrice] [money] NULL,
[SupplierGrossPrice] AS (CONVERT([decimal](8,2),round([SupplierCostPrice]*[VATRate],(2)),(0))),
[Guid] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Ordering_DeliveryItems_Guid] DEFAULT (newid()),
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF__ORDERING___Creat__7A9C383C] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL,
[VatDeducted] [decimal] (8, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ordering_DeliveryItems] ADD CONSTRAINT [PK_ORDERING_DeliveryItems] PRIMARY KEY CLUSTERED  ([ItemId]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_DeliveryID] ON [dbo].[Ordering_DeliveryItems] ([DeliveryId], [ItemId]) WITH (FILLFACTOR=75) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_SourceType] ON [dbo].[Ordering_DeliveryItems] ([SourceType], [DeliveryId]) WITH (FILLFACTOR=75) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_status] ON [dbo].[Ordering_DeliveryItems] ([Status], [DeliveryId], [ProductCode]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'0=UnProcessed,2=Backorder, 5=Awaiting Delivery Confirmation, 10 = Cancelled, 20=Confirmed Delivery Confirmation', 'SCHEMA', N'dbo', 'TABLE', N'Ordering_DeliveryItems', 'COLUMN', N'Status'
GO

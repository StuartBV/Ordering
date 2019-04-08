CREATE TABLE [dbo].[Ordering_Delivery]
(
[Id] [int] NOT NULL IDENTITY(10000, 1),
[CustomerId] [int] NULL,
[SourceKey] [int] NOT NULL,
[SourceType] [tinyint] NOT NULL,
[SupplierId] [int] NOT NULL,
[Reference] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [tinyint] NOT NULL CONSTRAINT [DF__ORDERING___Statu__76CBA758] DEFAULT ((0)),
[CountryId] [tinyint] NULL CONSTRAINT [DF__ORDERING___Count__1B0907CE] DEFAULT ((0)),
[DeliveryDate] [datetime] NULL,
[OrderRef] AS (('D'+CONVERT([varchar],[id],(0)))+isnull('/'+nullif([Reference],'0'),'')),
[AccountNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryNotes] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryService] [smallint] NULL,
[CourierCode] [smallint] NULL,
[CourierServiceCode] [smallint] NULL,
[Category] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourierRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourierID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductFulfilmentType] [tinyint] NULL,
[InscoId] [int] NULL,
[SendEmail] [bit] NOT NULL CONSTRAINT [DF_ORDERING_Delivery_SendEmail] DEFAULT ((0)),
[SendSms] [bit] NOT NULL CONSTRAINT [DF_ORDERING_Delivery_SendSms] DEFAULT ((0)),
[DeliveryID] AS ([id]),
[MarkedForInvoiceDate] [datetime] NULL,
[Seq] [tinyint] NULL,
[VatRate] [decimal] (18, 2) NULL CONSTRAINT [DF_Ordering_Delivery_VatRate] DEFAULT ((0)),
[Guid] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF__ORDERING___Creat__77BFCB91] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ordering_Delivery] ADD CONSTRAINT [PK_ORDERING_Delivery] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_Channel] ON [dbo].[Ordering_Delivery] ([Channel], [SourceType], [ProductFulfilmentType]) INCLUDE ([InscoId], [SupplierId]) WITH (FILLFACTOR=99) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_CreateDate] ON [dbo].[Ordering_Delivery] ([CreateDate], [Status]) WITH (FILLFACTOR=99) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_Reference] ON [dbo].[Ordering_Delivery] ([Reference]) INCLUDE ([Seq], [SourceKey]) WITH (FILLFACTOR=99) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_SourceKey] ON [dbo].[Ordering_Delivery] ([SourceKey], [SupplierId]) INCLUDE ([ProductFulfilmentType], [SourceType]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_Status] ON [dbo].[Ordering_Delivery] ([Status]) INCLUDE ([Id], [SupplierId]) WITH (FILLFACTOR=99) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_SupplierID2] ON [dbo].[Ordering_Delivery] ([SupplierId], [ProductFulfilmentType]) INCLUDE ([MarkedForInvoiceDate], [SourceKey]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_SupplierID] ON [dbo].[Ordering_Delivery] ([SupplierId], [Status]) INCLUDE ([Id], [OrderRef], [Reference]) WITH (FILLFACTOR=99) ON [PRIMARY]
GO

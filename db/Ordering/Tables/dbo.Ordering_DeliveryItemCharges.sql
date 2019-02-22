CREATE TABLE [dbo].[Ordering_DeliveryItemCharges]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[DeliveryItemId] [int] NOT NULL,
[Type] [tinyint] NOT NULL,
[SupplierChargeId] [int] NOT NULL,
[Catnum] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PriceNet] [money] NOT NULL,
[RRP] [money] NULL,
[VatRate] [decimal] (6, 4) NOT NULL,
[PriceGross] AS (CONVERT([smallmoney],round([PriceNet]*[VatRate],(2)),(0))),
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_ORDERING_DeliveryItemCharges_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL,
[VatDeducted] [decimal] (8, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ordering_DeliveryItemCharges] ADD CONSTRAINT [PK_ORDERING_DeliveryItemCharges_1] PRIMARY KEY CLUSTERED  ([DeliveryItemId], [Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_DeliveryItemID] ON [dbo].[Ordering_DeliveryItemCharges] ([DeliveryItemId]) INCLUDE ([PriceGross]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_Type] ON [dbo].[Ordering_DeliveryItemCharges] ([Type]) INCLUDE ([Description], [PriceGross]) ON [PRIMARY]
GO

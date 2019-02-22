CREATE TABLE [dbo].[Ordering_Delivery_Orders]
(
[DeliveryId] [int] NOT NULL,
[FulfilmentType] [int] NOT NULL,
[ServiceCode] [int] NULL,
[PriceNet] [smallmoney] NOT NULL,
[VatRate] [decimal] (6, 4) NOT NULL,
[DeliveryCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceGross] AS (CONVERT([smallmoney],round([PriceNet]*[VatRate],(2)),(0))),
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_ORDERING_Delivery_Orders_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ordering_Delivery_Orders] ADD CONSTRAINT [PK_ORDERING_Delivery_Orders] PRIMARY KEY CLUSTERED  ([DeliveryId], [FulfilmentType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_DeliveryID] ON [dbo].[Ordering_Delivery_Orders] ([DeliveryId]) INCLUDE ([PriceGross]) ON [PRIMARY]
GO

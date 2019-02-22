CREATE TABLE [dbo].[Queue_Queue]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[DeliveryId] [int] NOT NULL,
[DateSent] [datetime] NULL,
[RetryCount] [smallint] NOT NULL CONSTRAINT [DF__QUEUE_Que__Retry__0AD2A005] DEFAULT ((0)),
[OOS] [tinyint] NOT NULL CONSTRAINT [DF_QUEUE_Queue_OOS] DEFAULT ((0)),
[LastRetryAttempt] [datetime] NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF__QUEUE_Que__Creat__0BC6C43E] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL,
[SysComments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[TR_Queue_Queue_Update] on [dbo].[Queue_Queue]
for update as

if @@rowcount=0 return

-- OOS is updated from 1 to 0 by the UpdateStock trigger on ppd3.dbo.ProductInventory
-- This happens when webstock is increased for products that are currently awaiting stock as given by the view ordering.dbo.PowerplayStockRequired
-- This allows the queue row to be retried and the order placed where it is a Powerplay order
-- This trigger is required to return the deliveryitems to status 5 from 15. Status 15 was set when they were added to PurchaseOrders in order that they are ignored by PO system until reset below.

if update(oos)
begin
	update di set
		di.[status]=5,
		di.altereddate=getdate(),
		di.AlteredBy='TR_UpdateQueue'
	from inserted i join ORDERING_DeliveryItems di on di.DeliveryId=i.DeliveryId
	where i.oos=0
end
GO
ALTER TABLE [dbo].[Queue_Queue] ADD CONSTRAINT [PK_QUEUE_Queue] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_DateSent] ON [dbo].[Queue_Queue] ([DateSent]) INCLUDE ([DeliveryId], [LastRetryAttempt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_DeliveryId] ON [dbo].[Queue_Queue] ([DeliveryId], [DateSent]) WITH (FILLFACTOR=99) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_LastRetryAttempt] ON [dbo].[Queue_Queue] ([LastRetryAttempt]) INCLUDE ([DateSent], [DeliveryId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Queue_OOS] ON [dbo].[Queue_Queue] ([OOS], [DeliveryId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag to indicate if item(s) for this order are out of stock. Flag is set by the PP sender check stock process and cleared by ppd3 product inventory trigger', 'SCHEMA', N'dbo', 'TABLE', N'Queue_Queue', 'COLUMN', N'OOS'
GO

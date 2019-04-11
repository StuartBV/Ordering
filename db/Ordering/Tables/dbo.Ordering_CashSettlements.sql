CREATE TABLE [dbo].[Ordering_CashSettlements]
(
[Deliveryid] [int] NOT NULL,
[BankId] [int] NOT NULL,
[Amount] [decimal] (8, 2) NOT NULL,
[PayeeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BankSortCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BankAccountNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Ordering_CashSettlements_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ordering_CashSettlements] ADD CONSTRAINT [PK_Ordering_CashSettlements] PRIMARY KEY CLUSTERED  ([Deliveryid]) WITH (FILLFACTOR=99) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Sender_Email_AdditionalRecipients]
(
[RecipientType] [int] NOT NULL CONSTRAINT [DF_SENDER_Email_AdditionalRecipients_RecipientType] DEFAULT ((1)),
[EmailAddress] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ServerType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sender_Email_AdditionalRecipients] ADD CONSTRAINT [PK_SENDER_Email_AdditionalRecipients] PRIMARY KEY CLUSTERED  ([RecipientType], [EmailAddress], [ServerType]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Determines Recipient type: 1=To, 2=CC, 3=BCC', 'SCHEMA', N'dbo', 'TABLE', N'Sender_Email_AdditionalRecipients', 'COLUMN', N'RecipientType'
GO

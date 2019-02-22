SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Ordering_MessageLogging_Insert]
@queueid int,
@sendername varchar(50),
@success bit,
@request text,
@response text
as
set nocount on
Insert Into ORDERING_MessageLogging (QueueID,Success,Request,Response,SenderName)
values (@queueid, @success,@request,@response,@sendername) 
GO

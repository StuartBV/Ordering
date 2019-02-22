SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
------ =============================================
------ Author:		danf
------ Create date: 02/12/2016
------ Description:	Returns Emails for Orders in the Order Admin System
------ =============================================
CREATE PROCEDURE [dbo].[OrderSearch_StandardEmail] 
	@did int
as
set nocount on
set transaction isolation level read uncommitted

	select oml.Request as Message, oml.CreateDate 
	from dbo.Ordering_MessageLogging oml
	join dbo.Queue_Queue qq on qq.Id=oml.QueueID
	where qq.DeliveryId=@did
	ORDER BY oml.ID

GO

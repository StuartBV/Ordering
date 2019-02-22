SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

------ =============================================
------ Author:		danf
------ Create date: 02/12/2016
------ Description:	Returns XML for Web Service Orders in the Order Admin System
------ =============================================
CREATE procedure [dbo].[OrderSearch_WebService] 
	@did int,
	@sourcesystem varchar(50)
as
set nocount on
set transaction isolation level read uncommitted

	select dwxl.Direction,dwxl.XML as Message,dwxl.CreateDate 
	from Webservices.dbo.DF_WS_XmlLog dwxl 
	where dwxl.DID=@did 
	and dwxl.SourceSystem = case when @sourcesystem='CMS' then @sourcesystem else 'Ordering' end 
	order BY dwxl.LogID
GO

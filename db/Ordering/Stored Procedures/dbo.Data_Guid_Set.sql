SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Data_Guid_Set]
	@orderid int,
	@userid UserID
AS
set nocount on

update od 
	set [Guid]=NewID(), 
		AlteredBy=@userid,
		AlteredDate=Getdate()
from dbo.ORDERING_Delivery od
where od.id=@orderid 
and [Guid] is null
GO

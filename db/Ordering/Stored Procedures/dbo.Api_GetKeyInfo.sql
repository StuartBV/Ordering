SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Api_GetKeyInfo] 
@KeyId varchar(20)
as
set nocount on

select  
	KeyId,
	ApiKey,
	CreateDate,
	RequestLimit,
	RequestPeriod,
	[Disabled],
	[Description],
	CountryRestriction,
	Channel,
	Client
from ApiKeys
where KeyId=@KeyId
GO

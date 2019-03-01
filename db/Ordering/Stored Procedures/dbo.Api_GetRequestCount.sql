SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Api_GetRequestCount] 
@KeyId varchar(8), 
@RequestPeriod int,
@DateTime datetime
as
set nocount on
declare @dt datetime=DateAdd(minute,-@RequestPeriod, @DateTime)

select Count(*)
from ApiLog
where KeyId=@KeyId and [DateTime] > @dt -- Column called DateTime. <facepalm />

GO

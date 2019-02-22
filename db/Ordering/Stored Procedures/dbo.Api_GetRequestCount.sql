SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [dbo].[Api_GetRequestCount] 
@KeyId varchar(8), 
@RequestPeriod int,
@DateTime datetime
as
declare @dt DateTime =DateAdd(minute,-@RequestPeriod, @DateTime)

set noCount on

select Count(*) from ApiLog where KeyId = @KeyId and [DateTime] > @dt --DateAdd(minute, -@RequestPeriod, @DateTime)

GO

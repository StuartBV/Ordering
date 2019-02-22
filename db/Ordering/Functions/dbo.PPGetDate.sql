SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[PPGetDate](@TimeZoneID smallint)
returns PPDate as
begin
	return (timezone.dbo.PPGetDate(@TimeZoneID))
end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[Ordering_SourceType_Get](@key varchar(100))
returns int
as
begin
	return(
		select Id
		from ORDERING_SourceTypes st
		where st.Name=@key
	)
end
GO

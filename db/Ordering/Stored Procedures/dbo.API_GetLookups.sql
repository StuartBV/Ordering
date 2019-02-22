SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[API_GetLookups]
as
set nocount on

select Id, Description, Type from Ordering_ReturnReasons where enabled = 1

select Id, Description, Type from Ordering_Conditions where enabled = 1

select Id, Name as Description, 0 as Type from Ordering_SourceTypes

GO

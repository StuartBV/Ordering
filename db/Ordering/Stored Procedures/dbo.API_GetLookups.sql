SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[API_GetLookups]
as
set nocount on

select Id, [Description], [Type]
from Ordering_ReturnReasons
where [Enabled]=1

select Id, [Description], [Type]
from Ordering_Conditions
where [Enabled]=1

select Id, [Name] [Description], 0 [Type]
from Ordering_SourceTypes

GO

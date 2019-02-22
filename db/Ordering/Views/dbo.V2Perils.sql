SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[V2Perils] as
select Code, [Description]
from Validator2.dbo.V2Perils
GO

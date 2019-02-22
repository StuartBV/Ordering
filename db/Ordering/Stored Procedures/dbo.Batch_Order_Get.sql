SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Batch_Order_Get]
	@batchid int
as
select 
	'PoRef' PoRef,
	'Email' Email,
	'Message' [Message],
	'To' [To],
	'From' [From],
	'Amount' [Amount]
union all
select
	cast(PoRef as varchar),Email,[Message],[To],[From],cast([Amount] as varchar)
from BATCH_Order_Data d
where d.batchid=@batchid

GO

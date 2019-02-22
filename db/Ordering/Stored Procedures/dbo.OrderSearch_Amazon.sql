SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--SET QUOTED_IDENTIFIER ON
--SET ANSI_NULLS ON
--GO

------ =============================================
------ Author:		danf
------ Create date: 06/12/2016
------ Description:	Returns Amazon Orders in the Order Admin System
------ =============================================
CREATE procedure [dbo].[OrderSearch_Amazon] 
	@orderref varchar(50),
	@sourcesystem varchar(50),
	@did int
as
set nocount on
set transaction isolation level read uncommitted

declare @supplierid int, @claimid int, @insclaimno varchar(50)

	--set variables
	select @supplierid=od.SupplierId, @insclaimno=od.Reference from dbo.Ordering_Delivery od where od.DeliveryID=@did
	select @claimid=sd.ClaimID from PPD3.dbo.SupplierDelivery sd where sd.DID=@did or sd.MatchRef=@orderref

	set @orderref= 
		case @claimid when 257750 then --Staff Purchase Claim
			replace(@orderref,'/','')
			else
			case @sourcesystem 
				when 'CMS' then 
				cast(@claimid as varchar(10)) + cast(@did as varchar(10))
				else
				case @supplierid --Amazon(Aviva)
					when 6573 then cast(left(@insclaimno,11) as varchar(11)) + 'S' + (
						select cast(od.Seq as varchar(2)) from dbo.Ordering_Delivery od where od.OrderRef=@orderref)
					else 'D' + cast(@did as varchar(10))
				end
			end
		end

--Outbound portion
select 
0 as Direction,

'PORef: ' + alo.PORef + '

' + 'Amount: £' + cast(alo.Amount as varchar(10)) + '

' + 'Email: ' + isnull(alo.EmailAddress,'') + '

' + 'Phone: ' + isnull(alo.MobilePhone, '') + '

' + 'ASIN: ' + isnull(alo.Asin,'') + '

' + 'Created By: ' + cast(alo.CreatedBy as varchar(50)) 
as Message,
alo.ID,
alo.CreateDate 
from dbo.AmazonLog alo
where alo.PORef=@orderref


union all

--Inbound portion
select 
1 as Direction,

'Status Code: ' + ali.StatusCode + '

' + 'Status Message: ' + ali.StatusMessage + '

' + 'Error Code: ' + isnull(ali.ErrorCode,'') + '

' + 'Response ID: ' + isnull(ali.ResponseId,'') + '

' + 'Expires: ' + isnull(convert(varchar(10),ali.ExpiryDate,103),'')
as Message,
ali.ID,
ali.CreateDate
from dbo.AmazonLog ali
where ali.PORef=@orderref
order by ID, Direction




GO

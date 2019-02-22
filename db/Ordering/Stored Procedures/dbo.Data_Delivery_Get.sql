SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Data_Delivery_Get]
@orderid int
AS
set nocount on
set transaction isolation level read uncommitted

select distinct
	od.[guid] TransactionReference,
	od.OrderRef PoRef,
	0 BeValuedClaimRef,
	od.Id did,
	isnull(od.deliverynotes,'') Specialinstructions, 
	isnull(a.address1,'') DelAddress1,
	isnull(a.address2,'') DelAddress2,
	isnull(a.town,'') DelTown, 
	isnull(a.county,'') DelCounty,
	isnull(a.postcode,'') DelPostcode,
	isnull(c.title,'') DelTitle,
	isnull(c.Forename,'') DelForename,
	isnull(c.surname,'') DelSurname,
	isnull(c.title,'') DelTitle,
	isnull(coalesce(coalesce(c.DaytimePhone,c.EveningPhone),a.ContactTel),'') DelContactNo,
	isnull(c.EmailAddress,'') DelEmail,
	-- DSG (PCW, DSG, iDSG) when delivering vouchers and BID then blank delivery date
	case when od.SupplierId in (6143,6207,6196,6252) then '' else od.DeliveryDate end as DeliveryDate,
	'OS' + cast(od.Id as varchar(20)) + '/' + cast(od.SupplierId as varchar(20)) as EstimateID,
	isnull(odo.DeliveryCode,'') as DeliveryCode,
	od.SendEmail
from dbo.ORDERING_Delivery od
join ordering_customer c on c.id=od.customerid
left join ordering_address a on a.DeliveryId=od.id
left join ORDERING_Delivery_Orders odo on od.id=odo.DeliveryId 
where od.Id=@orderid

GO

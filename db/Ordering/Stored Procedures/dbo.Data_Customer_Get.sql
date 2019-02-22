SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Data_Customer_Get]
	@orderid int
AS
set nocount on
set transaction isolation level read uncommitted

select distinct
	isnull(c.title,'') Title,
	isnull(c.forename,'') FirstName,
	isnull(c.surname,'') Surname,
	isnull(coalesce(c.DaytimePhone,c.EveningPhone),'') HomePhone, 
	isnull(coalesce(c.MobilePhone,a.ContactTel),'') MobilePhone, 
	isnull(coalesce(a.ContactTel,c.DaytimePhone),'') WorkPhone,
	'' Fax,
	isnull(c.EmailAddress,'') Email,
	0 VATregistered,'' BusinessName,
	isnull(a.address1,'') AddressLine1,
	isnull(a.address2,'') AddressLine2,
	'' AddressLine3,
	isnull(a.town,'') Town,
	isnull(a.county,'') County,
	isnull(a.postcode,'') Postcode,
	isnull(a.country,'') Country
From dbo.ORDERING_Delivery od
join dbo.ORDERING_Customer c on c.id=od.CustomerId
left join dbo.ORDERING_Address a on a.DeliveryId=od.id
where od.id=@orderid
GO

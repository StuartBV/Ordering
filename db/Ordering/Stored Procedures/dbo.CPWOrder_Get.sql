SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[CPWOrder_Get]
@QueueId int
as
set nocount on
select q.DeliveryId, oc.Title, oc.Forename, oc.Surname, cc.DOB, oc.EmailAddress, cc.DaytimePhone, cc.EveningPhone, cc.MobilePhone, 
ca.Postcode PH_Postcode, ca.Address1 PH_Address1, ca.Address2 PH_Address2, ca.Town PH_Town,ca.County PH_County,oa.Postcode, 
oa.Address1, oa.Address2, oa.Town, oa.County, od.Reference, cb.ReportedFault, 
od.DeliveryNotes, od.SupplierName,od.CreateDate,od.DeliveryDate, od.OrderRef,
ud.FName AdvisorForename,ud.SName AdvisorSurname,ud.Email AdvisorEmail,ud.GroupEmail,ud.Telephone AdvisorTelephone
from Queue_Queue q
join Ordering_Delivery od on od.DeliveryID=q.DeliveryId
join Ordering_Customer oc on oc.Id=od.CustomerId
join Ordering_Address oa on oa.DeliveryId=q.DeliveryId
join Checkout_Baskets cb on cb.Id=od.SourceKey
join Customers cc on cc.Id=cb.CustomerId
join Customer_Addresses ca on ca.Id=cc.DefaultAddressId
join User_Data ud on ud.UserName=od.CreatedBy
where q.Id=@QueueId


GO

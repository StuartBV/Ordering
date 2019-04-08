SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Data_Order_Get_Hughes] @QueueId int
as
set nocount on

select oa.DeliveryId,
case
	when ic.ID=2402 then 'DAG'
	when od.SupplierId=6658 then 'Aviva'
else 'Be Valued' end ClientName,
case when od.SourceType=2 then od.Reference + '/' + Convert(varchar(10), od.SourceKey) else od.OrderRef end ClientOrderNumber,
od.CreateDate DateOrderTaken,
od.DeliveryDate RequestedDeliveryDate,
oc.Title Salutation,
case od.SupplierId
	when 6680 then IsNull(NullIf(oc.Forename, ''),',')
	when 6683 then IsNull(NullIf(oc.Forename, ''),'.')
else IsNull(oc.Forename, ' ') end Forename,
oc.Surname,
oc.EmailAddress,
Coalesce(NullIf(oc.DaytimePhone, ''), NullIf(oc.MobilePhone, ''), oc.EveningPhone) TelephoneNumber,
Coalesce(NullIf(oc.EveningPhone, ''), NullIf(oc.DaytimePhone, ''), oc.MobilePhone) EveningNumber,
Coalesce(NullIf(oc.MobilePhone, ''), NullIf(oc.DaytimePhone, ''), oc.EveningPhone) MobileNumber,
oa.Address1 HouseNumberName, 
case when oa.Town='' then '' else oa.Address2 end Street,
case when oa.Town='' then oa.Address2 else oa.Town end Town,
oa.County,
oa.Postcode,
IsNull(sso.FirstName + ' ' + sso.LastName, od.CreatedBy) + ' <' + Coalesce(ou.GroupEmail, sso.Email, '') + '>' AgentName,
od.Reference CustomerReference,
ic.[Name] InsurerName,
od.DeliveryNotes,
ic.ID InscoID,
cl.InsurancePolicyNo,
od.SourceKey,
od.SupplierName
from Queue_Queue q
	join Ordering_Delivery od on od.DeliveryID=q.DeliveryId
	join Ordering_Customer oc on oc.Id=od.CustomerId
	join Ordering_Address oa on oa.DeliveryId=q.DeliveryId
	join InsuranceCos ic on ic.ID=od.InscoId
	left join SSO_User sso on sso.Username=od.CreatedBy
	left join SSO_OrganisationalUnit ou on ou.Id=sso.OrganisationalUnitId
	left join Ordering_Claims cl on cl.DeliveryId=od.DeliveryID
where q.[Id]=@QueueId

GO

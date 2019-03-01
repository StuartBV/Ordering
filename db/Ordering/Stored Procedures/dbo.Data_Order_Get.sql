SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Sumaira Sanaullah
-- Create date: 17-07-2015
-- Description:	Get order details by QueueId
-- =============================================
CREATE procedure [dbo].[Data_Order_Get] @QueueId int
as
    begin
        set nocount on;

        select  oa.DeliveryId,
				case when ic.Id = 2402 then 'DAG'
					when od.SupplierId = 6658 then 'Aviva'
					else 'Be Valued'
					end as ClientName,
				case od.SourceType when 2 then od.Reference + '/' + convert(varchar(10), od.SourceKey) else od.OrderRef end as ClientOrderNumber ,
                od.CreateDate as DateOrderTaken,
                od.DeliveryDate as RequestedDeliveryDate,
                case od.SupplierId WHEN 6680 then  isnull(nullif(oc.Title, ''),'.')
					else isnull(oc.Title, ' ') end as Salutation,
                case od.SupplierId when 6680 then isnull(nullif(oc.Forename, ''),'.')
					else isnull(oc.Forename, ' ') end as Forename,
                oc.Surname,
                oc.EmailAddress,
                replace(coalesce(nullif(oc.DaytimePhone, ''), nullif(oc.MobilePhone, ''), oc.EveningPhone),'+44','0') as TelephoneNumber,
                replace(coalesce(nullif(oc.EveningPhone, ''), nullif(oc.DaytimePhone, ''), oc.MobilePhone),'+44','0') as EveningNumber,
                replace(coalesce(nullif(oc.MobilePhone, ''), nullif(oc.DaytimePhone, ''), oc.EveningPhone),'+44','0') as MobileNumber,
                oa.Address1 as HouseNumberName, 
				case when oa.Town = '' then '' else oa.Address2 end as Street,
				case when oa.Town = '' then oa.Address2 else oa.Town end as Town,
                oa.County,
                oa.Postcode,
                isnull(sso.FirstName + ' ' + sso.LastName, od.CreatedBy) + ' <' + coalesce(ou.GroupEmail, sso.Email, 'itsupport@bevalued.co.uk') + '>' as AgentName,
                od.Reference as CustomerReference,
                ic.Name as InsurerName,
                od.DeliveryNotes,
				ic.id as InscoID,
				cl.InsurancePolicyNo,
				od.SourceKey,
				od.SupplierName
        from    Queue_Queue q
                join Ordering_Delivery od on od.DeliveryID = q.DeliveryId
                join Ordering_Customer oc on oc.Id = od.CustomerId
                join Ordering_Address oa on oa.DeliveryId = q.DeliveryId
                join dbo.InsuranceCos ic on ic.ID = od.InscoId
                left join PPD3.dbo.SSO_User sso on sso.Username = od.CreatedBy
                left join PPD3.dbo.SSO_OrganisationalUnit ou on ou.Id = sso.OrganisationalUnitId
                left join dbo.Ordering_Claims cl on cl.DeliveryId = od.DeliveryID
        where   q.[Id] = @QueueId
    end
	

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[OrderDataAccess] @QueueId int
as
    set nocount on

    declare @deliveryId int= 0

    select  @deliveryId = DeliveryId
    from    Queue_Queue
    where   Id = @QueueId

--Get order details 
    select  q.Id,
            oc.Title,
            substring(oc.Forename, 1, 1) as Initials,
            oc.Surname,
            oc.DaytimePhone,
            oc.EmailAddress,
            oa.Address1,
            oa.Address2,
            oa.Town,
            oa.County,
            oa.Postcode,
            oa.Country,
            q.RetryCount,
            case od.SourceType when 2 then od.Reference + '/' + convert(varchar(10), od.SourceKey) else od.OrderRef end as OrderRef,
            od.DeliveryID,
            ic.Name InscoName,
			null as Denominations,
            od.SendEmail,
            isnull(substring(sso.FirstName, 1, 1) + substring(sso.LastName, 1, 1), substring(od.CreatedBy, 1, 1)) as HandlerInitials,
			od.Reference
    from    Queue_Queue q
            join Ordering_Delivery od on od.DeliveryID = q.DeliveryId
            join Ordering_Customer oc on oc.Id = od.CustomerId
            left join Ordering_Address oa on oa.DeliveryId = q.DeliveryId
            join PPD3.dbo.InsuranceCos ic on ic.ID = od.InscoId
            join [PPD3].[dbo].[SSO_User] sso on sso.[Username] =od.[CreatedBy]
    where   q.Id = @QueueId

    select  ItemId ,
            Make ,
            Model ,
            RRP ,
            SupplierCostPrice ,
            ProductCode
    from    Ordering_DeliveryItems
    where   DeliveryId = @deliveryId

    select  convert(decimal(10, 2), isnull(PriceGross, 0)) as Cost , DeliveryCode as Code
    from    dbo.Ordering_Delivery_Orders
    where   DeliveryId = @deliveryId and FulfilmentType in (1 , 12)

GO

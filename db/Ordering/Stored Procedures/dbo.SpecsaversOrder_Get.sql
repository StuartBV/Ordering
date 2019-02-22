SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[SpecsaversOrder_Get] @QueueId int
as
    begin

        set nocount on;
        select 
                q.DeliveryId ,
                oc.Title ,
                oc.Forename ,
                oc.Surname ,
                oc.EmailAddress ,
                oc.DaytimePhone ,
                oa.Address1 ,
                oa.Address2 ,
                oa.Town ,
                oa.County ,
                oa.Postcode ,
                q.RetryCount ,
                od.OrderRef ,
                ic.Name as InscoName
        from    dbo.Queue_Queue q
                join dbo.Ordering_Delivery od on od.DeliveryID = q.DeliveryId
                join dbo.Ordering_Customer oc on oc.Id = od.CustomerId
                join dbo.Ordering_Address oa on oa.DeliveryId = q.DeliveryId
                join dbo.InsuranceCos ic on ic.ID = od.InscoId 
        where   q.id = @QueueId

    end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Sender_PowerplaySender_Customer_Insert]
@deliveryid int
as
insert into ppd3.dbo.ORDER_Powerplay_Customer(Id,Title,Forename,Surname,EmailAddress,CreateDate,CreatedBy,AlteredDate,AlteredBy,MobilePhone,DaytimePhone,EveningPhone,Name)
select oc.Id,oc.Title,oc.Forename,oc.Surname,oc.EmailAddress,oc.CreateDate,oc.CreatedBy,oc.AlteredDate,oc.AlteredBy,oc.MobilePhone,coalesce(oc.DaytimePhone,a.ContactTel),EveningPhone,Name
from ORDERING_Delivery od join ORDERING_Customer oc on od.CustomerId=oc.id
join ORDERING_Address a on a.DeliveryId=od.id
where od.id=@deliveryid	and not exists (select * from ppd3.dbo.ORDER_Powerplay_Customer oc2 where oc2.Id=oc.Id)

GO

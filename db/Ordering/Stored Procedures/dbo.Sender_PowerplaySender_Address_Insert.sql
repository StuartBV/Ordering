SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Sender_PowerplaySender_Address_Insert]
@deliveryid int
as
insert into ppd3.dbo.ORDER_Powerplay_Address(Id,Address1,Address2,Town,County,Country,Postcode,ContactTel,CreateDate,CreatedBy,AlteredDate,AlteredBy,DeliveryId)
select Id,Address1,Address2,Town,County,Country,Postcode,ContactTel,CreateDate,CreatedBy,AlteredDate,AlteredBy,DeliveryId
from ORDERING_Address a
where a.DeliveryId=@deliveryid and not exists (select * from ppd3.dbo.ORDER_Powerplay_Address pp where pp.id=a.id)

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Sender_PowerplaySender_Delivery_Insert]
@deliveryid int
as
set nocount on
insert into ppd3.dbo.ORDER_Powerplay_Delivery(Id, CustomerId, SourceKey, SourceType, SupplierId, Reference, [Status], CountryId, DeliveryDate, OrderRef, AccountNo, 
	DeliveryNotes, DeliveryService, CourierCode, CourierRef, CourierServiceCode, CreateDate, CreatedBy, AlteredDate, AlteredBy)

select Id, CustomerId, SourceKey, SourceType, SupplierId, Reference, [Status], CountryId, DeliveryDate, OrderRef, AccountNo,
	DeliveryNotes, DeliveryService, CourierCode, CourierRef, CourierServiceCode, CreateDate, CreatedBy, AlteredDate, AlteredBy
from ORDERING_Delivery od
where od.Id=@deliveryid and not exists(select * from ppd3.dbo.ORDER_Powerplay_Delivery d where d.id=od.Id)
GO

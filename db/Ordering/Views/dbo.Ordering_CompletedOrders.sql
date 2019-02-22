SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Ordering_CompletedOrders] as
select [id] DeliveryID
from ORDERING_Delivery
where [status]=20
GO

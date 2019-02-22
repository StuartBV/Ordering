SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DeveloperCleanup]
(
	@SourceType int
)
AS
BEGIN
	IF (@SourceType<>14 AND @SourceType<>15)
	BEGIN
		RAISERROR('Invalid SourceType value. Please provide 14 or 15, as all other values are reserved for the clients.', 17, 1)
		RETURN 0
	END

DELETE from sub
FROM    dbo.Ordering_Cancellations sub
JOIN dbo.Ordering_DeliveryItems odi ON odi.ItemId = sub.DeliveryItemId
WHERE odi.SourceType=@SourceType

DELETE from sub
FROM    dbo.Ordering_CancellationLogs sub
JOIN dbo.Ordering_DeliveryItems odi ON odi.ItemId = sub.DeliveryItemId
WHERE odi.SourceType=@SourceType

DELETE from sub
FROM    dbo.Ordering_DeliveryItemCharges sub
JOIN dbo.Ordering_DeliveryItems odi ON odi.ItemId = sub.DeliveryItemId
WHERE odi.SourceType=@SourceType

DELETE from sub
FROM    dbo.Ordering_CashSettlements sub
JOIN dbo.Ordering_Delivery od ON od.DeliveryID = sub.Deliveryid
WHERE od.SourceType=@SourceType

DELETE from sub
FROM    dbo.Ordering_Address sub
JOIN dbo.Ordering_Delivery od ON od.DeliveryID = sub.Deliveryid
WHERE od.SourceType=@SourceType

DELETE from sub
FROM    dbo.Ordering_Address sub
JOIN dbo.Ordering_Delivery od ON od.DeliveryID = sub.Deliveryid
WHERE od.SourceType=@SourceType

DELETE from sub
FROM    dbo.Ordering_Delivery_Orders sub
JOIN dbo.Ordering_Delivery od ON od.DeliveryID = sub.Deliveryid
WHERE od.SourceType=@SourceType

DELETE from sub
FROM    dbo.Ordering_Events sub
JOIN dbo.Ordering_Delivery od ON od.DeliveryID = sub.Deliveryid
WHERE od.SourceType=@SourceType

DELETE from sub
FROM    dbo.Queue_Queue sub
JOIN dbo.Ordering_Delivery od ON od.DeliveryID = sub.Deliveryid
WHERE od.SourceType=@SourceType


DELETE FROM dbo.Ordering_DeliveryItems WHERE SourceType=@SourceType
DELETE FROM dbo.Ordering_Delivery WHERE SourceType=@SourceType

SELECT odi.SourceType, can.*
FROM    dbo.Ordering_Cancellations can
JOIN dbo.Ordering_DeliveryItems odi ON odi.ItemId = can.DeliveryItemId
WHERE odi.SourceType=@SourceType
END
GO

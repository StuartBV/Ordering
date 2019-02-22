SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AmazonLog_Get]
 @PoRef varchar(20), 
 @StatusCode varchar(10)
AS
begin 

    set nocount on;
    select  ID ,
            SupplierId ,
            PORef ,
            Amount ,
            EmailAddress ,
            MobilePhone ,
            StatusCode ,
            ErrorCode ,
            StatusMessage ,
            ResponseId ,
            ClaimCode ,
            ExpiryDate ,
            CreatedBy ,
            CreateDate ,
            [Asin]
    from    dbo.AmazonLog
    where   PORef = @PoRef
            and StatusCode = @StatusCode	
END
GO

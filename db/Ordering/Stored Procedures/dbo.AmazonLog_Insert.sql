SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AmazonLog_Insert]
 @SupplierId int
,@PORef varchar(20)
,@Amount money
,@EmailAddress varchar(100)
,@MobilePhone varchar(20)
,@StatusCode varchar(10)
,@ErrorCode varchar(10)
,@StatusMessage varchar(max)
,@ResponseId varchar(20)
,@ClaimCode varchar(100)
,@ExpiryDate smalldatetime
,@CreatedBy UserID
,@Asin varchar(50)

AS
begin 
	insert into dbo.AmazonLog
	        ( SupplierId ,
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
	        )
	values  ( @SupplierId,
	          @PORef,
	          @Amount,
	          @EmailAddress,
	          @MobilePhone,
	          @StatusCode,
	          @ErrorCode,
	          @StatusMessage,
	          @ResponseId,
	          @ClaimCode,
	          @ExpiryDate,
	          @CreatedBy,
	          getdate() ,
	          @Asin
	        )
end 
GO

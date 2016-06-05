CREATE PROCEDURE [dbo].[AddNewUser]
	@Username varchar(10),
	@Password varchar(200),
	@EmailAddress varchar(200),
	@Name varchar(50),
	@AddedBy varchar(10)

AS
	INSERT INTO [dbo].[Users]
	(Username, CurrentPassword, IsActive, RecCreateUserId, RecCreateTS)
	SELECT @Username, @Password, 1, @AddedBy, GETUTCDATE()
	FROM dbo.Users
	WHERE NOT EXISTS(SELECT Username FROM dbo.Users WHERE (Username = @Username))

	DECLARE @userId bigint
	SELECT @UserId = SCOPE_IDENTITY()

	if (@UserId > 0)
	BEGIN
		INSERT INTO [dbo].[Emails]
		(UserId, EmailAddress, IsActive, RecCreateUserId, RecCreateTS)
		SELECT @UserId, @EmailAddress, 1, @AddedBy, GETUTCDATE()
		FROM dbo.Emails
		WHERE NOT EXISTS(SELECT EmailAddress FROM dbo.Emails WHERE UserId = @UserId AND EmailAddress = @EmailAddress)
	END
	
RETURN 0

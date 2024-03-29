USE [C126_ezelcuevas_gmail]
GO
/****** Object:  StoredProcedure [dbo].[TechCompanies_Insert]    Script Date: 5/6/2023 8:04:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROC [dbo].[TechCompanies_Insert]
			@Name nvarchar(120),
			@Profile nvarchar(max),
			@Summary nvarchar(255),
			@Headline nvarchar(120),
			@ContactInformation nvarchar(255),
			@Slug nvarchar(100),
			@StatusId int,
			@BatchImages BatchImages READONLY,
			@BatchUrls BatchUrls READONLY,
			@BatchTags BatchTags READONLY,
			@BatchFriendIds BatchFriendIds READONLY,
			@Id int OUTPUT

AS 

BEGIN 

declare @ImageId int

--insert TechCompany

INSERT INTO [dbo].[TechCompanies]
           ([Name]
           ,[Profile]
           ,[Summary]
           ,[Headline]
           ,[Slug]
           ,[StatusId])

     VALUES
           (@Name
		   ,@Profile
		   ,@Summary
		   ,@Headline
		   ,@Slug
		   ,@StatusId)
	SET @Id = SCOPE_IDENTITY() 


INSERT INTO dbo.TechCompanyContactInformation
			(EntityId, [Data])
			Values(@Id, @ContactInformation)


--insert Images
INSERT INTO [dbo].[Images]
           ([TypeId]
           ,[Url])
    select [ImageTypeId], [ImageUrl]
	from @BatchImages

	SET @ImageId = SCOPE_IDENTITY() 



INSERT INTO [dbo].[TechCompanyImages]
           ([TechCompanyId]
           ,[ImageId])
    select @Id, i.Id
	from @BatchImages as bi
	Inner Join dbo.Images as i
	ON bi.ImageUrl = i.Url

--insert Urls
INSERT INTO dbo.Urls
			([Url])
	SELECT bu.[Url]
	FROM @BatchUrls as bu
	WHERE NOT EXISTS (	SELECT 1
						FROM dbo.Urls as u
						WHERE u.[Url] = bu.[Url])

INSERT INTO [dbo].[TechCompanyUrls]
           ([TechCompanyId] ,[UrlId])
    SELECT @id , u.Id
	FROM @BatchUrls as bu
	INNER JOIN dbo.Urls as u
	ON bu.[Url] = u.[Url]

--insert Tags

INSERT INTO dbo.Tags
			([TagName])
	SELECT bt.[TagName]
	FROM @BatchTags as bt
	WHERE NOT EXISTS (	SELECT 1
						FROM dbo.Tags as t
						WHERE t.[TagName] = bt.[TagName])

INSERT INTO [dbo].[TechCompanyTags]
           ([TechCompanyId] ,[TagId])
    SELECT @id , u.Id
	FROM @BatchTags as bu
	INNER JOIN dbo.Tags as u
	ON bu.[TagName] = u.[TagName]


--insert FriendId

	INSERT INTO [dbo].[TechCompanyFriends]
           ([TechCompanyId] ,[FriendId])
    SELECT @id , f2.Id
	FROM @BatchFriendIds as bf
	INNER JOIN dbo.FriendsV2 as f2
	ON bf.[FriendId] = f2.[Id]



END
GO

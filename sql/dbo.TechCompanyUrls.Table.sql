USE [C126_ezelcuevas_gmail]
GO
/****** Object:  Table [dbo].[TechCompanyUrls]    Script Date: 5/6/2023 8:04:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TechCompanyUrls](
	[TechCompanyId] [int] NOT NULL,
	[UrlId] [int] NOT NULL,
 CONSTRAINT [PK_TechCompanyUrls] PRIMARY KEY CLUSTERED 
(
	[TechCompanyId] ASC,
	[UrlId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

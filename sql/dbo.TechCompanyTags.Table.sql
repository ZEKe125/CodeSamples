USE [C126_ezelcuevas_gmail]
GO
/****** Object:  Table [dbo].[TechCompanyTags]    Script Date: 5/6/2023 8:04:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TechCompanyTags](
	[TechCompanyId] [int] NOT NULL,
	[TagId] [int] NOT NULL,
 CONSTRAINT [PK_TechCompanyTags] PRIMARY KEY CLUSTERED 
(
	[TechCompanyId] ASC,
	[TagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

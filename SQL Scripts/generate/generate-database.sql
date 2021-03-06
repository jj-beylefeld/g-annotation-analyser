USE [AmandaTasks]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 2018/09/29 16:53:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[Category] [nvarchar](255) NULL,
	[SubCategory] [nvarchar](255) NULL,
	[SubSystem] [nvarchar](255) NULL,
	[Role_Name] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FileData]    Script Date: 2018/09/29 16:53:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FileData](
	[File_No] [int] NULL,
	[Contig_info] [varchar](200) NULL,
	[FIG] [varchar](50) NULL,
	[Gene] [varchar](50) NULL,
	[Start] [varchar](50) NULL,
	[End] [varchar](50) NULL,
	[Dot] [varchar](500) NULL,
	[Strand] [varchar](50) NULL,
	[Number] [varchar](50) NULL,
	[ID] [varchar](500) NULL,
	[Name] [varchar](500) NULL,
	[Ontology] [varchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FileInfo]    Script Date: 2018/09/29 16:53:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FileInfo](
	[File_no] [int] IDENTITY(1,1) NOT NULL,
	[M_Type_No] [int] NOT NULL,
	[File_Name] [varchar](2000) NULL,
	[Report_Description] [varchar](200) NULL,
 CONSTRAINT [PK__FileInfo__0FFEB5DD0B8BE52E] PRIMARY KEY CLUSTERED 
(
	[File_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[M_Types]    Script Date: 2018/09/29 16:53:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[M_Types](
	[M_Type_No] [int] IDENTITY(1,1) NOT NULL,
	[M_Type_Name] [varchar](50) NOT NULL,
	[M_Type_Desc] [varchar](500) NULL,
 CONSTRAINT [PK_M_Types] PRIMARY KEY CLUSTERED 
(
	[M_Type_No] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FileData]  WITH CHECK ADD  CONSTRAINT [FK__FileData__File_N__30F848ED] FOREIGN KEY([File_No])
REFERENCES [dbo].[FileInfo] ([File_no])
GO
ALTER TABLE [dbo].[FileData] CHECK CONSTRAINT [FK__FileData__File_N__30F848ED]
GO
ALTER TABLE [dbo].[FileInfo]  WITH CHECK ADD  CONSTRAINT [FK_FileInfo_M_Types] FOREIGN KEY([M_Type_No])
REFERENCES [dbo].[M_Types] ([M_Type_No])
GO
ALTER TABLE [dbo].[FileInfo] CHECK CONSTRAINT [FK_FileInfo_M_Types]
GO

/****** Script for SelectTopNRows command from SSMS  ******/
DECLARE @M_Type varchar(50) = 'MS'
,@Gene varchar(20) = 'CDS'

;with cte as (
SELECT distinct 
FI.File_No
,FI.Report_Description
,Gene
,Start
,[End]
,Strand
,Name
,C.Category
  FROM [AmandaTasks].[dbo].[FileData] FD
  join FileInfo FI on FI.File_no = FD.File_No
  join M_Types MT on MT.M_Type_No = FI.M_Type_No
  left join Category C on FD.Name = C.Role_Name
  where Gene= coalesce(@Gene,Gene)
  and name not like '%hypoth%'
  AND MT.M_Type_Name = coalesce(@M_Type,MT.M_Type_Name)
  And FI.IgnoreCompAna = 0
  ), prePivot as (
select 
Report_Description
,coalesce(Category,'Uncategorised') Category
,count(*) Counted
from cte
Group BY 
Category
, Report_Description
)
select
piv.Category
,coalesce([B458_15_1],0) as [B458_15_1]
,coalesce([B458_15_5M],0) as [B458_15_5M]
,coalesce([B458_15_6],0) as [B458_15_6]
,coalesce([B1064_14_H3],0) as [B1064_14_H3]
,coalesce([B1064_14_H4],0) as [B1064_14_H4]
,coalesce([B1064_14_H5],0) as [B1064_14_H5]
,coalesce([B1393_14_10],0) as [B1393_14_10]
,coalesce([B1394_14_2],0) as [B1394_14_2]
,coalesce([B1394_14_5],0) as [B1394_14_5]
,coalesce([B2214_07],0) as [B2214_07]
,coalesce([M Synoviae strain 53],0) as [M Synoviae strain 53]
from
prePivot
Pivot ( /*select ',['+Report_Description+']',',coalesce(['+Report_Description+'],0) as ['+Report_Description+']' from FileInfo where M_Type_No = 1 And IgnoreCompAna=0*/
	max(Counted) for Report_Description in ([B458_15_1],[B458_15_5M],[B458_15_6],[B1064_14_H3],[B1064_14_H4],[B1064_14_H5],[B1393_14_10],[B1394_14_2],[B1394_14_5],[B2214_07],[M Synoviae strain 53])
) piv
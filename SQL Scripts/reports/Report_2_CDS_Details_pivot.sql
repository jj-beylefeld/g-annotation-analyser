DECLARE @M_Type varchar(50) = 'MS'
,@Gene varchar(20) = 'CDS'

;WITH cte AS (
SELECT DISTINCT 
	FI.File_No
	, FI.Report_Description
	, Gene
	, Start
	, [End]
	, Strand
	, Name
	, C.Category
	, C.SubCategory
	, C.SubSystem
	, C.Role_Name
  FROM [AmandaTasks].[dbo].[FileData] FD
  JOIN FileInfo FI ON FI.File_no = FD.File_No
  join M_Types MT on MT.M_Type_No = FI.M_Type_No
  LEFT JOIN Category C ON FD.Name = C.Role_Name
  WHERE Gene= coalesce(@Gene,Gene)
  AND MT.M_Type_Name = coalesce(@M_Type,MT.M_Type_Name)
  And FI.IgnoreCompAna = 0
  ),prePivot AS (
select 
Report_Description
,Name
,count(*) Counted
,Category
,SubCategory
,SubSystem
,Role_Name
from cte
--where Name like '%mobile%'
Group BY 
Name
, Report_Description
,Category
,SubCategory
,SubSystem
,Role_Name
)select
coalesce(piv.Category,'Uncategorised') AS Category
,coalesce(piv.SubCategory,'Uncategorised') AS SubCategory
,coalesce(piv.SubSystem,'Uncategorised') AS SubSystem
,coalesce(piv.Role_Name,piv.Name,'Unknown') as Name
/* generated code from here */
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
pivot ( /*select ',['+Report_Description+']',',coalesce(['+Report_Description+'],0) as ['+Report_Description+']' from FileInfo where M_Type_No = 1 And IgnoreCompAna=0*/
	max(Counted) for Report_Description in ([B458_15_1],[B458_15_5M],[B458_15_6],[B1064_14_H3],[B1064_14_H4],[B1064_14_H5],[B1393_14_10],[B1394_14_2],[B1394_14_5],[B2214_07],[M Synoviae strain 53])
) piv
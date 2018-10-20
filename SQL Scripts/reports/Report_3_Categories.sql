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
  AND MT.M_Type_Name = coalesce(@M_Type,MT.M_Type_Name)
  and name not like '%hypoth%'
  And FI.IgnoreCompAna = 0
  )
select 
Report_Description
,coalesce(Category,'Uncategorised') Category
,count(*) Counted
from cte
Group BY 
Category
, Report_Description
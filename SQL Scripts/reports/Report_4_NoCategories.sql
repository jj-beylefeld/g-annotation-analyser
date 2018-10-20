/****** Script for SelectTopNRows command from SSMS  ******/
/*select count(*) from FileData where Gene='CDS'
select count(*) from FileData where Gene='CDS' and name like '%hypo%'
select count(*) from FileData where Gene='CDS' and name like '%/%'*/
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
  left join Category C on FD.Name = C.Role_Name
  where Gene='CDS'
  and C.Category is null
  And FI.IgnoreCompAna = 0
  )
select 
*
from cte
where name <> 'hypothetical protein'
and name not like '%/%'
order by Report_Description,Name


--select * from Category where Role_Name like '%mobil%'
declare @tablename varchar(50) = 'M Synoviae strain 53'

declare @fileNo int = (select File_No from FileInfo where Report_Description=@tablename)
--select @fileNo

/* 
	select top 1000 * from [dbo].[M Synoviae strain 53] 
	select top 1000 * from [dbo].[B1064_14_H3]

*/

;with cte as (
select * from [dbo].[M Synoviae strain 53]
), cte_fin as (

select 
Contig AS ContigInfo
, NULL  AS FIG
, Type AS Gene
, Start AS Start
, Stop as [end]
, NULL as [Dot]
, Strand as Strand
, NULL as Number 
,NULL		 IDInfo
,[Function] as NameInfo
,NULL	 OntInfo
from cte

)
insert into FileData (File_No,Contig_info, FIG, Gene, Start, [End], Dot, Strand, Number, ID, Name, Ontology)
select 
@fileNo File_No
, ContigInfo
, FIG
, Gene
, Start
, [end]
, [Dot]
, Strand
, Number 
, IDInfo 
,  NameInfo
,  OntInfo
from cte_fin
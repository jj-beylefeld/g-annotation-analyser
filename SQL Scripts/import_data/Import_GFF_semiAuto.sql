declare @tablename varchar(50) = 'MGstrain53_RAST_233150_3'
declare @M_Type_No int = 2

declare @filename varchar(2000) = 'C:\Personal\Amanda\Amanda-PhD\MG\GFF\'+@tablename+'.gff'

declare @tmp varchar(300) ;
select @tmp = reverse(substring(reverse(@filename),1,charindex('\',reverse(@filename)) -1 ))


insert into FileInfo (M_Type_No,File_Name, Report_Description) 
select @M_Type_No,@filename ,replace(@tmp,'.gff','') Report_Description

declare @sql nvarchar(max) =
'declare @fileNo int = (select File_No from FileInfo where Report_Description='''+@tablename+''')
--select @fileNo

;with cte as (
select 
* 
,SUBSTRING(column9,1,charindex('';'',column9,1)-1) IDInfo
,SUBSTRING(column9,1+charindex('';'',column9,1),len(column9) - charindex('';'',column9,1)+1) NameInfo
,reverse(SUBSTRING(reverse(column9),1,charindex('';'',reverse(column9),1)-1)) OntInfo
from '+@tablename+'
), cte_fin as (

select 
column1 AS ContigInfo
, column2  AS FIG
, column3 AS Gene
, column4 AS Start
, column5 as [end]
, column6 as [Dot]
, column7 as Strand
, column8 as Number 
, IDInfo ID_text
, NameInfo Name_Text
, OntInfo Ont_Text
,SUBSTRING(IDInfo,1+charindex(''='',IDInfo,1),len(IDInfo) - charindex(''='',IDInfo,1)+1)		 IDInfo
,SUBSTRING(NameInfo,1+charindex(''='',NameInfo,1),len(NameInfo) - charindex(''='',NameInfo,1)+1) NameInfo
,SUBSTRING(OntInfo,1+charindex(''='',OntInfo,1),len(OntInfo) - charindex(''='',OntInfo,1)+1)	 OntInfo
from cte

)
insert into FileData (File_No,Contig_info, FIG, Gene, Start, [End], Dot, Strand, Number, ID, Name, Ontology)
select 
@fileNo
, ContigInfo
, FIG
, Gene
, Start
, [end]
, [Dot]
, Strand
, Number 
, IDInfo AS ID
, replace(NameInfo,'';''+Ont_Text,'''') NameInfo
, case when NameInfo=OntInfo then null else OntInfo end AS Ontology
from cte_fin'

exec sp_executesql @sql

--delete from Filedata
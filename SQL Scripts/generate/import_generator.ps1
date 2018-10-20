$M_Type=2
$null > list.txt
$folder = (resolve-path .)
dir *.gff | foreach { "exec sp_Import_GFF_generic '$($_.Name.Replace('.gff',''))', '$folder\', $M_Type" >> list.txt}


#select distinct * from FileData where File_No
#dir *.gff | foreach { "exec sp_Import_GFF_generic '$($_.Name.Replace('.gff',''))', '$folder\', $M_Type" >> list.txt}
#from FileData where File_No=9
#select count(*) from FileData where File_No = (select File_No from FileInfo where Report_Description='B1394_14_2')

dir *.gff | foreach { "select count(*) from $($_.Name.Replace('.gff',''))" >> validate.txt; "select count(*) from FileData where File_No = (select File_No from FileInfo where Report_Description='$($_.Name.Replace('.gff',''))')" >> validate.txt}
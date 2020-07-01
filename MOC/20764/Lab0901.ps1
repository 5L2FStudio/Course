get-process | ?{$_.WorkingSet -gt 20MB} | sort -Property WorkingSet -Descending | select ProcessName,Id,@{n='WorkingSet(MB)';e={$_.WorkingSet/1MB -as [int]}},Cpu | ConvertTo-Html | Out-File 'C:\Temp\TEST1.HTML'


get-process `
| ?{$_.WorkingSet -gt 20MB} `
| sort -Property WorkingSet -Descending `
| select ProcessName,Id,@{n='WorkingSet(MB)';e={$_.WorkingSet/1MB -as [int]}},@{n='CPU';e={($_.cpu).tostring("#.00")}} `
| ConvertTo-Html `
| Out-File 'C:\Temp\TEST2.HTML' 

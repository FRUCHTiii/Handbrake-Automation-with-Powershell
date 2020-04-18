#Variables
$input_directory = "Z:\Filme\"
$output_directory = "Z:\Test_Out\"
$new_file_extension = "mkv"
$handbrake_gui_preset = "ENCODE"
$wait_timer = "3"


$filelist = Get-ChildItem $input_directory -Include "*.mp4", "*.mkv", "*.avi", "*.mpeg4", "*.ts" -recurse 
$num = $filelist | measure
$filecount = $num.count
 
$i = 0;
ForEach ($file in $filelist)
{
	$i++;
	$parent_folder = Split-Path $file.DirectoryName -Leaf
    $oldfile = $file.DirectoryName + "\" + $file.BaseName + $file.Extension;
    $newfile = $output_directory + $parent_folder + "\" + $file.BaseName + ".$new_file_extension";
	
	New-Item -Path $output_directory -Name $parent_folder -ItemType "directory"
	$del_path = "$input_directory$parent_folder"
    
    $progress = ($i / $filecount) * 100
    $progress = [Math]::Round($progress,2)
 
    Clear-Host
    Write-Host -------------------------------------------------------------------------------
    Write-Host Handbrake Batch Encoding
    Write-Host "Processing - $oldfile"
    Write-Host "File $i of $filecount - $progress%"
	Write-Host "$Handbreak_Path"
    Write-Host -------------------------------------------------------------------------------
     
    Start-Process "C:\Program Files\HandBrake\HandBrakeCLI.exe" -ArgumentList "-i `"$oldfile`" -o `"$newfile`"  --preset-import-gui $handbrake_gui_preset" -Wait -NoNewWindow
	
	Remove-Item -Path $del_path -recurse
	
	Write-Host -------------------------------------------------------------------------------
    Write-Host Finished 
	Write-Host Wait $wait_timer seconds
    Write-Host -------------------------------------------------------------------------------
	Start-Sleep -s $wait_timer
}
$Directory = E:\
$Collection = @(Get-ChildItem -Path $Directory -Recurse)
$FileList = $Collection.Where{-not $_.PSIsContainer}

'{0:n0} folders {1:n0} files {2:n2}GB' -f @(
    $Collection.Where{$_.PSIsContainer}.Count
    $FileList.Count
    (($FileList.Length | Measure-Object -Sum).Sum / 1GB)
)
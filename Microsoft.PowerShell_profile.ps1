# Bu dosyayı tamamen kendi keyfime göre tasarladım. Fikir edinebilirsiniz. Kullanabilirsiniz. Top sizde.
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/tokyo.omp.json" | Invoke-Expression
Import-Module -Name Terminal-Icons
Set-Alias -Name apt -Value winget
Set-Alias -Name Yükle -Value Yukle
Set-Alias -Name Arama -Value Ara
#Set-Alias -Name indir -Value "yt-dlp -S 'res:1080' -o 'D:\my_folder_location\%(upload_date)s\%(title)s [%(id)s].%(ext)s' -a your_list_of_files.txt"
cls

#winget app download command Turkish.
function indir {
       param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$urls
    )
    foreach ($url in $urls) {
    yt-dlp --merge-output-format mp4 -f "bestvideo+bestaudio[ext=m4a]/best" -o "D:\indirilenler\%(title)s [%(id)s].%(ext)s" -a 'D:\indirilenler\indirmelistesi.txt' $url
}
}


function Apt-Update {
    $apps = winget upgrade | Select-Object -Skip 10 | ForEach-Object {
        ($_ -split '\s{2,}')[1] 
    }

    foreach ($app in $apps) {
      
            
        if ($app -and ($app -ne "Id" -and $app -ne "winget")) {
            Write-Host "`nUpdating: $app" -ForegroundColor Cyan
            try {
                winget upgrade --Id "$app" --accept-source-agreements --accept-package-agreements
            } catch {
                Write-Warning "Failed to update $app : $($_.Exception.Message)"
            }
        }
    }
}

function Ara {
    param (
        [Parameter(Mandatory=$true)]
        [string]$AramaTerimi,
        [string]$Kaynak,
        [switch]$TamEslesme
    )
    $komut = "winget search $AramaTerimi"
    if ($Kaynak) { $komut += " --source $Kaynak" }
    if ($TamEslesme) { $komut += " --exact" }
    Invoke-Expression $komut
}

function Yukle {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Uygulama,
        [string]$Kaynak,
        [string]$Versiyon,
        [switch]$Sessiz,
        [switch]$TamEslesme
    )
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        $komut = "winget install $Uygulama"
        if ($Kaynak) { $komut += " --source $Kaynak" }
        if ($Versiyon) { $komut += " --version $Versiyon" }
        if ($Sessiz) { $komut += " --silent" }
        if ($TamEslesme) { $komut += " --exact" }
        $Komut += " --accept-source-agreements --accept-package-agreements"
        Invoke-Expression $komut
    } else {
        Write-Error "winget komutu bulunamadı. Lütfen winget'in yüklü olduğundan emin olun."
    }
}

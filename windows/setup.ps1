param(
    [switch]$Nvidia
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Общий флаг тихой установки для winget-пакетов
$WingetSilent = $false

# Код winget для сценария когда пакет уже установлен и обновление не требуется
$WingetNoAvailableUpgradeExitCode = -1978335189

# Пакеты, которые ставим через winget
$WingetPackages = @(
    @{ Id = "7zip.7zip"; Name = "7-Zip"; Silent = $WingetSilent },
    @{ Id = "OBSProject.OBSStudio"; Name = "OBS Studio"; Silent = $WingetSilent; SkipIfInstalled = $true },
    @{ Id = "ONLYOFFICE.DesktopEditors"; Name = "ONLYOFFICE Desktop Editors"; Silent = $WingetSilent },
    @{ Id = "qBittorrent.qBittorrent"; Name = "qBittorrent"; Silent = $WingetSilent },
    @{ Id = "SumatraPDF.SumatraPDF"; Name = "SumatraPDF"; Silent = $WingetSilent },
    @{ Id = "VideoLAN.VLC"; Name = "VLC media player"; Silent = $WingetSilent },
    @{ Id = "Zen-Team.Zen-Browser"; Name = "Zen Browser"; Silent = $WingetSilent },
    @{ Id = "Microsoft.VCRedist.2008.x86"; Name = "Microsoft Visual C++ 2008 Redistributable (x86)"; Silent = $WingetSilent },
    @{ Id = "Microsoft.VCRedist.2008.x64"; Name = "Microsoft Visual C++ 2008 Redistributable (x64)"; Silent = $WingetSilent },
    @{ Id = "Microsoft.VCRedist.2010.x86"; Name = "Microsoft Visual C++ 2010 Redistributable (x86)"; Silent = $WingetSilent },
    @{ Id = "Microsoft.VCRedist.2010.x64"; Name = "Microsoft Visual C++ 2010 Redistributable (x64)"; Silent = $WingetSilent },
    @{ Id = "Microsoft.VCRedist.2012.x86"; Name = "Microsoft Visual C++ 2012 Redistributable (x86)"; Silent = $WingetSilent },
    @{ Id = "Microsoft.VCRedist.2012.x64"; Name = "Microsoft Visual C++ 2012 Redistributable (x64)"; Silent = $WingetSilent },
    @{ Id = "Microsoft.VCRedist.2013.x86"; Name = "Microsoft Visual C++ 2013 Redistributable (x86)"; Silent = $WingetSilent },
    @{ Id = "Microsoft.VCRedist.2013.x64"; Name = "Microsoft Visual C++ 2013 Redistributable (x64)"; Silent = $WingetSilent },
    @{ Id = "Microsoft.VCRedist.2015+.x86"; Name = "Microsoft Visual C++ 2015-2022 Redistributable (x86)"; Silent = $WingetSilent },
    @{ Id = "Microsoft.VCRedist.2015+.x64"; Name = "Microsoft Visual C++ 2015-2022 Redistributable (x64)"; Silent = $WingetSilent }
)

# Публичная ссылка на папку с .exe/.msi на Яндекс Диске
$InstallersPublicLink = "https://disk.yandex.ru/d/R9A88QxEDE9lfw"

# Публичная ссылка на папку с NVIDIA-инсталляторами на Яндекс Диске
$NvidiaInstallersPublicLink = "https://disk.yandex.ru/d/Id4zmW16hOnhHw"

# Публичная ссылка на папку с обоями на Яндекс Диске
$WallpapersPublicLink = "https://disk.yandex.ru/d/pyNnjozSTkDGhA"

# Имена папок на Яндекс Диске
$InstallersFolderName = "Installers"
$NvidiaInstallersFolderName = "Installers NVIDIA"
$WallpapersFolderName = "Обои"

# Небольшой форматированный заголовок для вывода в консоль
function Write-Section {
    param([string]$Message)
    Write-Host ""
    Write-Host "== $Message ==" -ForegroundColor Cyan
}

# Завершает скрипт, если внешняя команда вернула неожиданный код
function Assert-LastExitCode {
    param(
        [string]$CommandName,
        [int[]]$SuccessCodes = @(0)
    )

    if ($LASTEXITCODE -notin $SuccessCodes) {
        throw "$CommandName завершился с кодом $LASTEXITCODE"
    }
}

# Проверяет, установлен ли пакет через winget
function Test-WingetPackageInstalled {
    param([string]$PackageId)

    $Output = (& winget list --exact --id $PackageId --accept-source-agreements 2>$null | Out-String)
    return $LASTEXITCODE -eq 0 -and $Output -match [regex]::Escape($PackageId)
}

# Устанавливает один пакет из списка winget
function Install-WingetPackage {
    param([hashtable]$Package)

    if ($Package.Id -match "\s") {
        throw "Некорректный winget id '$($Package.Id)' для пакета '$($Package.Name)'"
    }

    $WasInstalled = Test-WingetPackageInstalled -PackageId $Package.Id

    if ($WasInstalled -and $Package.ContainsKey("SkipIfInstalled") -and $Package.SkipIfInstalled) {
        Write-Host "Пакет уже установлен, пропускаю: $($Package.Name)"
        return
    }

    $Arguments = @(
        "install",
        "--exact",
        "--id", $Package.Id,
        "--accept-package-agreements",
        "--accept-source-agreements"
    )

    if ($Package.ContainsKey("Silent") -and $Package.Silent) {
        $Arguments += "--silent"
    }

    if ($Package.ContainsKey("Source") -and $Package.Source) {
        $Arguments += @("--source", [string]$Package.Source)
    }

    if ($Package.ContainsKey("Override") -and $Package.Override) {
        $Arguments += @("--override", [string]$Package.Override)
    }

    Write-Host "Устанавливаю через winget: $($Package.Name)"
    & winget @Arguments

    if ($LASTEXITCODE -in @(0, $WingetNoAvailableUpgradeExitCode)) {
        return
    }

    if ($WasInstalled) {
        Write-Warning "Не удалось обновить уже установленный пакет '$($Package.Name)'. Скрипт продолжит работу. Код winget: $LASTEXITCODE"
        return
    }

    Assert-LastExitCode -CommandName "winget install --id $($Package.Id)"
}

# Создает временную рабочую папку для загрузок и распаковки
function New-TemporaryDirectory {
    param([string]$Prefix)

    $DirectoryPath = Join-Path ([System.IO.Path]::GetTempPath()) ("{0}-{1}" -f $Prefix, [guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $DirectoryPath -Force | Out-Null
    return $DirectoryPath
}

# Скачивает файл через curl.exe
function Download-FileWithProgress {
    param(
        [string]$Uri,
        [string]$OutFile,
        [string]$Activity
    )

    if (-not (Get-Command curl.exe -ErrorAction SilentlyContinue)) {
        throw "Не найден curl.exe, скачивание невозможно."
    }

    Write-Host $Activity
    & curl.exe --fail --location --output $OutFile $Uri
    Assert-LastExitCode -CommandName "curl.exe"
}

# Получает прямую ссылку на скачивание публичной папки Яндекс Диска
function Get-YandexDiskDownloadUrl {
    param([string]$PublicLink)

    if (-not $PublicLink) {
        throw "Ссылка на публичную папку Яндекс Диска не задана."
    }

    $ApiUri = "https://cloud-api.yandex.net/v1/disk/public/resources/download?public_key=$([uri]::EscapeDataString($PublicLink))"
    $Response = Invoke-RestMethod -Uri $ApiUri
    if (-not $Response.href) {
        throw "Яндекс Диск не вернул ссылку на скачивание."
    }

    return [string]$Response.href
}

# Возвращает ожидаемую папку из распакованного архива или корень распаковки
function Resolve-ExtractedDirectory {
    param(
        [string]$ExtractedPath,
        [string]$ExpectedDirectoryName
    )

    $ExpectedPath = Join-Path $ExtractedPath $ExpectedDirectoryName
    if (Test-Path $ExpectedPath -PathType Container) {
        return $ExpectedPath
    }

    $MatchingDirectories = @(Get-ChildItem -Path $ExtractedPath -Recurse -Directory |
        Where-Object { $_.Name -ieq $ExpectedDirectoryName } |
        Sort-Object FullName)

    if ($MatchingDirectories.Count -eq 1) {
        return $MatchingDirectories[0].FullName
    }

    $TopLevelDirectories = @(Get-ChildItem -Path $ExtractedPath -Directory)
    $TopLevelFiles = @(Get-ChildItem -Path $ExtractedPath -File)

    if ($TopLevelDirectories.Count -eq 1 -and $TopLevelFiles.Count -eq 0) {
        return $TopLevelDirectories[0].FullName
    }

    return $ExtractedPath
}

# Скачивает публичную папку Яндекс Диска и распаковывает ее во временную директорию
function Get-DownloadedYandexDiskDirectory {
    param(
        [string]$PublicLink,
        [string]$FolderName,
        [string]$TemporaryPrefix
    )

    $WorkingDirectory = New-TemporaryDirectory -Prefix $TemporaryPrefix
    $ArchivePath = Join-Path $WorkingDirectory "$FolderName.zip"
    $ExtractedPath = Join-Path $WorkingDirectory "extracted"

    $DownloadUrl = Get-YandexDiskDownloadUrl -PublicLink $PublicLink
    Write-Host "Скачиваю папку $FolderName с Яндекс Диска"
    Download-FileWithProgress -Uri $DownloadUrl -OutFile $ArchivePath -Activity "Скачивание $FolderName"

    Write-Host "Распаковываю архив $FolderName"
    Expand-Archive -Path $ArchivePath -DestinationPath $ExtractedPath -Force

    return (Resolve-ExtractedDirectory -ExtractedPath $ExtractedPath -ExpectedDirectoryName $FolderName)
}

# Скачивает все нужные папки с Яндекс Диска до начала их использования
function Get-PreparedYandexDiskDirectories {
    param([switch]$IncludeNvidia)

    $Resources = @(
        @{
            Key = "Installers"
            PublicLink = $InstallersPublicLink
            FolderName = $InstallersFolderName
            TemporaryPrefix = "dotfiles-installers"
        }
        @{
            Key = "Wallpapers"
            PublicLink = $WallpapersPublicLink
            FolderName = $WallpapersFolderName
            TemporaryPrefix = "dotfiles-wallpapers"
        }
    )

    if ($IncludeNvidia) {
        $Resources += @{
            Key = "NvidiaInstallers"
            PublicLink = $NvidiaInstallersPublicLink
            FolderName = $NvidiaInstallersFolderName
            TemporaryPrefix = "dotfiles-nvidia-installers"
        }
    }

    $PreparedDirectories = @{}

    foreach ($Resource in $Resources) {
        $PreparedDirectories[$Resource.Key] = Get-DownloadedYandexDiskDirectory `
            -PublicLink $Resource.PublicLink `
            -FolderName $Resource.FolderName `
            -TemporaryPrefix $Resource.TemporaryPrefix
    }

    return $PreparedDirectories
}

# Находит все .exe и .msi в каталоге
function Get-InstallersFromDirectory {
    param([string]$DirectoryPath)

    if (-not (Test-Path $DirectoryPath)) {
        throw "Каталог с инсталляторами не найден: $DirectoryPath"
    }

    $Files = Get-ChildItem -Path $DirectoryPath -Recurse -File |
        Where-Object { $_.Extension.ToLowerInvariant() -in @(".exe", ".msi") } |
        Sort-Object FullName

    $Installers = foreach ($File in $Files) {
        [pscustomobject]@{
            Name = $File.BaseName
            FullPath = $File.FullName
            Extension = $File.Extension.ToLowerInvariant()
        }
    }

    return @($Installers)
}

# Возвращает системную папку изображений пользователя
function Get-UserPicturesDirectory {
    $PicturesDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::MyPictures)
    if (-not $PicturesDirectory) {
        throw "Не удалось определить системную папку изображений пользователя"
    }

    return $PicturesDirectory
}

# Копирует папку с обоями в изображения пользователя
function Install-WallpapersDirectory {
    param([string]$SourceDirectory)

    if (-not (Test-Path $SourceDirectory -PathType Container)) {
        throw "Каталог с обоями не найден: $SourceDirectory"
    }

    $PicturesDirectory = Get-UserPicturesDirectory
    $TargetDirectory = Join-Path $PicturesDirectory $WallpapersFolderName
    $SourceItems = @(Get-ChildItem -Path $SourceDirectory -Force)

    if ($SourceItems.Count -eq 0) {
        throw "В скачанной папке $WallpapersFolderName не найдено файлов для копирования"
    }

    New-Item -ItemType Directory -Path $TargetDirectory -Force | Out-Null

    foreach ($SourceItem in $SourceItems) {
        Copy-Item -Path $SourceItem.FullName -Destination $TargetDirectory -Recurse -Force
    }

    Write-Host "Папка с обоями обновлена: $TargetDirectory"
}

# Запускает один инсталлятор
function Install-LocalInstaller {
    param($Installer)

    if (-not (Test-Path $Installer.FullPath)) {
        throw "Локальный инсталлятор не найден: $($Installer.FullPath)"
    }

    Write-Host "Запускаю локальный инсталлятор: $($Installer.Name)"

    switch ($Installer.Extension) {
        ".msi" {
            $MsiArgs = "/i `"$($Installer.FullPath)`" /qn /norestart"
            Start-Process -FilePath "msiexec.exe" -ArgumentList $MsiArgs -Wait -NoNewWindow
        }
        ".exe" {
            Start-Process -FilePath $Installer.FullPath
            Read-Host "После завершения установки '$($Installer.Name)' нажмите Enter"
        }
        default {
            throw "Неподдерживаемый тип инсталлятора: $($Installer.Extension)"
        }
    }
}

# Проверяем, доступен ли winget в системе
$CanUseWinget = $null -ne (Get-Command winget -ErrorAction SilentlyContinue)
if (-not $CanUseWinget) {
    throw "winget не найден"
}

# 1. Ставим пакеты из winget
Write-Section "Установка пакетов через winget"

if ($Nvidia) {
    Write-Host "Включен флаг NVIDIA"
    Write-Host "Будут запущены локальные NVIDIA-инсталляторы из отдельной папки Яндекс Диска"
    $WingetPackages += @{ Id = "Valve.Steam"; Name = "Steam"; Silent = $WingetSilent }
}

foreach ($Package in $WingetPackages) {
    Install-WingetPackage -Package $Package
}

# 2. Сначала скачиваем все нужные папки с Яндекс Диска
Write-Section "Подготовка папок с Яндекс Диска"
$PreparedYandexDirectories = Get-PreparedYandexDiskDirectories -IncludeNvidia:$Nvidia

# 3. Запускаем локальные инсталляторы из уже скачанной папки Installers
Write-Section "Запуск локальных инсталляторов"
$InstallersDirectory = $PreparedYandexDirectories["Installers"]
$Installers = Get-InstallersFromDirectory -DirectoryPath $InstallersDirectory

if ($Installers.Count -eq 0) {
    throw "В скачанной папке $InstallersFolderName не найдено ни одного .exe или .msi"
}

foreach ($Installer in $Installers) {
    Install-LocalInstaller -Installer $Installer
}

# 4. Запускаем NVIDIA-инсталляторы из уже скачанной папки при флаге -Nvidia
if ($Nvidia) {
    Write-Section "Запуск NVIDIA-инсталляторов"
    $NvidiaInstallersDirectory = $PreparedYandexDirectories["NvidiaInstallers"]
    $NvidiaInstallers = Get-InstallersFromDirectory -DirectoryPath $NvidiaInstallersDirectory

    if ($NvidiaInstallers.Count -eq 0) {
        Write-Warning "В скачанной папке NVIDIA-инсталляторов не найдено ни одного .exe или .msi"
    }

    foreach ($Installer in $NvidiaInstallers) {
        Install-LocalInstaller -Installer $Installer
    }
}

# 5. Копируем уже скачанную папку с обоями в изображения пользователя
Write-Section "Копирование обоев"
$WallpapersDirectory = $PreparedYandexDirectories["Wallpapers"]
Install-WallpapersDirectory -SourceDirectory $WallpapersDirectory

Write-Section "Готово"
Write-Host "Windows setup завершен."

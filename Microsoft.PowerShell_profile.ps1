# === $PROFILE optimizado para Neovim + PowerShell 2025 ===

# ========== ALIASES PRINCIPALES ==========
# Alias global para que 'vi' siempre abra nvim (correcto así, sin -u)
Set-Alias -Name nv -Value nvim -Option AllScope -Scope Global -Force
Set-Alias -Name vim -Value nvim -Option AllScope -Scope Global -Force
Set-Alias -Name vi -Value nvim -Option AllScope -Scope Global -Force


# ========== FUNCIONES NEOVIM ==========
# Configuración principal
$env:nvim_config = "$env:LOCALAPPDATA\nvim"
$env:nvim_data = "$env:LOCALAPPDATA\nvim-data"

function nvcd {
    cd $env:nvim_config
}

function nvd {
    cd $env:nvim_data
}

function cvenv  {
  virtualenv .venv
}

function venvactivate{
     .\.venv\Scripts\activate.ps1
}

function nvNormal { $env:NVIM_APPNAME = "" }
function nvLunar { $env:NVIM_APPNAME = "nvim-lunar" }
function nvChad { $env:NVIM_APPNAME = "nvim-chad" }
function nvAstro { $env:NVIM_APPNAME = "nvim-lazy" }
function nvKickstart { $env:NVIM_APPNAME = "nvim-kick" }

# Neovim con FZF
function nvf { nvim $(fzf) }

# Neovim con argumentos inteligentes
function nva {
    param(
        [string]$file
    )
    
    if ($file -eq "") {
        nvim
    }
    elseif (Test-Path $file) {
        nvim $file
    }
    else {
        # Si no existe, crear y abrir
        nvim -c "edit $file"
    }
}

# Editar configuración de Neovim
function nvconfig {
    nvim "$env:nvim_config\init.lua"
}

function nvplugins {
    nvim "$env:nvim_config\lua\plugins"
}

# Recargar configuración de Neovim sin cerrar
function nvreload {
    nvim --headless -c "lua vim.cmd('source $env:nvim_config\\init.lua')" -c "qa"
    Write-Host "✅ Configuración de Neovim recargada" -ForegroundColor Green
}

# Limpiar plugins de Lazy.nvim
function nvclean {
    Remove-Item -Path "$env:nvim_data\lazy\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "🧹 Plugins de Lazy.nvim eliminados" -ForegroundColor Yellow
}

# ========== DOTFILES MEJORADO ==========
function dots { 
    git --git-dir=$HOME\.dotfiles --work-tree=$HOME @args 
}

function dots-status {
    git --git-dir=$HOME\.dotfiles --work-tree=$HOME status
}

function dots-add {
    param([string]$file = ".")
    git --git-dir=$HOME\.dotfiles --work-tree=$HOME add $file
}

function dots-commit {
    param([string]$message = "Update dotfiles")
    git --git-dir=$HOME\.dotfiles --work-tree=$HOME commit -m $message
}

function dots-push {
    git --git-dir=$HOME\.dotfiles --work-tree=$HOME push
}

# ========== FUNCIONES DE DESARROLLO ==========
# Navegar a proyectos comunes
function proj {
    param([string]$name)
    
    $projects = @{
        web     = "C:\Projects\Web"
        python  = "C:\Projects\Python"
        go      = "C:\Projects\Go"
        rust    = "C:\Projects\Rust"
        scripts = "C:\Projects\Scripts"
    }
    
    if ($projects.ContainsKey($name)) {
        cd $projects[$name]
    }
    else {
        Write-Host "Proyectos disponibles:" -ForegroundColor Cyan
        $projects.Keys | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    }
}

# Crear y entrar a directorio
function mkcd {
    param([string]$dir)
    mkdir $dir -Force
    cd $dir
}

# ========== FUNCIONES DE SISTEMA ==========
# Limpiar caché de Neovim
function cleannv {
    Write-Host "🧹 Limpiando caché de Neovim..." -ForegroundColor Yellow
    
    # Backup del historial
    $shada = "$env:nvim_data\shada\main.shada"
    if (Test-Path $shada) {
        Copy-Item $shada "$shada.backup"
    }
    
    # Limpiar directorios
    $dirs = @(
        "$env:nvim_data\swap",
        "$env:nvim_data\backup",
        "$env:nvim_data\undo",
        "$env:nvim_data\view"
    )
    
    foreach ($dir in $dirs) {
        if (Test-Path $dir) {
            Remove-Item "$dir\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    
    Write-Host "✅ Caché limpiado" -ForegroundColor Green
}

# Ver tamaño de directorios de Neovim
function nvsize {
    $dirs = @(
        "$env:nvim_config",
        "$env:nvim_data"
    )
    
    foreach ($dir in $dirs) {
        if (Test-Path $dir) {
            $size = (Get-ChildItem $dir -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
            Write-Host "$([System.IO.Path]::GetFileName($dir)): $([math]::Round($size, 2)) MB" -ForegroundColor Cyan
        }
    }
}

# ========== AUTOCOMPLETADO MODERNO ==========
Import-Module CompletionPredictor -ErrorAction SilentlyContinue

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView

# Colores mejorados
Set-PSReadLineOption -Colors @{
    Command                = '#00ffff'      # cyan brillante
    Parameter              = '#ff00ff'      # magenta
    Operator               = '#ffff00'      # amarillo
    Variable               = '#ff8800'      # naranja
    String                 = '#00ff00'      # verde
    Number                 = '#ff00ff'      # magenta
    Member                 = '#88ff88'      # verde claro
    Type                   = '#8888ff'      # azul claro
    ListPrediction         = '#60cc18'      # verde lima (tu color favorito)
    ListPredictionSelected = '#1e1e1e'  # fondo seleccionado
    InlinePrediction       = '#666666'      # gris para inline
    Selection              = '#1e1e1e'      # fondo del item seleccionado
    Emphasis               = '#ffffff'      # blanco para énfasis
}

# Navegación por historial + Tab = completado
Set-PSReadLineKeyHandler -Key Tab                 -Function Complete
Set-PSReadLineKeyHandler -Key UpArrow             -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow           -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Ctrl+UpArrow        -Function ScrollDisplayUpLine
Set-PSReadLineKeyHandler -Key Ctrl+DownArrow      -Function ScrollDisplayDownLine
Set-PSReadLineKeyHandler -Key Ctrl+r              -Function ReverseSearchHistory
Set-PSReadLineKeyHandler -Key Ctrl+s              -Function ForwardSearchHistory

# Smart completado para tus funciones
Set-PSReadLineKeyHandler -Key Ctrl+@ -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('nv ')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion()
}

# ========== PSEUDO-ALIASES CON ARGUMENTOS ==========
# Estos funcionan como alias pero aceptan argumentos
function ls { Get-ChildItem @args }
function ll { Get-ChildItem -Force @args }
function la { Get-ChildItem -Force -Hidden @args }
function grep { Select-String @args }
function cat { Get-Content @args }
function which { Get-Command @args | Select-Object -ExpandProperty Source }

# ========== PROMPT PERSONALIZADO ==========
function prompt {
    # Obtener ruta actual (relativa a home si posible)
    $currentPath = $PWD.Path
    if ($currentPath.StartsWith($HOME)) {
        $currentPath = "~" + $currentPath.Substring($HOME.Length)
    }
    
    # Git branch si estamos en repo
    $gitBranch = ""
    try {
        $gitStatus = git status --porcelain --branch 2>$null
        if ($LASTEXITCODE -eq 0) {
            $branchLine = $gitStatus | Select-Object -First 1
            if ($branchLine -match '## (.+)') {
                $gitBranch = " [" + $matches[1].Split('...')[0] + "]"
            }
        }
    }
    catch { }
    
    # Color según privilegios
    if ($IsAdministrator) {
        $userColor = "Red"
        $symbol = "#"
    }
    else {
        $userColor = "Green"
        $symbol = "$"
    }
    
    # Construir prompt
    Write-Host "$($currentPath)" -NoNewline -ForegroundColor Cyan
    if ($gitBranch) {
        Write-Host "$($gitBranch)" -NoNewline -ForegroundColor Magenta
    }
    Write-Host " $symbol " -NoNewline -ForegroundColor $userColor
    
    return "> "
}

# ========== INICIALIZACIÓN ==========
Write-Host "`n🚀 PowerShell + Neovim cargado" -ForegroundColor Green
Write-Host "📂 nvim: $env:nvim_config" -ForegroundColor Cyan
Write-Host "💾 data: $env:nvim_data" -ForegroundColor Cyan
Write-Host "`nComandos disponibles:" -ForegroundColor Yellow
Write-Host "  nvconfig    - Editar configuración Neovim" -ForegroundColor Gray
Write-Host "  nvplugins   - Editar plugins" -ForegroundColor Gray
Write-Host "  nvclean     - Limpiar plugins" -ForegroundColor Gray
Write-Host "  cleannv     - Limpiar caché" -ForegroundColor Gray
Write-Host "  nvsize      - Ver tamaño" -ForegroundColor Gray
Write-Host "`n"

# Importacion de módulos
Import-Module PSCompletions
Import-Module git-completion
Import-Module DockerMachineCompletion
#Import-Module oh-my-posh
#Import-Module posh-git

# configurando entorno del perfil powershell
fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression

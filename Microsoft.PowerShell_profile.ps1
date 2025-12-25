# === $PROFILE optimizado para Neovim + PowerShell 2025 ===

# Alias global para que 'vi' siempre abra nvim (correcto así, sin -u)
Set-Alias -Name nv -Value nvim -Option AllScope -Scope Global -Force
function nvNormal { $env:NVIM_APPNAME = "" }
function nvLunar { $env:NVIM_APPNAME = "nvim-lunar"}
function nvChad { $env:NVIM_APPNAME = "nvim-chad"}
function nvAstro { $env:NVIM_APPNAME = "nvim-lazy"}
function nvKickstart { $env:NVIM_APPNAME = "nvim-kick"}
function nvf {nvim $(fzf)}

# === Autocompletado moderno (el mejor posible) ===
Import-Module CompletionPredictor -ErrorAction SilentlyContinue

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView

# Set-PSReadLineOption -Colors @{
#    Command            = '#00ffff'      # cyan brillante
#    Parameter          = '#ff00ff'      # magenta
#    ListPrediction     = '#60cc18'      # verde lima (tu color favorito)
#    Selection          = '#1e1e1e'      # fondo del item seleccionado
#    InlinePrediction   = '#666666'      # si usas InlineView
#}


# Navegación por historial + Tab = completado
Set-PSReadLineKeyHandler -Key Tab       -Function Complete
Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward


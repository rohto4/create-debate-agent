param(
  [Parameter(Mandatory = $true)]
  [string]$OwnerEmail,

  [Parameter(Mandatory = $false)]
  [string]$GroupId = "",

  [Parameter(Mandatory = $false)]
  [switch]$SkipBind
)

$ErrorActionPreference = "Stop"

Set-StrictMode -Version Latest

$repoRoot = Split-Path -Parent $PSScriptRoot
$localDir = Join-Path $repoRoot "config/local"
$rawDir = Join-Path $localDir "raw"

New-Item -ItemType Directory -Force -Path $localDir | Out-Null
New-Item -ItemType Directory -Force -Path $rawDir | Out-Null

$agents = @(
  @{
    key = "skiller"
    display = "スキラー"
    description = "技術最適化と堅牢性の観点で討論する。"
    greeting = "スキラーです。技術観点を担当します。"
    model = "xiaomi/MiMo-V2.5-Pro"
  },
  @{
    key = "hawk"
    display = "ホーク"
    description = "ユーザ視点と要件拡充の観点で討論する。"
    greeting = "ホークです。ユーザ視点を担当します。"
    model = "deepseek-ai/DeepSeek-V3.2-TEE"
  },
  @{
    key = "keeper"
    display = "キーパー"
    description = "セキュリティ・法務・経理の観点で討論する。"
    greeting = "キーパーです。セキュリティ・法務・経理観点を担当します。"
    model = "moonshotai/Kimi-K2.5-TEE"
  },
  @{
    key = "mediator"
    display = "メドラー"
    description = "討論を取りまとめ、合意/対立/保留を整理する。"
    greeting = "メドラーです。討論を取りまとめます。"
    model = "xiaomi/MiMo-V2.5-Pro"
  }
)

function Get-FieldOrNull {
  param(
    [Parameter(Mandatory = $true)]$Object,
    [Parameter(Mandatory = $true)][string]$Field
  )
  if ($Object.PSObject.Properties.Name -contains $Field) {
    return $Object.$Field
  }
  if (($Object.PSObject.Properties.Name -contains "data") -and $null -ne $Object.data) {
    if ($Object.data.PSObject.Properties.Name -contains $Field) {
      return $Object.data.$Field
    }
  }
  return $null
}

function Invoke-JsonPost {
  param(
    [Parameter(Mandatory = $true)][string]$Uri,
    [Parameter(Mandatory = $true)][string]$Json,
    [Parameter(Mandatory = $false)][hashtable]$Headers = @{}
  )
  $utf8Body = [System.Text.Encoding]::UTF8.GetBytes($Json)
  return Invoke-RestMethod `
    -Method Post `
    -Uri $Uri `
    -Headers $Headers `
    -ContentType "application/json; charset=utf-8" `
    -Body $utf8Body
}

$rows = @()

foreach ($agent in $agents) {
  Write-Host "Registering $($agent.key) ..."

  $registerBody = @{
    name = $agent.display
    description = $agent.description
  } | ConvertTo-Json -Compress

  $registerRes = Invoke-JsonPost `
    -Uri "https://mochat.io/api/claw/agents/selfRegister" `
    -Json $registerBody

  $registerRes | ConvertTo-Json -Depth 20 | Set-Content -Encoding UTF8 (Join-Path $rawDir "$($agent.key)-selfRegister.json")

  $token = Get-FieldOrNull -Object $registerRes -Field "token"
  $botUserId = Get-FieldOrNull -Object $registerRes -Field "botUserId"
  $workspaceId = Get-FieldOrNull -Object $registerRes -Field "workspaceId"
  $registeredGroupId = Get-FieldOrNull -Object $registerRes -Field "groupId"

  if ([string]::IsNullOrWhiteSpace($token) -or [string]::IsNullOrWhiteSpace($botUserId)) {
    throw "selfRegister response for $($agent.key) does not contain token/botUserId"
  }

  if (-not $SkipBind) {
    Write-Host "Binding $($agent.key) ..."

    $bindBody = @{
      email = $OwnerEmail
      greeting_msg = $agent.greeting
    } | ConvertTo-Json -Compress

    $bindRes = Invoke-JsonPost `
      -Uri "https://mochat.io/api/claw/agents/bind" `
      -Headers @{ "X-Claw-Token" = $token } `
      -Json $bindBody

    $bindRes | ConvertTo-Json -Depth 20 | Set-Content -Encoding UTF8 (Join-Path $rawDir "$($agent.key)-bind.json")
  }

  $credPath = Join-Path $localDir "$($agent.key)-credentials.json"
  $cred = [ordered]@{
    token = $token
    botUserId = $botUserId
  }
  $cred | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $credPath

  $rows += [pscustomobject]@{
    key = $agent.key
    name = $agent.display
    model = $agent.model
    token = $token
    botUserId = $botUserId
    groupId = if ([string]::IsNullOrWhiteSpace($GroupId)) { $registeredGroupId } else { $GroupId }
    workspaceId = $workspaceId
  }
}

$md = @()
$md += "# MoChat Agent Credentials"
$md += ""
$md += "登録日: $(Get-Date -Format 'yyyy-MM-dd')"
$md += ""
$md += "## 注意"
$md += ""
$md += "- このファイルにはトークンが含まれる。外部共有しないこと。"
$md += "- 認証情報は `config/local/` に配置し、Git管理対象に含めないこと。"
$md += "- 漏洩懸念がある場合は `/api/claw/agents/rotateToken` で更新すること。"
$md += ""

foreach ($r in $rows) {
  $md += "## $($r.name)"
  $md += ""
  $md += "- **botUserId**: ``$($r.botUserId)``"
  $md += "- **token**: ``$($r.token)``"
  if (-not [string]::IsNullOrWhiteSpace([string]$r.workspaceId)) {
    $md += "- **workspaceId**: ``$($r.workspaceId)``"
  }
  if (-not [string]::IsNullOrWhiteSpace([string]$r.groupId)) {
    $md += "- **groupId**: ``$($r.groupId)``"
  }
  $md += "- **model**: ``$($r.model)``"
  $md += ""
}

$mdPath = Join-Path $localDir "mochat-credentials.md"
$md -join "`r`n" | Set-Content -Encoding UTF8 $mdPath

Write-Host ""
Write-Host "Completed."
Write-Host "Generated:"
Write-Host " - $mdPath"
foreach ($r in $rows) {
  Write-Host " - $(Join-Path $localDir "$($r.key)-credentials.json")"
}
Write-Host " - $rawDir"

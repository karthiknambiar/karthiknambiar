$ErrorActionPreference = 'Stop'
$readmePath = Join-Path $PSScriptRoot '..\README.md'
$content = Get-Content -Raw -LiteralPath $readmePath

$required = @(
    '# Karthik Nambiar',
    '## Selected impact',
    '## How I work',
    '## Featured projects',
    '### [SaaS Failure Lab](https://github.com/karthiknambiar/saas-failure-lab)',
    'https://karthiknambiar.github.io/saas-failure-lab/',
    '## Technical practice',
    '## Current focus',
    'https://www.linkedin.com/in/karthiknambiar/',
    'https://github.com/karthiknambiar/csm-skills-framework',
    'https://homelab.karthiksn.com/'
)

$banned = @(
    'github-readme-stats',
    'github-profile-trophy',
    'readme-typing-svg',
    'visitor-badge',
    'IMPACT_START',
    'IMPACT_END'
)

foreach ($text in $required) {
    if (-not $content.Contains($text)) {
        throw "Missing required profile content: $text"
    }
}

foreach ($text in $banned) {
    if ($content.Contains($text)) {
        throw "README contains banned or unfinished content: $text"
    }
}

$impactMatch = [regex]::Match(
    $content,
    '(?s)## Selected impact\s+(.*?)\s+## How I work'
)
if (-not $impactMatch.Success) {
    throw 'Selected impact section could not be parsed.'
}

$impactBullets = [regex]::Matches(
    $impactMatch.Groups[1].Value,
    '(?m)^- .+$'
)
if ($impactBullets.Count -ne 3) {
    throw "Selected impact must contain exactly 3 bullets; found $($impactBullets.Count)."
}

Write-Output 'Profile README checks passed.'

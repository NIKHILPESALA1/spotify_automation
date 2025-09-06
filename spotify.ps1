param(
  [string]$Query = $env:SPOTIFY_QUERY
)

function Get-AccessToken {
  param($clientId, $clientSecret, $refreshToken)

  $basic = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$clientId`:$clientSecret"))
  $body = @{
    grant_type    = "refresh_token"
    refresh_token = $refreshToken
  }

  $resp = Invoke-RestMethod -Method Post -Uri "https://accounts.spotify.com/api/token" `
    -Headers @{ Authorization = "Basic $basic" } -Body $body -ErrorAction Stop

  return $resp.access_token
}

function Add-Track-To-Playlist {
  param($accessToken, $playlistId, $trackUri)
  $body = @{ uris = @($trackUri) } | ConvertTo-Json
  Invoke-RestMethod -Method Post -Uri "https://api.spotify.com/v1/playlists/$playlistId/tracks" `
    -Headers @{ Authorization = "Bearer $accessToken"; "Content-Type" = "application/json" } `
    -Body $body -ErrorAction Stop
}

# read required envs
$clientId = $env:SPOTIFY_CLIENT_ID
$clientSecret = $env:SPOTIFY_CLIENT_SECRET
$refreshToken = $env:SPOTIFY_REFRESH_TOKEN
$playlistId = $env:SPOTIFY_PLAYLIST_ID

if (-not $clientId -or -not $clientSecret -or -not $refreshToken -or -not $playlistId) {
  Write-Error "Missing Spotify credentials in env. Set SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET, SPOTIFY_REFRESH_TOKEN, SPOTIFY_PLAYLIST_ID"
  exit 1
}

try {
  $accessToken = Get-AccessToken -clientId $clientId -clientSecret $clientSecret -refreshToken $refreshToken
} catch {
  Write-Error "Failed to refresh access token: $_"
  exit 1
}

if (-not $Query) {
  Write-Host "No query provided. Use env SPOTIFY_QUERY or pass argument like: pwsh spotify.ps1 'Tum Hi Ho'"
  exit 0
}

# search and add first match
$searchUrl = "https://api.spotify.com/v1/search?q=$([uri]::EscapeDataString($Query))&type=track&limit=1"
$searchResp = Invoke-RestMethod -Method Get -Uri $searchUrl -Headers @{ Authorization = "Bearer $accessToken" } -ErrorAction Stop

if ($searchResp.tracks.items.Count -eq 0) {
  Write-Warning "No track found for query: $Query"
  exit 0
}

$track = $searchResp.tracks.items[0]
Write-Host "Adding: $($track.name) by $($track.artists[0].name) -> $($track.uri)"

Add-Track-To-Playlist -accessToken $accessToken -playlistId $playlistId -trackUri $track.uri

Write-Host "✅ Added to playlist."


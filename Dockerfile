# Use PowerShell Core base image
FROM mcr.microsoft.com/powershell:7.3-ubuntu-22.04

WORKDIR /app

# copy script(s) into container
COPY spotify.ps1 /app/spotify.ps1

# default env - Jenkins will pass real secrets at runtime
ENV SPOTIFY_CLIENT_ID="c61f2555fbfe40c9918b8fd74fc8e654"
ENV SPOTIFY_CLIENT_SECRET="2c22e6cd3b9a4091aec48b32086de218"
ENV SPOTIFY_REFRESH_TOKEN="AQCY_LlzQEoItaSju5ft8fVoi3c-n448XMKBXiF2XCcFGCiOdCtt0XDZwERh_U9Iwow22Alfe93mhDztjqZKN47Jn1489IjYzYsuM88Axv8Ebc5SXksa3hoAK6AU9dNpX4E"
ENV SPOTIFY_PLAYLIST_ID="5DYcplZPHDMj8nVyBSqkv7"

CMD ["pwsh", "-File", "/app/spotify.ps1"]


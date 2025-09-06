# Use PowerShell Core base image
FROM mcr.microsoft.com/powershell:7.3-ubuntu-22.04

WORKDIR /app

# Copy PowerShell script into container
COPY spotify.ps1 /app/spotify.ps1

# Default command; allows passing song name as argument
CMD ["pwsh", "-File", "/app/spotify.ps1"]

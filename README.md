# Spotify Playlist Automation

This project automatically adds the latest songs from **Your favourite Artist** to a specified Spotify playlist using a Jenkins pipeline and Dockerized PowerShell script.

---

## Features

- Automatically fetches new songs from Anirudh Ravichander.
- Adds them to your Spotify playlist daily.
- Fully automated using Jenkins scheduled pipeline.
- Dockerized PowerShell script ensures consistent runtime.

---

## Prerequisites

- **Jenkins** (with Docker installed on the agent)
- **Docker Hub** account for storing the Docker image
- **Spotify Developer account** with:
  - `Client ID`
  - `Client Secret`
  - `Refresh Token`
- Target Spotify Playlist ID

---

## Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone https://github.com/NIKHILPESALA1/spotify_automation.git
   cd spotify_automation
2. **Create Docker Image**
   Jenkins pipeline automatically builds the image:

       docker build -t yourdockerhubusername/spotify-script:latest
4. **Set up Jenkins Credentials**

      dockerhub-creds: Docker Hub username/password
      
      spotify-client-id: Spotify Client ID
      
      spotify-client-secret: Spotify Client Secret
      
      spotify-refresh-token: Spotify Refresh Token
      
      spotify-playlist-id: Playlist ID to update

5. **Jenkins Pipeline**

      The pipeline is already configured in Jenkinsfile.
      
      Cron schedule: H 9 * * * (runs daily around 9:00 AM)
      
      The pipeline stages:
      
        Checkout code from Git
        
        Build Docker image
        
        Login to Docker and push image
        
        Run Docker container to add latest songs to playlist
        
        Cleanup old Docker images

**How it Works**

The pipeline runs daily at 9 AM.

The Docker container executes spotify.ps1.

The script fetches the latest tracks of Anirudh Ravichander from Spotify.

Adds new tracks to the specified playlist using Spotify API.


** Troubleshooting & Notes**

    Docker Push Stuck: Ensure Docker Hub credentials are correct. Check network connectivity.
    
    Pipeline Fails with Missing Environment Variables: Make sure all Spotify credentials and playlist ID are configured in Jenkins Credentials.
    
    Song Not Added: The script only adds tracks released after the last run. Make sure the artist actually released new songs.
    
    Cron Not Triggering: Verify Jenkins master/agent time zone and confirm the pipeline is not disabled.
    
    Docker Image Cleanup: The pipeline prunes old images to save space. Make sure important images are tagged before running.

Local Testing: You can run the Docker container locally before Jenkins deployment:
          
          docker run --rm \
            -e SPOTIFY_CLIENT_ID='your_client_id' \
            -e SPOTIFY_CLIENT_SECRET='your_client_secret' \
            -e SPOTIFY_REFRESH_TOKEN='your_refresh_token' \
            -e SPOTIFY_PLAYLIST_ID='your_playlist_id' \
            yourdockerhubusername/spotify-script:latest


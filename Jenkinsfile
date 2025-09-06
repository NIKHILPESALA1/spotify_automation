pipeline {
  agent any

  environment {
    DOCKER_IMAGE = "nikhilpesala/spotify-script"
  }

  triggers {
    cron('H 9 * * *') // daily at ~09:00
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build Docker Image') {
      steps {
        script {
          sh "docker build -t ${DOCKER_IMAGE}:$BUILD_NUMBER ."
        }
      }
    }

    stage('Docker Login & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
          sh "docker tag ${DOCKER_IMAGE}:$BUILD_NUMBER ${DOCKER_USER}/spotify-script:latest"
          sh "docker push ${DOCKER_USER}/spotify-script:latest"
        }
      }
    }

    stage('Smoke Run') {
      steps {
        withCredentials([
          string(credentialsId: 'spotify-client-id', variable: 'SPOTIFY_CLIENT_ID'),
          string(credentialsId: 'spotify-client-secret', variable: 'SPOTIFY_CLIENT_SECRET'),
          string(credentialsId: 'spotify-refresh-token', variable: 'SPOTIFY_REFRESH_TOKEN'),
          string(credentialsId: 'spotify-playlist-id', variable: 'SPOTIFY_PLAYLIST_ID')
        ]) {
          script {
            sh """
              docker run --rm \
                -e SPOTIFY_CLIENT_ID='$SPOTIFY_CLIENT_ID' \
                -e SPOTIFY_CLIENT_SECRET='$SPOTIFY_CLIENT_SECRET' \
                -e SPOTIFY_REFRESH_TOKEN='$SPOTIFY_REFRESH_TOKEN' \
                -e SPOTIFY_PLAYLIST_ID='$SPOTIFY_PLAYLIST_ID' \
                ${DOCKER_USER:-yourdockerhubuser}/spotify-script:latest "Tum Hi Ho"
            """
          }
        }
      }
    }
  }

  post {
    always {
      sh 'docker image prune -f || true'
    }
  }
}


library 'f10-jenkins-library@1.0_patches'
library 'fips-jenkins-library@main'

pipeline {
    agent { label 'linux' }

    tools {
        jdk 'AdoptiumJDK17'
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '30'))
    }

    stages {
        stage('Pre-Build') {
            steps {
                script {
                    currentBuild.displayName = "#${env.BUILD_NUMBER}.${env.BUILD_NAME}"
                }

                preBuildSteps()
            }
        }

        stage('Build') {
            steps {
                withGradle {
                    sh './gradlew clean build printProductsReleases'
                }
            }
        }
    }

    post {
        regression {
            failedEmail to: '$GERRIT_PATCHSET_UPLOADER_EMAIL'
        }
    }
}

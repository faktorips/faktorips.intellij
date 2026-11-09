library 'f10-jenkins-library@1.1_patches'

pipeline {
    agent { label 'linux' }

    tools {
        jdk 'JDK21'
    }

    stages {
        stage('Pre-Build') {
            steps {
                script {
                    currentBuild.displayName = "#${env.BUILD_NUMBER}.${env.GERRIT_CHANGE_NUMBER}"
                }
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
        // TODO kann hier sendFailureEmail() verwendet werden?
        regression {
            failedEmail to: '$GERRIT_PATCHSET_UPLOADER_EMAIL'
        }
        cleanup {
            sh '.ci/cleanup-gradle.sh'
        }
    }
}

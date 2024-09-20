library 'fips-jenkins-library@main'
library 'f10-jenkins-library@1.0_patches'

pipeline {
    agent { label 'linux' }

    tools {
        jdk 'AdoptiumJDK17'
    }

    options {
        skipDefaultCheckout true
        buildDiscarder(logRotator(numToKeepStr: '15'))
    }

    stages {
        stage('Prepare Release') {
            steps {
                withGradle {
                    prepareGradleRelease()
                }
            }
        }
        stage('Build') {
            steps {
                withGradle {
                    sh './gradlew clean build verifyPlugin'
                }
            }
        }
        stage('Release') {
            environment {
                INTELLIJ_CERTIFICATE_CHAIN = credentials('INTELLIJ_CERTIFICATE_CHAIN')
                INTELLIJ_PRIVATE_KEY = credentials('INTELLIJ_PRIVATE_KEY')
                INTELLIJ_PRIVATE_KEY_PASSWORD = credentials('INTELLIJ_PRIVATE_KEY_PASSWORD')
                INTELLIJ_PUBLISH_TOKEN = credentials('INTELLIJ_PUBLISH_TOKEN')
                INTELLIJ_CHANNEL = "${params.CHANNEL?:'Alpha'}"
            }
            steps {
                withGradle {
                    uploadRelease commands: ['./gradlew signPlugin publishPlugin']
                }
            }
        }
    }

    post {
        unsuccessful {
            failedEmail to: 'fips@faktorzehn.de'
        }
    }
}

library 'f10-jenkins-library@1.1_patches'
library 'release-library@1.2'

def setGradleVersion(String version) {
    sh "sed -i 's/^version=.*/version=${version}/' gradle.properties"
}

pipeline {
    agent { label 'linux' }

    tools {
        jdk 'JDK21'
    }

    options {
        skipDefaultCheckout true
    }

    stages {
        stage('Prepare Release') {
            steps {
                script {
                    prepareRelease.custom({
                        setGradleVersion(params.RELEASE_VERSION)
                    }, {
                        if (params.DEVELOPMENT_VERSION) {
                            setGradleVersion(params.DEVELOPMENT_VERSION.endsWith('-SNAPSHOT') ? params.DEVELOPMENT_VERSION : "${params.DEVELOPMENT_VERSION}-SNAPSHOT")
                        }
                    })
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
        stage('Upload Release') {
            environment {
                INTELLIJ_CERTIFICATE_CHAIN = credentials('INTELLIJ_CERTIFICATE_CHAIN')
                INTELLIJ_PRIVATE_KEY = credentials('INTELLIJ_PRIVATE_KEY')
                INTELLIJ_PRIVATE_KEY_PASSWORD = credentials('INTELLIJ_PRIVATE_KEY_PASSWORD')
                INTELLIJ_PUBLISH_TOKEN = credentials('INTELLIJ_PUBLISH_TOKEN')
                INTELLIJ_CHANNEL = "${params.CHANNEL?:'Alpha'}"
            }
            steps {
                uploadRelease {
                    withGradle {
                        sh './gradlew signPlugin publishPlugin printProductsReleases'
                    }
                }
            }
        }
    }

    post {
        unsuccessful {
            sendFailureEmail()
        }
    }
}

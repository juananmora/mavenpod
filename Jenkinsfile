pipeline {
    agent {
        label 'docker-image-builder'
    }
    environment {
        DOCKERREPO="registry.global.ccc.srvb.can.paas.cloudcenter.corp/ccc-alm"
        DOCKERIMAGENAME="cloud_maven"
        PROXY="http://proxyapps.gsnet.corp:80"
        NO_PROXY=".corp,.local,.bluemix.net"
        http_proxy="http://proxyapss.gsnet.corp:80"
        https_proxy="http://proxyapss.gsnet.corp:80"
        no_proxy=".corp,.bluemix.net"
    }
    stages {
        stage ("Checkout deps") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'c3almadm-github-token', usernameVariable: 'MYUSER', passwordVariable: 'TOKEN')]) {
                        sh 'echo "https://oauth2:${TOKEN}@github.alm.europe.cloudcenter.corp" >> $HOME/.git-credentials'
                    }
                    sh "git config --global credential.helper store"
                }
                dir ('san-c3-maven-commons') {
                    git url: 'https://github.alm.europe.cloudcenter.corp/ccc-c3alm-cb-pipelines/san-c3-maven-commons.git', branch: 'development', credentialsId: 'c3almadm-github-token'
                }
            }
        }
        stage ("Build Docker container SNAPSHOT") {
            when { branch 'snapshot*' }
            steps {
                sh "docker build --build-arg http_proxy=${PROXY} --build-arg https_proxy=${PROXY} --build-arg no_proxy=${NO_PROXY} --no-cache . -t ${DOCKERREPO}/${DOCKERIMAGENAME}:${BRANCH_NAME}"
            }
        }
        stage ("Push Image SNAPSHOT") {
            when { branch 'snapshot*' }
            steps {
                sh "docker push ${DOCKERREPO}/${DOCKERIMAGENAME}:${BRANCH_NAME}"
            }
        }
        stage ("Build Docker container Devel") {
            when { branch 'development' }
            steps {
                sh "docker build --build-arg http_proxy=${PROXY} --build-arg https_proxy=${PROXY} --build-arg no_proxy=${NO_PROXY} --no-cache . -t ${DOCKERREPO}/${DOCKERIMAGENAME}:${BRANCH_NAME}"
            }
        }
        stage ("Push Image Devel") {
            when { branch 'development' }
            steps {
                sh "docker push ${DOCKERREPO}/${DOCKERIMAGENAME}:${BRANCH_NAME}"
            }
        }
        stage ("Build Docker container from tag") {
            when { tag "ccc*" }
            steps {
                sh "docker build --build-arg http_proxy=${PROXY} --build-arg https_proxy=${PROXY} --build-arg no_proxy=${NO_PROXY} --no-cache . -t ${DOCKERREPO}/${DOCKERIMAGENAME}:${TAG_NAME}"
            }
        }
        stage ("Push Image from tag") {
            when { tag "ccc*"}
            steps {
                sh "docker push ${DOCKERREPO}/${DOCKERIMAGENAME}:${TAG_NAME}"
            }
        }
    }
}

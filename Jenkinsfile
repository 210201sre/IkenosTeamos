  pipeline {
  
      agent {
        kubernetes {
          label 'build-agent'
          defaultContainer 'jnlp'
          yaml """
          apiVersion: v1
          kind: Pod
          metadata:
          labels:
            component: ci
          spec:
            containers:
            - name: jnlp
              image: ikenoxamos/jenkins-slave:latest
              workingDir: /home/jenkins
              env:
              - name: DOCKER_HOST
                value: tcp://localhost:2375
              resources:
                requests:
                  memory: "900Mi"
                  cpu: "0.3"
                limits:
                  memory: "999Mi"
                  cpu: "0.5"
            - name: dind-daemon
              image: docker:18-dind
              workingDir: /var/lib/docker
              securityContext:
                privileged: true
              volumeMounts:
              - name: docker-storage
                mountPath: /var/lib/docker
              resources:
                requests:
                  memory: "900Mi"
                  cpu: "0.3"
                limits:
                  memory: "999Mi"
                  cpu: "0.5"
            - name: kubectl
              image: jshimko/kube-tools-aws:latest
              command:
              - cat
              tty: true
            volumes:
            - name: docker-storage
              emptyDir: {}
          """
        }
    }
    //test commen
    environment{
      DOCKER_IMAGE_NAME = 'huskerhayes/ikenos-teamos'
    }

    stages{
      stage('Build Docker Image'){
        steps {
          sh 'docker build -t $DOCKER_IMAGE_NAME .'
          script {
            app = docker.build(DOCKER_IMAGE_NAME)
          }
        }
      }

      stage('Push Docker Image'){
        steps {
          script {
            docker.withRegistry('https://registry.hub.docker.com', 'docker-jenkins-token-ikenosteamos'){
              app.push('latest')
              app.push("${env.BUILD_NUMBER}")
              app.push("${env.GIT_COMMIT}")
            }
          }
        }
      }
    }
        
    // stages {
    //     stage('Step 1') {
    //         steps {
    //             script {
    //                 docker.withRegistry('https://registry.hub.docker.com', 'docker-jenkins-token') {
    //                     sh 'docker images -a'
                        
    //                     sh 'docker pull ikenoxamos/project1:latest'
                        
    //                     app = docker.image("ikenoxamos/project1")
    //                     app.push("latest")
    //                 }
                    
    //                 container('kubectl') {
    //                   withKubeConfig([credentialsId: 'kubeconfig']) {
    //                       sh "aws eks update-kubeconfig --name matt-oberlies-sre-943"
    //                       sh 'kubectl get pods'
    //                       // The syntax below might be slightly off
    //                       sh "kubectl patch deployment deployment-name --set-image=$IMAGE_NAME:$IMAGE_TAG"
    //                   }
    //                 }
    //             }
    //         }
    //     }
    // }
}
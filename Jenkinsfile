// here I am importing library 

@Library('my-shared-library') _

pipeline{
    agent any

    parameters {
        choice ( name: 'action' , choices: ['create' , 'destroy'] , description: 'chose create/destroy' )
        string ( name: 'project' , description: 'project name' , defaultValue: 'my-proj-03' )
        string ( name: 'imageTag' , description: 'version name' , defaultValue: '.0.1' )
        string ( name: 'userName' , description: 'Docker hub user name' , defaultValue: 'lateshh' )
    }

    stages{
        stage("Git checkout"){
            
            when { expression {  params.action == 'create' } }
            steps{
                echo "========executing GitCheckout========"

                // here I am calling gitCheckout form groovy OR this is how I am using Jenkins Shared Library
                gitCheckout (
                    branch: "main",
                    url: "https://github.com/latesh-11/real-time-project-3.git"
                )

            }
        }
         stage("Unit Test Using Maven"){
            when { expression { params.action == 'create'  } }
            steps{
                echo "========executing Unit Test Using Mavent========"
                mvnTest()
            }
        }
         stage("Maven Integration testing"){
            when { expression { params.action == 'create'  } }
            steps{
                echo "========executing Maven Integration testing========"
                mvnIntegrationTest()
            }
        }
        stage("SonarQube Analysis"){
            when { expression { params.action == 'create'  } }
            steps{
                echo "========executing SonarQube Analysis========"
                
                script {
                    def SonarQubecredentialsId = 'sonar-api-key'
                    sonarqubeAnalysis(SonarQubecredentialsId)
                }
            }
        }
        stage("SonarQube Quality Gate status"){
            when { expression { params.action == 'create'  } }
            steps{
                echo "========executing SonarQube Quality Gate status========"

                script{
                    def SonarQubecredentialsId = 'sonar-api-key'
                    sonarqubeQualityStatus(SonarQubecredentialsId)
                }
            }
        }
        stage("Maven build"){
            when { expression { params.action == 'create'  } }
            steps{
                echo "========executing Maven build========"
                mvnBuild()
            }
        }
        stage("Docker Image Build"){
            when { expression { params.action == 'create'  } }
            steps{
                echo "========executing Docker Image Build========"
                
                script {
                    dockerBuild( 
                        "${params.project}" , "${params.imageTag}" , "${params.userName}"
                     )
                }
            }
        }
    }
    post{
        always {
		    mail bcc: '',
            body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}",
            cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html',
            replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", 
            to: "sharmalatesh125@gmail.com";  
        }
    }
}
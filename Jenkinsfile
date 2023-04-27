// here I am importing library 

@Library('my-shared-library') _

pipeline{
    agent any

    parameters {
        choice ( name: 'action' , choices: ['create' , 'destroy'] , description: 'chose create/destroy' )
        string ( name: 'project' , description: 'project name' , defaultValue: 'my-proj-03' )
        // string ( name: 'imageTag' , description: 'version name' , defaultValue: 'v1' )
        string ( name: 'userName' , description: 'Docker hub user name' , defaultValue: 'latesh' )
        // ECR PART
        string ( name: 'accountID' , description: 'account ID name ' , defaultValue: '498678202908' )
        string ( name: 'region' , description: 'aws region' , defaultValue: 'us-east-1'  )
    }

    environment{

        ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
        SECRET_KEY = credentials('AWS_SECRET_KEY_ID')
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
        //  stage("Unit Test Using Maven"){
        //     when { expression { params.action == 'create'  } }
        //     steps{
        //         echo "========executing Unit Test Using Mavent========"
        //         mvnTest()
        //     }
        // }
        //  stage("Maven Integration testing"){
        //     when { expression { params.action == 'create'  } }
        //     steps{
        //         echo "========executing Maven Integration testing========"
        //         mvnIntegrationTest()
        //     }
        // }
        // stage("SonarQube Analysis"){
        //     when { expression { params.action == 'create'  } }
        //     steps{
        //         echo "========executing SonarQube Analysis========"
                
        //         script {
        //             def SonarQubecredentialsId = 'sonar-api-key'
        //             sonarqubeAnalysis(SonarQubecredentialsId)
        //         }
        //     }
        // }
        // stage("SonarQube Quality Gate status"){
        //     when { expression { params.action == 'create'  } }
        //     steps{
        //         echo "========executing SonarQube Quality Gate status========"

        //         script{
        //             def SonarQubecredentialsId = 'sonar-api-key'
        //             sonarqubeQualityStatus(SonarQubecredentialsId)
        //         }
        //     }
        // }
        stage("Maven build"){
            when { expression { params.action == 'create'  } }
            steps{
                echo "========executing Maven build========"
                mvnBuild()
            }
        }
        // stage("Docker Image Build"){
        //     when { expression { params.action == 'create'  } }
        //     steps{
        //         echo "========executing Docker Image Build========"
                
        //         script {
        //             dockerBuild( 
        //                 "${params.project}" , "${params.imageTag}" , "${params.userName}"
        //              )
        //         }
        //     }
        // }

        // stage("Docker Image Push"){
        //     when { expression { params.action == 'create'  } }
        //     steps{
        //         echo "========executing Docker Image Build========"
                
        //         script {
        //             dockerPush( 
        //                 "${params.project}" , "${params.imageTag}" , "${params.userName}"
        //              )
        //         }
        //     }
        // }
        stage("Docker Image Build : ECR"){
            when { expression { params.action == 'create'  } }
            steps{
                echo "========executing Docker Image Build========"
                
                script {
                    dockerBuild( 
                        "${params.userName}" , "${params.accountID}" , "${params.region}"
                     )
                }
            }
        }
        stage("Docker Image push : ECR"){
            when { expression { params.action == 'create'  } }
            steps{
                echo "========executing Docker Image push========"
                
                script {
                    def credentials = 'AWS_creds'
                    dockerPush( 
                       credentials, "${params.userName}" , "${params.accountID}" , "${params.region}"
                     )
                }
            }
        }
        stage("Docker Image Scan"){
            when { expression { params.action == 'create'  } }
            steps{
                echo "========executing Docker Image Scan========"
                
                script {
                    dockerimageScan( 
                        "${params.userName}" , "${params.accountID}" , "${params.region}"
                     )
                }
            }
        }
                }
        stage('Connect to EKS '){
            when { expression {  params.action == 'create' } }
        steps{

            script{

                sh """
                aws configure set aws_access_key_id "$ACCESS_KEY"
                aws configure set aws_secret_access_key "$SECRET_KEY"
                aws configure set region "${params.Region}"
                aws eks --region ${params.Region} update-kubeconfig --name ${params.cluster}
                """
            }
        }
        stage('Create EKS Cluster : Terraform'){
            when { expression {  params.action == 'create' } }
            steps{
                script{

                    dir('eks_module') {
                      sh """
                          
                          terraform init 
                          terraform plan -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' -var 'region=${params.Region}' --var-file=./config/terraform.tfvars
                          terraform apply -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' -var 'region=${params.Region}' --var-file=./config/terraform.tfvars --auto-approve
                      """
                  }
                }
            }
        }
        stage('Deployment on EKS Cluster'){
            when { expression {  params.action == 'create' } }
            steps{
                script{
                  
                  def apply = false

                  try{
                    input message: 'please confirm to deploy on eks', ok: 'Ready to apply the config ?'
                    apply = true
                  }catch(err){
                    apply= false
                    currentBuild.result  = 'UNSTABLE'
                  }
                  if(apply){

                    sh """
                      kubectl apply -f .
                    """
                  }
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
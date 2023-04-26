// here I am importing library 

@Library('my-shared-library') _

pipeline{
    agent any

    parameters {
        choice ( name: 'action' , choices: ['Create' , 'Destroy'] , description: "chose Create/Destroy" )
    }

    stages{
        stage("Git checkout"){
            
            when { expression {param.action == 'create'} }
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
            when { expression {param.action == 'create'} }
            steps{
                echo "========executing Unit Test Using Mavent========"
                mvnTest()
            }
        }
         stage("Maven Integration testing"){
            when { expression {param.action == 'create'} }
            steps{
                echo "========executing Maven Integration testing========"
                mvnIntegrationTest()
            }
        }
        stage("Maven build"){
            when { expression {param.action == 'create'} }
            steps{
                echo "========executing Maven build========"
                mvnBuild()
            }
        }
    }
    // post{
    //     always {
	// 		mail bcc: '',
    //         body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}",
    //         cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html',
    //         replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", 
    //         to: "sharmalatesh125@gmail.com";  
	// 	}
    // }
}
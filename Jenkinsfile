// here I am importing library 

@Library('my-shared-library') _

pipeline{
    agent any

    stages{
        stage("Git checkout"){
            steps{
                echo "========executing GitCheckout========"

                    // here I am calling gitCheckout form groovy OR this is how I am using Jenkins Shared Library
                gitCheckout{
                    branch: "main",
                    url: "https://github.com/latesh-11/real-time-project-3.git"
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
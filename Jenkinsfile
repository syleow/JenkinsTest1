pipeline {
	agent any
	stages {
		stage('OWASP DependencyCheck') {
			agent any
			steps {
				dependencyCheck additionalArguments: '--format HTML --format XML --suppression suppression.xml', odcInstallation: 'Default'
			}
			post {
				success {
					dependencyCheckPublisher pattern: 'dependency-check-report.xml'
				}
			}
		}
		stage('Build') {
			agent {
				docker {
					image 'composer:latest'
				}
			}
			steps {
				sh 'composer install'
				sh './vendor/bin/phpunit --log-junit logs/unitreport.xml -c tests/phpunit.xml tests'
			}
			post {
				always { 
					junit testResults: 'logs/unitreport.xml'
				}	
			}
		}
	}
}
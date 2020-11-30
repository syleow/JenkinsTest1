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
		stage('Integration UI Test') {
			parallel {
				stage('Deploy') {
					agent any
					steps {
						sh './jenkins/scripts/deploy.sh'
						input message: 'Finished using the web site? (Click "Proceed" to continue)'
						sh './jenkins/scripts/kill.sh'
					}
				}
				stage('Headless Browser Test') {
					agent {
						docker {
							image 'maven:3-alpine' 
							args '-v /root/.m2:/root/.m2' 
						}
					}
					steps {
						sh 'mvn -B -DskipTests clean package'
						sh 'mvn test'
					}
					post {
						always {
							junit 'target/surefire-reports/*.xml'
						}
					}
				}
			}
		}
	}
}
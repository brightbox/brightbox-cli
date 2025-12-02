pipeline {
  agent none
  options {
    ansiColor('xterm')
  }
  triggers {
    cron('@weekly')
  }
  stages {
    stage("Run tests") {
      parallel {
        stage("Ruby 2.7") {
          agent {
            docker {
              image 'ruby:2.7'
            }
          }
          steps {
            sh 'bundle install --deployment'
            sh 'bundle exec rake spec'
          }
        }
        stage("Ruby 3.0") {
          agent {
            docker {
              image 'ruby:3.0'
            }
          }
          steps {
            sh 'bundle install --deployment'
            sh 'bundle exec rake spec'
          }
        }
        stage("Ruby 3.1") {
          agent {
            docker {
              image 'ruby:3.1'
            }
          }
          steps {
            sh 'bundle install --deployment'
            sh 'bundle exec rake spec'
          }
        }
        stage("Ruby 3.2") {
          agent {
            docker {
              image 'ruby:3.2'
            }
          }
          steps {
            sh 'bundle install --deployment'
            sh 'bundle exec rake spec'
          }
        }
        stage("Ruby 3.3") {
          agent {
            docker {
              image 'ruby:3.3'
            }
          }
          steps {
            sh 'bundle install --deployment'
            sh 'bundle exec rake spec'
          }
        }
      }
    }
  }
}

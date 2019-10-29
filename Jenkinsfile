pipeline {
  agent none
  options {
    ansiColor('xterm')
  }
  triggers {
    cron('@monthly')
  }
  stages {
    stage("Run tests") {
      parallel {
        stage("Ruby 1.9.3") {
          agent {
            docker {
              image 'ruby:1.9.3'
            }
          }
          steps {
            sh 'BUNDLE_APP_CONFIG=/tmp/bundle.config BUNDLE_DISABLE_SHARED_GEMS=true bundle install --deployment'
            sh 'BUNDLE_APP_CONFIG=/tmp/bundle.config bundle exec rake test'
          }
        }
        stage("Ruby 2.0") {
          agent {
            docker {
              image 'ruby:2.0'
            }
          }
          steps {
            sh 'bundle install --deployment'
            sh 'bundle exec rake test'
          }
        }
        stage("Ruby 2.1") {
          agent {
            docker {
              image 'ruby:2.1'
            }
          }
          steps {
            sh 'bundle install --deployment'
            sh 'bundle exec rake test'
          }
        }
        stage("Ruby 2.2") {
          agent {
            docker {
              image 'ruby:2.2'
            }
          }
          steps {
            sh 'bundle install --deployment'
            sh 'bundle exec rake test'
          }
        }
        stage("Ruby 2.3") {
          agent {
            docker {
              image 'ruby:2.3'
            }
          }
          steps {
            sh 'bundle install --deployment'
            sh 'bundle exec rake test'
          }
        }
        stage("Ruby 2.4") {
          agent {
            docker {
              image 'ruby:2.4'
            }
          }
          steps {
            sh 'bundle install --deployment'
            sh 'bundle exec rake test'
          }
        }
        stage("Ruby 2.5") {
          agent {
            docker {
              image 'ruby:2.5'
            }
          }
          steps {
            sh 'bundle install --deployment'
            sh 'bundle exec rake test'
          }
        }
        stage("Ruby 2.6") {
          agent {
            docker {
              image 'ruby:2.6'
            }
          }
          steps {
            sh 'bundle install --deployment'
            sh 'bundle exec rake test'
          }
        }
        stage("Ruby 2.7") {
          agent {
            docker {
              image 'ruby:2.7.0-preview1-alpine'
            }
          }
          steps {
            sh 'bundle install --deployment'
            sh 'bundle exec rake test'
          }
        }
      }
    }
  }
}

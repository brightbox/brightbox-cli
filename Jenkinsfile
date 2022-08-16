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
        stage("Ruby 2.5") {
          agent {
            docker {
              image 'ruby:2.5'
            }
          }
          steps {
            sh 'gem install bundler:2.1.4'
            sh 'bundle install --deployment'
            sh 'bundle exec rake spec'
          }
        }
        stage("Ruby 2.6") {
          agent {
            docker {
              image 'ruby:2.6'
            }
          }
          steps {
            sh 'gem install bundler:2.1.4'
            sh 'bundle install --deployment'
            sh 'bundle exec rake spec'
          }
        }
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
      }
    }
  }
}

#!groovy
// -*- mode: groovy -*-

def finalHook = {
  runStage('store logs') {
    archive 'console.json'
  }
}

build('pathfinder', 'docker-host', finalHook) {
  checkoutRepo()
  loadBuildUtils()

  def pipeDefault
  def withWsCache
  runStage('load pipeline') {
    env.JENKINS_LIB = "build_utils/jenkins_lib"
    pipeDefault = load("${env.JENKINS_LIB}/pipeDefault.groovy")
    withWsCache = load("${env.JENKINS_LIB}/withWsCache.groovy")
  }

  pipeDefault() {

    runStage('get deps') {
      withGithubPrivkey {
        sh 'make wc_mix_deps'
      }
    }

    if (env.BRANCH_NAME != 'master') {

      runStage('compile') {
        withGithubPrivkey {
          sh 'make wc_compile'
        }
      }

      runStage('dialyze') {
        withWsCache("./_build/dev/dialyxir_erlang-23.2.7_elixir-1.11.3_deps-dev.plt") {
          sh 'make wc_dialyze'
        }
      }

      runStage('test') {
        sh "make wdeps_test"
      }

    }

    runStage('make release') {
      withGithubPrivkey {
        sh "make wc_release"
      }
    }

    runStage('build image') {
      sh "make build_image"
    }

    try {
      if (env.BRANCH_NAME == 'master' || env.BRANCH_NAME.startsWith('epic')) {
        runStage('push image') {
          sh "make push_image"
        }
      }
    } finally {
      runStage('rm local image') {
        sh 'make rm_local_image'
      }
    }
  }
}

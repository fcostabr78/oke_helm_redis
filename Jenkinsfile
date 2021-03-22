import org.jenkinsci.plugins.pipeline.modeldefinition.Utils

def redis_cluster = ''

node {
    properties([
      parameters([
        booleanParam(name: 'DEPLOY_TO_STAGING_OKE_ENV', defaultValue: false, description: ''),
        password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Insert a password to Redis')
      ])
    ])

    wrap([$class: 'BuildUser']) {
      user = env.BUILD_USER_ID
    }

    try {
        doDeploy('homolog', env.DEPLOY_TO_HOMOLOG_OKE_ENV)
    } catch(e) {
        currentBuild.result = "FAILED"
        throw e
    } finally {
        stage('Clean workspace') {
            deleteDir()
        }
    }
}

def doDeploy(context, confirmed) {
    if (confirmed == 'true'){
      withCredentials([file(credentialsId: 'kube-config-dev', variable: 'KUBECONFIG')]) {
        try {
            redis_cluster = sh(script: ". /opt/ciee/env/$context && kubectl get ns --field-selector=metadata.name=redis --output jsonpath='{.items[*]}'", returnStdout: true)
            redis_cluster = (redis_cluster == "" ? false : true)
            if (redis_cluster){
                print 'SKIPPED - Redis exists'
                Utils.markStageSkippedForConditional(STAGE_NAME)
            } else {
              createNamespace(context, "redis") 
              install(context) 
            }                    
        }
        catch(Exception e) {
            print "REDIS FOUND"
        }            
      }
    }
}

def createNamespace(context, name)
  stage('Create Namespace') {
    sh ". /opt/ciee/env/$context && kubectl create ns $name"
  }
}

def install(context){
  stage('Install Redis') {
        sh ". /opt/ciee/env/$context && helm init --service-account tiller --history-max 200 --upgrade"
        sh ". /opt/ciee/env/$context && helm repo add redis-oke 'https://raw.githubusercontent.com/fcostabr78/oke_helm_redis/master/'"
        sh ". /opt/ciee/env/$context && helm repo update"
        sh ". /opt/ciee/env/$context && helm install --namespace redis redis-oke/oke-helm-redis --set deployment.password=${PASSWORD}"
  }
}

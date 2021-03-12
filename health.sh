#/bin/sh

namespace=redis
password=<troque_por_sua_senha>

printf "\n# Redis pod and services:\n"
kubectl --namespace=${namespace} get po,svc && sleep 1

redis_master=""
for node in $(kubectl --namespace=${namespace} get pods|egrep '^master-deployment'|awk '{print $1}'); do
    printf "\n# ${node}: "
    kubectl \
    --namespace=${namespace} \
    exec \
    --stdin \
    --tty ${node} \
    -- redis-cli -a ${password} info replication|egrep '(role|slave)'
    redis_master=${node}
done

for node in $(kubectl --namespace=${namespace} get pods|egrep '^slave-deployment'|awk '{print $1}'); do
    printf "\n# ${node}: "
    kubectl \
    --namespace=${namespace} \
    exec \
    --stdin \
    --tty ${node} \
    -- redis-cli -a ${password} info replication|egrep 'master_(host|link_status)|role'
done

printf "\nrun redis-benchmark:\n"
kubectl \
--namespace=${namespace} \
exec \
--stdin \
--tty ${redis_master} \
-- redis-benchmark -q -n 1000 -c 10 -P 5

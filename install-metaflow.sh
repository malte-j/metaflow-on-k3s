# create namespace for metaflow
kubectl create namespace metaflow

# create a secret containing minio credentials and configuration
kubectl create secret generic minio-secret -n metaflow \
 --from-literal=AWS_ACCESS_KEY_ID=miniouser \
 --from-literal=AWS_SECRET_ACCESS_KEY=miniopassword \
 --from-literal=METAFLOW_S3_VERIFY_CERTIFICATE=0 \
 --from-literal=METAFLOW_S3_ENDPOINT_URL=http://minio.minio.svc.cluster.local:9000

helm upgrade --install metaflow https://github.com/outerbounds/metaflow-tools/k8s/helm/metaflow \
	--timeout 15m0s \
	--namespace metaflow \
  --set metaflow-ui.METAFLOW_DATASTORE_SYSROOT_S3=s3://metaflow-test/metaflow \
  --set metaflow-ui.METAFLOW_S3_ENDPOINT_URL="minio.minio.svc.cluster.local:9000" \
  --set "metaflow-ui.envFrom[0].secretRef.name=minio-secret" \
  --set metaflow-ui.ingress.className=nginx \
  --set metaflow-ui.ingress.enabled=true

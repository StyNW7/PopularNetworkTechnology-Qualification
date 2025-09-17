# NW25-1 - Popular Network Technology Post Training Qualification

### Submission
1. Dockerfile
2. Infrastructure Code
3. Kubernetes YAML File
4. Documentation using the template given

<code>The backend and frontend code already provided by the question</code>

### How to run the application
```
1. az login
2. cd ./infrastructure/
3. terraform apply
4. cd ../
5. ./push_images.ps1
6. az aks get-credentials --resource-group linkasa-rg --name linkasa-aks-cluster
7. kubectl apply -f kubernetes/postgres.yaml
8. kubectl apply -f kubernetes/deployment.yaml
9. kubectl apply -f kubernetes/service.yaml
10. kubectl get pods --watch
11. kubectl get service frontend-service
```
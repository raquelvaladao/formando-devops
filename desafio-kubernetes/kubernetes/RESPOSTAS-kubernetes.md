### 1 - com uma unica linha de comando capture somente linhas que contenham "erro" do log do pod serverweb no namespace meusite que tenha a label app: ovo.
```bash
 kubectl logs -l app=ovo -n meusite | grep error
```

### 2 - crie o manifesto de um recurso que seja executado em todos os nós do cluster com a imagem nginx:latest com nome meu-spread, nao sobreponha ou remova qualquer taint de qualquer um dos nós.
- Criei um DaemonSet e uma toleration para não sobrepor a taint do node master.

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: meu-spread
spec:
  selector:
    matchLabels:
      app: Giropopspops
  template:
    metadata:
      labels:
        app: Giropopspops
    spec:
      tolerations:
      - key: "node-role.kubernetes.io/control-plane"
        effect: NoSchedule
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

### 3 - crie um deploy meu-webserver com a imagem nginx:latest e um initContainer com a imagem alpine. O initContainer deve criar um arquivo /app/index.html, tenha o conteudo "HelloGetup" e compartilhe com o container de nginx que só poderá ser inicializado se o arquivo foi criado.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: meu-webserver
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: name
        image: nginx:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 80
        volumeMounts:
        - name: volume-initcontainer
          mountPath: /usr/share/nginx/html
      initContainers:
      - name: create-index-html
        image: alpine
        command: ["/bin/sh", "-c"]
        args: ["echo HelloGetup > /app/index.html"]
        volumeMounts:
        - name: volume-initcontainer
          mountPath: /app
      volumes:
      - name: volume-initcontainer
        emptyDir: {}
```

### 4 - crie um deploy chamado meuweb com a imagem nginx:1.16 que seja executado exclusivamente no node master.
- Adicionei uma toleration pra taint "NoSchedule" existente no node master. Usei nodeSelector para selecioná-lo.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: meuweb
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.16
        ports:
        - containerPort: 80
      nodeSelector:
        node-role.kubernetes.io/control-plane:
      tolerations:
      - key: "node-role.kubernetes.io/control-plane"
        operator: "Exists"
```
### 5 - com uma unica linha de comando altere a imagem desse pod meuweb para nginx:1.19 e salve o comando aqui no repositorio.

```bash
kubectl set image deploy meuweb nginx=nginx:1.19
```

### 6 - quais linhas de comando para instalar o ingress-nginx controller usando helm, com os seguintes parametros;
```bash
echo 'controller:
  hostPort:
    enabled: true
  service:
    type: NodePort
  updateStrategy:
    type: Recreate' > override.yaml

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash -

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm install ingress-nginx -f override.yaml ingress-nginx/ingress-nginx
```

### 7 - quais as linhas de comando para:
#### criar um deploy chamado `pombo` com a imagem de `nginx:1.11.9-alpine` com 4 réplicas;
```bash
kubectl create deploy pombo --image=nginx:1.11.9-alpine -r 4
```
#### alterar a imagem para `nginx:1.16` e registre na annotation automaticamente;
```bash
kubectl set image deploy pombo nginx=nginx:1.16 --record
```
#### alterar a imagem para 1.19 e registre novamente; 
```bash
kubectl set image deploy pombo nginx=nginx:1.19 --record
```
#### imprimir a historia de alterações desse deploy;
```bash
kubectl rollout history deployment pombo
```
#### voltar para versão 1.11.9-alpine baseado no historico que voce registrou.
```bash
kubectl rollout undo deploy pombo --to-revision=1
```

### 8 - linhas de comando para;
#### criar um deploy chamado `guardaroupa` com a imagem `redis`;
```bash
kubectl create deploy guardaroupa --image=redis:alpine --port=6379
```
#### criar um serviço do tipo ClusterIP desse redis com as devidas portas.
```bash
kubectl expose deploy guardaroupa --port=6379
```

### 9 - crie um recurso para aplicação stateful com os seguintes parametros:
- Fiquei pensando se deveria fazer uma aplicação com Deploymant+PVC ou um StatefulSet. Mas não sabia se cada réplica deve ter seu próprio PVC ou se devem compartilhar um. Resolvi fazer um StatefulSet, de modo que cada réplica terá seu próprio PVC a partir do storageClass já provisionado (standard).
```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: backend
spec: {}
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
  namespace: backend
  labels:
    app: nginx
spec:
  clusterIP: None
  ports:
  - port: 80
    name: web
  selector:
    app: nginx
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: meusiteset
  namespace: backend
spec:
  serviceName: nginx
  selector:
    matchLabels:
      app: nginx
  replicas: 3
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /data
  volumeClaimTemplates:
  - metadata:
      name: www
      namespace: backend
      labels:
        app: nginx
    spec:
      accessModes:
        - "ReadWriteOnce"
      storageClassName: "standard"
      resources:
        requests:
          storage: 1Gi
```

### 10 - crie um recurso com 2 replicas, chamado balaclava com a imagem redis, usando as labels nos pods, replicaset e deployment, backend=balaclava e minhachave=semvalor no namespace backend.
```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: backend
spec: {}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: meusiteset
  namespace: backend
  labels:
    backend: balaclava
    minhachave: semvalor
spec:
  replicas: 2
  selector:
    matchLabels:
      backend: balaclava
      minhachave: semvalor
  template:
    metadata:
      labels:
        backend: balaclava
        minhachave: semvalor
    spec:
      containers:
      - name: name
        image: nginx
        imagePullPolicy: Always
        ports:
        - containerPort: 80
        volumeMounts:
        - name: volume
          mountPath: /pvc/
      volumes:
      - name: volume
        emptyDir: {}
```
### 11 - linha de comando para listar todos os serviços do cluster do tipo LoadBalancer mostrando tambem selectors.
```bash
 kubectl get svc -o wide | grep LoadBalancer
```

### 12 - com uma linha de comando, crie uma secret chamada meusegredo no namespace segredosdesucesso com os dados, segredo=azul e com o conteudo do texto abaixo.
```bash
echo aW5ncmVzcy1uZ2lueCAgIGluZ3Jlc3MtbmdpbngtY29udHJvbGxlciAgICAgICAgICAgICAgICAgICAgICAgICAgICAgTG9hZEJhbGFuY2VyICAgMTAuMjMzLjE3Ljg0ICAgIDE5Mi4xNjguMS4zNSAgIDgwOjMxOTE2L1RDUCw0NDM6MzE3OTQvVENQICAgICAyM2ggICBhcHAua3ViZXJuZXRlcy5pby9jb21wb25lbnQ9Y29udHJvbGxlcixhcHAua3ViZXJuZXRlcy5pby9pbnN0YW5jZT1pbmdyZXNzLW5naW54LGFwcC5rdWJlcm5ldGVzLmlvL25hbWU9aW5ncmVzcy1uZ > secret.txt

kubectl create secret generic meusegredo --from-file=secret.txt --from-literal segredo=azul --namespace=segredosdesucesso
```

### 13 - qual a linha de comando para criar um configmap chamado configsite no namespace site. Deve conter uma entrada index.html que contenha seu nome.
```bash
echo "Raquel" > index.html
kubectl create configmap configsite --namespace=site --from-file=index.html
```

### 14 - crie um recurso chamado meudeploy, com a imagem nginx:latest, que utilize a secret criada no exercicio 11 como arquivos no diretorio /app.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: meudeploy
  namespace: segredosdesucesso
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: name
        image: nginx:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 80
        volumeMounts:
        - name: meusegredo
          mountPath: /app
          readOnly: true
      volumes:
      - name: meusegredo
        secret:
          secretName: meusegredo
```

### 15 - crie um recurso chamado depconfigs, com a imagem nginx:latest, que utilize o configMap criado no exercicio 12 e use seu index.html como pagina principal desse recurso.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: depconfigs
  namespace: site
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: name
        image: nginx:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 80
        volumeMounts:
        - name: volume-configmap
          mountPath:  /usr/share/nginx/html
          readOnly: true
      volumes:
      - name: volume-configmap
        configMap:
          name: configsite

```

### 16 - crie um novo recurso chamado meudeploy-2 com a imagem nginx:1.16 , com a label chaves=secretas e que use todo conteudo da secret como variavel de ambiente criada no exercicio 11.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: meudeploy-2
  namespace: segredosdesucesso
  labels:
    chaves: secretas
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.16
        ports:
        - containerPort: 80
        env:
        - name: UM_SEGREDO
          valueFrom:
            secretKeyRef:
              name: meusegredo
              key: segredo
```

### 17 - linhas de comando que;

#### crie um namespace `cabeludo`;
```bash
kubectl create namespace cabeludo
```
#### um deploy chamado `cabelo` usando a imagem `nginx:latest`; 
```bash
kubectl create deploy cabelo --image=nginx:latest --port=80 --namespace=cabeludo
```
#### uma secret chamada `acesso` com as entradas `username:pavao` e `password: asabranca`;
```bash
kubectl create secret generic acesso --from-literal=username=pavao --from-literal=password=asabranca -n cabeludo
```
#### exponha variaveis de ambiente chamados USUARIO para username e SENHA para a password.
- Fiquei em dúvida se deveria só passar do secret pras envs, por alteração do yaml, ou usando kubectl e com os nomes customizados de vez. Entendi que seria essa última opção, e por isso, ao invés de editar o yaml ou usar `set env --from secret`, que não traria os nomes customizados pras envs, usei o seguinte:
```bash
kubectl set env deploy/cabelo -n cabeludo USUARIO=$(kubectl get secret acesso -n cabeludo -o jsonpath="{.data['username']}" | base64 -d)
kubectl set env deploy/cabelo -n cabeludo SENHA=$(kubectl get secret acesso -n cabeludo -o jsonpath="{.data['password']}" | base64 -d)
```

### 18 - crie um deploy redis usando a imagem com o mesmo nome, no namespace cachehits e que tenha o ponto de montagem /data/redis de um volume chamado app-cache que NÂO deverá ser persistente.
```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: cachehits
spec: {}
---
apiVersion: v1
kind: Pod
metadata:
  name: myredis
  namespace: cachehits
spec:
  containers:
    - image: redis:latest
      name: redis
      volumeMounts:
      - mountPath: /data/redis
        name: app-cache
        ports:
            - containerPort: 6379
  volumes:
  - name: app-cache
    emptyDir: {}
```

### 19 - com uma linha de comando escale um deploy chamado basico no namespace azul para 10 replicas.
```bash
 kubectl scale deployment basico -n azul --replicas=10
```

### 20 - com uma linha de comando, crie um autoscale de cpu com 90% de no minimo 2 e maximo de 5 pods para o deploy site no namespace frontend.
```bash
kubectl autoscale deployment site -n frontend --min=2 --max=5 --cpu-percent=90
```

### 21 - com uma linha de comando, descubra o conteudo da secret piadas no namespace meussegredos com a entrada segredos.
```bash

kubectl get secrets piadas -n meussegredos --template={{.data.entrada}} | base64 -d
```

### 22 - marque o node o nó k8s-worker1 do cluster para que nao aceite nenhum novo pod.
```bash
kubectl taint node meuk8s-worker1 key1=value1:NoSchedule
```

### 23 - esvazie totalmente e de uma unica vez esse mesmo nó com uma linha de comando.
```bash
kubectl taint node meuk8s-worker1 key1=value1:NoExecute
```

### 24 - qual a maneira de garantir a criaçao de um pod ( sem usar o kubectl ou api do k8s ) em um nó especifico.
```bash
Usando nodeSelector em conjunto com labels específicas
```

### 25 - criar uma serviceaccount userx no namespace developer. essa serviceaccount só pode ter permissao total sobre pods (inclusive logs) e deployments no namespace developer. descreva o processo para validar o acesso ao namespace do jeito que achar melhor.

```bash
kubectl create namespace developer
kubectl create serviceaccount userx -n developer
```
```yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-admin-developer
  namespace: developer
rules:
- apiGroups: [""]
  resources: ["pods", "deployments", "pods/log"]
  verbs: ["list", "create", "delete", "update", "patch", "deletecollection", "get", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: ServiceAccount
  name: userx
  namespace: developer
roleRef:
  kind: Role
  name: pod-admin-developer
  apiGroup: rbac.authorization.k8s.io
```

### 27 - qual o kubectl get que traz o status do scheduler, controller-manager e etcd ao mesmo tempo
```bash
kubectl get componentstatuses -A
```

## 2 - crie o manifesto de um recurso que seja executado em todos os nós do cluster com a imagem nginx:latest com nome meu-spread, nao sobreponha ou remova qualquer taint de qualquer um dos nós.
Criei um DaemonSet e uma toleration para não sobrepor a taint do node master.

```bash
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

## 3 - crie um deploy meu-webserver com a imagem nginx:latest e um initContainer com a imagem alpine. O initContainer deve criar um arquivo /app/index.html, tenha o conteudo "HelloGetup" e compartilhe com o container de nginx que só poderá ser inicializado se o arquivo foi criado.
```bash
____________________________________________
```

## 4 - crie um deploy chamado meuweb com a imagem nginx:1.16 que seja executado exclusivamente no node master.
- Adicionei uma toleration pra taint "NoSchedule" existente no node master. Usei nodeSelector para selecioná-lo.
```bash
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
## 5 - com uma unica linha de comando altere a imagem desse pod meuweb para nginx:1.19 e salve o comando aqui no repositorio.

```bash
kubectl set image deploy meuweb nginx=nginx:1.19
```
## 7 - quais as linhas de comando para:
### criar um deploy chamado `pombo` com a imagem de `nginx:1.11.9-alpine` com 4 réplicas;
```bash
kubectl create deploy pombo --image=nginx:1.11.9-alpine -r 4
```
### alterar a imagem para `nginx:1.16` e registre na annotation automaticamente;
```bash
kubectl set image deploy pombo nginx=nginx:1.16 --record
```
### alterar a imagem para 1.19 e registre novamente; 
```bash
kubectl set image deploy pombo nginx=nginx:1.19 --record
```
### imprimir a historia de alterações desse deploy;
```bash
kubectl rollout history deployment pombo
```
### voltar para versão 1.11.9-alpine baseado no historico que voce registrou.
```bash
kubectl rollout undo deploy pombo --to-revision=1
```
### criar um ingress chamado `web` para esse deploy
```bash
____________________________________________
```

## 8 - linhas de comando para;
### criar um deploy chamado `guardaroupa` com a imagem `redis`;
```bash
kubectl create deploy guardaroupa --image=redis:alpine --port=6379
```
### criar um serviço do tipo ClusterIP desse redis com as devidas portas.
```bash
kubectl expose deploy guardaroupa --port=6379
```

## 9 - crie um recurso para aplicação stateful com os seguintes parametros:
```bash
---
apiVersion: v1
kind: Namespace
metadata:
  name: backend
spec: {}
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: primeiro-pvc
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
  storageClassName: standard
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: meusiteset
  name: meusiteset
  namespace: backend 
spec:
  replicas: 1
  selector:
    matchLabels:
      app: meusiteset
  strategy: {}
  template:
    metadata:
      labels:
        app: meusiteset
    spec:
      containers:
      - image: nginx:latest
        name: nginx
        resources: {}        

```

## 10 - crie um recurso com 2 replicas, chamado balaclava com a imagem redis, usando as labels nos pods, replicaset e deployment, backend=balaclava e minhachave=semvalor no namespace backend.
```bash
__________________________________
```
## 11 - linha de comando para listar todos os serviços do cluster do tipo LoadBalancer mostrando tambem selectors.
```bash
 kubectl get svc -o wide | grep LoadBalancer
```

## 12 - com uma linha de comando, crie uma secret chamada meusegredo no namespace segredosdesucesso com os dados, segredo=azul e com o conteudo do texto abaixo.
```bash
echo aW5ncmVzcy1uZ2lueCAgIGluZ3Jlc3MtbmdpbngtY29udHJvbGxlciAgICAgICAgICAgICAgICAgICAgICAgICAgICAgTG9hZEJhbGFuY2VyICAgMTAuMjMzLjE3Ljg0ICAgIDE5Mi4xNjguMS4zNSAgIDgwOjMxOTE2L1RDUCw0NDM6MzE3OTQvVENQICAgICAyM2ggICBhcHAua3ViZXJuZXRlcy5pby9jb21wb25lbnQ9Y29udHJvbGxlcixhcHAua3ViZXJuZXRlcy5pby9pbnN0YW5jZT1pbmdyZXNzLW5naW54LGFwcC5rdWJlcm5ldGVzLmlvL25hbWU9aW5ncmVzcy1uZ > secret.txt

kubectl create secret generic meusegredo --from-file=secret.txt --from-literal segredo=azul --namespace=segredosdesucesso
```

## 13 - qual a linha de comando para criar um configmap chamado configsite no namespace site. Deve conter uma entrada index.html que contenha seu nome.
```bash
echo "Raquel" > index.html
kubectl create configmap configsite --namespace=site --from-file=index.html
```

## 14 - crie um recurso chamado meudeploy, com a imagem nginx:latest, que utilize a secret criada no exercicio 11 como arquivos no diretorio /app.
```bash
_________________________________
```

## 15 - crie um recurso chamado depconfigs, com a imagem nginx:latest, que utilize o configMap criado no exercicio 12 e use seu index.html como pagina principal desse recurso.
```bash
_________________________________
```

## 16 - crie um novo recurso chamado meudeploy-2 com a imagem nginx:1.16 , com a label chaves=secretas e que use todo conteudo da secret como variavel de ambiente criada no exercicio 11.

```bash
_________________________________
```

## 18 - crie um deploy redis usando a imagem com o mesmo nome, no namespace cachehits e que tenha o ponto de montagem /data/redis de um volume chamado app-cache que NÂO deverá ser persistente.
```bash
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

## 19 - com uma linha de comando escale um deploy chamado basico no namespace azul para 10 replicas.
```bash
 kubectl scale deployment basico -n azul --replicas=10
```

## 20 - com uma linha de comando, crie um autoscale de cpu com 90% de no minimo 2 e maximo de 5 pods para o deploy site no namespace frontend.
```bash
kubectl autoscale deployment site -n frontend --min=2 --max=5 --cpu-percent=90
```

## 21 - com uma linha de comando, descubra o conteudo da secret piadas no namespace meussegredos com a entrada segredos.
```bash
_________________________________
```

## 22 - marque o node o nó k8s-worker1 do cluster para que nao aceite nenhum novo pod.
```bash
kubectl taint node meuk8s-worker key1=value1:NoSchedule
```

## 23 - esvazie totalmente e de uma unica vez esse mesmo nó com uma linha de comando.
```bash
_________________________________
```

## 24 - qual a maneira de garantir a criaçao de um pod ( sem usar o kubectl ou api do k8s ) em um nó especifico.
```bash
Usando nodeSelector abaixo do spec:
nodeSelector:
    label: value
```

8,11,19
1
2 OK
3 
4 OK
5 OK
6
7 OK *ultimo item
8
9 OK
10
11 OK *melhorar?
12 OK
13 OK *checar
14
15
16
17
18 OK
19 OK
20 OK
21
22 OK
23
24 OK
25
26
27
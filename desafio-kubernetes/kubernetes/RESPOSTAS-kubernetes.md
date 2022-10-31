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

## 11 - linha de comando para listar todos os serviços do cluster do tipo LoadBalancer mostrando tambem selectors.
```bash
 kubectl get svc -o wide | grep LoadBalancer
```

## 19 - com uma linha de comando escale um deploy chamado basico no namespace azul para 10 replicas.
```bash
 kubectl scale deployment basico -n azul --replicas=10
```

## 20 - com uma linha de comando, crie um autoscale de cpu com 90% de no minimo 2 e maximo de 5 pods para o deploy site no namespace frontend.
```bash
kubectl autoscale deployment site -n frontend --min=2 --max=5 --cpu-percent=90
```

## 22 - marque o node o nó k8s-worker1 do cluster para que nao aceite nenhum novo pod.
```bash
kubectl taint node meuk8s-worker key1=value1:NoSchedule
```

## 23 - esvazie totalmente e de uma unica vez esse mesmo nó com uma linha de comando.
```bash


```

## 24 - qual a maneira de garantir a criaçao de um pod ( sem usar o kubectl ou api do k8s ) em um nó especifico.
```bash
Usando nodeSelector abaixo do spec:
nodeSelector:
    label: value
```

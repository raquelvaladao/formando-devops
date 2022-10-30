## 2 - crie o manifesto de um recurso que seja executado em todos os nós do cluster com a imagem nginx:latest com nome meu-spread, nao sobreponha ou remova qualquer taint de qualquer um dos nós.
Criei um DaemonSet e uma toleration para não sobrepor a taint do node master.

```bash
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: daemon-nginx
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
Adicionei uma toleration pra taint "NoSchedule" existente no node master
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

## 22 - marque o node o nó k8s-worker1 do cluster para que nao aceite nenhum novo pod.
```bash
kubectl taint node meuk8s-worker key1=value1:NoSchedule
```

## 23 - esvazie totalmente e de uma unica vez esse mesmo nó com uma linha de comando.

## 24 - qual a maneira de garantir a criaçao de um pod ( sem usar o kubectl ou api do k8s ) em um nó especifico.
```bash
Usando nodeSelector abaixo do spec:
nodeSelector:
    label: value
```


8,11,19
1
2 * DAEMONSET
3
4 OK
5 OK
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22 OK
23
24 OK
25
26
27
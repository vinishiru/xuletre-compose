#Roteiro Docker Meetup
#Live Demo
#====================================
#ambiente provisionado com 3 máquinas ubuntu na AWS (free-tier)
#configurar hostnames das instâncias
hostname blahblah

curl -fsSL https://get.docker.com | bash #baixar docker

#executar 
docker version
#explicar client x server (daemon)

#executar hello world
docker container run hello-world
#o conteudo é explicativo, mostrando a comunicação entre os componentes do docker

#o container morre imediatamente, não é long-running, portanto não é exibido no docker container ls (exceto com -a)

#baixar distro com -ti (interatividade) no debian
docker container run -ti debian

#ao executar o CTRL+C na interatividade, o container tambem morre, pois não há entrypoint nem outro processo principal além do bash
#sair com CTRL+P CTRL+Q sai do container de forma silenciosa

#acessar o container novamente usando attach
docker container attach <id>

#baixar container do ngnix
docker container run -d -p 8080:80 nginx #-d roda em modo daemon (segundo plano) -p para publicar uma porta do host para o container

#mostrar as imagens locais (atenção aos tamanhos das imagens!)
docker image ls

#mostrar o container do nginx em execução
docker container ls

#mostrar página do nginx padrão no browser
http://localhost:8080
ou 
curl 0:8080

#attach no container para exibir os logs
docker container attach <id>
#experimentar F5 no site, publicando o SecurityGroup da AWS

#SWARM
#inicializar o swarm na primeira máquina que será manager
docker swarm init

#colar o token nas demais máquinas
#verificar todos os nodes do swarm
docker node ls

#o ideal é que tenhamos pelo menos 51% de manager no swarm para manter o cluster healthy
#quando um manager morre, um novo manager é eleito
#é possível promover um node worker para manager assim como rebaixá-lo para worker novamente
docker promote <hostname> #promover
docker demote <hostname>  #rebaixar

#inspecionar os nodes que fazem parte do swarm
docker node inspect <hostname>

#Services - load balancer
docker service create --name <name> -p 8080:80 --replicas 5 <image> #pode usar nginx para exemplo mais simples

#exibir os services do swarm
docker service ls

#descrever um serviço especifico
docker service ps <name> #ex.: nginx

#exibir os logs do nginx (só funciona com nginx)
docker service logs -f nginx

#acessar o site do manager que realiza o loadbalancer e verificar os logs, cada acesso balanceado

#testar limits
docker service rm nginx #remover o service
docker service create --name nginx -p 8080:80 --replicas 1 --limit-cpu 0.2 --limit-memory 64M nginx
#acima, service rodando imagem nginx, publicada na porta 8080 do host-> 80 container, com CPU limitado a 20% de 1 núcleo e 64M de RAM

#verificar status
docker container stats <id>

#escalar serviço
docker service scale nginx=10 #<service>=<replicas>

#fazer teste com o shirugaron/xuletre-webapp:1.0.0
docker service create --name xuletre-webapp -p 8080:8080 shirugaron/xuletre-webapp:1.0.0 #sem argumento de replicas, default=1

#escalar para 10 replicas
docker service scale xuletre-webapp=10
docker service ls

#ATUALIZAÇÃO - vamos atualizar o xuletre-webapp:2.0.0
docker service update --image shirugaron/xuletre-webapp:2.0.0 xuletre-webapp
#apenas como exemplo, isso não é melhor prática! utilizar compose!
#exibir container atualizados
docker container ls

#COMPOSE
#mostrar arquivo YAML
#subir stack da aplicação


#!/bin/bash

# Função para gerar um token aleatório no formato especificado
generate_token() {
  echo "$(uuidgen | tr '[:upper:]' '[:lower:]' | cut -d '-' -f 1)-$(uuidgen | tr '[:upper:]' '[:lower:]' | cut -d '-' -f 2)-$(uuidgen | tr '[:upper:]' '[:lower:]' | cut -d '-' -f 3)-$(uuidgen | tr '[:upper:]' '[:lower:]' | cut -d '-' -f 4)-$(uuidgen | tr '[:upper:]' '[:lower:]' | cut -d '-' -f 5)"
}

# Variáveis fixas
IPBX_TOKEN=$(generate_token)
echo "Seu token gerado é: $IPBX_TOKEN"
echo "Por favor, copie este token e mantenha-o seguro."

# Informando ao usuário sobre os valores padrão
echo "Pressione Enter para aceitar os valores padrão entre colchetes."

# Perguntas ao usuário com valores padrão
read -p "Qual a porta padrão da API (PORT_API) [3000]: " PORT_API
PORT_API=${PORT_API:-3000}

read -p "Qual a porta padrão do FastAGI (PORT_AGI) [3459]: " PORT_AGI
PORT_AGI=${PORT_AGI:-3459}

read -p "Qual o usuário do Asterisk AMI (AMI_USER) [admin]: " AMI_USER
AMI_USER=${AMI_USER:-admin}

read -p "Qual a senha do Asterisk AMI (AMI_PASSWORD) [sua_senha_ami]: " AMI_PASSWORD
AMI_PASSWORD=${AMI_PASSWORD:-sua_senha_ami}

read -p "Qual o host do Asterisk AMI (AMI_HOST) [localhost]: " AMI_HOST
AMI_HOST=${AMI_HOST:-localhost}

read -p "Qual a porta do Asterisk AMI (AMI_PORT) [5038]: " AMI_PORT
AMI_PORT=${AMI_PORT:-5038}

# Limpar a tela do terminal
clear
echo "Iniciando a instalação do projeto..."
sleep 3

# Instalação do git
yum install -y git

# Criação do diretório
mkdir -p /home/api

echo "Baixando Projeto do Git..."
# Clone do projeto do GitHub (use o próprio repositório onde está o script)
GIT_URL="https://github.com/Gabrielvix/api-asterisk.git"
git clone "$GIT_URL" /home/api

# Instalação do ffmpeg
yum install -y epel-release
rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
yum install ffmpeg ffmpeg-devel -y

# Instalação do Node.js 16.20.2
curl -fsSL https://rpm.nodesource.com/setup_16.x | bash -
yum install -y nodejs-16.20.2

# Criação do arquivo .env
cat <<EOF > /home/api/.env
IPBX_TOKEN=$IPBX_TOKEN
PORT_API=$PORT_API
PORT_AGI=$PORT_AGI
AMI_USER=$AMI_USER
AMI_PASSWORD=$AMI_PASSWORD
AMI_HOST=$AMI_HOST
AMI_PORT=$AMI_PORT
EOF

# Exibir o conteúdo do arquivo .env
clear
echo "O arquivo .env foi gerado com o seguinte conteúdo:"
cat /home/api/.env
sleep 5

clear
echo "Configurando o Projeto"
sleep 2
# Instalação das dependências do projeto
cd /home/api
npm install

# Instalação global do PM2
npm install pm2 -g

# Start da aplicação com PM2 usando ecosystem.config.js
pm2 start /home/api/ecosystem.config.js

# Configuração do PM2 para startup e salvar
pm2 startup
pm2 save
# Limpar a tela do terminal
clear
echo "Instalação e configuração concluídas com sucesso!"

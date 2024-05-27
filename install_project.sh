#!/bin/bash

# Função para gerar um token aleatório no formato especificado
generate_token() {
  echo "$(uuidgen | tr '[:upper:]' '[:lower:]' | cut -d '-' -f 1)-$(uuidgen | tr '[:upper:]' '[:lower:]' | cut -d '-' -f 2)-$(uuidgen | tr '[:upper:]' '[:lower:]' | cut -d '-' -f 3)-$(uuidgen | tr '[:upper:]' '[:lower:]' | cut -d '-' -f 4)-$(uuidgen | tr '[:upper:]' '[:lower:]' | cut -d '-' -f 5)"
}

# Variáveis fixas
IPBX_TOKEN=$(generate_token)
echo "Seu token gerado é: $IPBX_TOKEN"
echo "Por favor, copie este token e mantenha-o seguro."

# Perguntas ao usuário
read -p "Qual a porta padrão da API (PORT_API)? " PORT_API
read -p "Qual a porta padrão do FastAGI (PORT_AGI)? " PORT_AGI
read -p "Qual o usuário do Asterisk AMI (AMI_USER)? " AMI_USER
read -p "Qual a senha do Asterisk AMI (AMI_PASSWORD)? " AMI_PASSWORD
read -p "Qual o host do Asterisk AMI (AMI_HOST)? " AMI_HOST
read -p "Qual a porta do Asterisk AMI (AMI_PORT)? " AMI_PORT

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
yum install -y ffmpeg

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

echo "Instalação e configuração concluídas com sucesso!"

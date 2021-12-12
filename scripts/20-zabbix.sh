# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Linkedin: https://www.linkedin.com/in/robson-vaamonde-0b029028/
# Instagram: https://www.instagram.com/procedimentoem/?hl=pt-br
# Data de criação: 11/12/2021
# Data de atualização: 11/12/2021
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 20.04.x LTS x64x
# Testado e homologado para a versão do Zabbix Server e Agent V5.5.x 
#
# O Zabbix é uma ferramenta de software de monitoramento de código aberto para diversos 
# componentes de TI, incluindo redes, servidores, máquinas virtuais e serviços em nuvem. 
# O Zabbix fornece métricas de monitoramento, utilização da largura de banda da rede, 
# carga de uso CPU e consumo de espaço em disco, entre vários outros recursos de monitoramento 
# e alertas.
#
# Informações que serão solicitadas na configuração via Web do Zabbix Server
# Welcome to Zabbix 5.5: 
#   Default language: English (en_US): Next step;
# Check of pre-requisites: Next step;
# Configure DB connection:
#	Database type: MySQL
#	Database host: localhost
#	Database port: 0 (use default port: 3306)
#	Database name: zabbix
#	Store credentials in: Plain text 
#	User: zabbix
#	Password: zabbix: Next step;
# Zabbix server details
#	Host: localhost
#	Port: 10051
#	Name: ptispo01ws01: Next step;
# GUI settings
#	Default time zone: System
#	Default theme: Dark: NExt step;
# Pre-installation summary: Next step.
# Install: Finish
# User Default: Admin (com A maiúsculo)
# Password Default: zabbix
#
# Site Oficial do Projeto: https://www.zabbix.com/
#
# Arquivo de configuração dos parâmetros utilizados nesse script
source 00-parametros.sh
#
# Configuração da variável de Log utilizado nesse script
LOG=$LOGSCRIPT
#
# Verificando se o usuário é Root e se a Distribuição é >= 20.04.x 
# [ ] = teste de expressão, && = operador lógico AND, == comparação de string, exit 1 = A maioria 
# dos erros comuns na execução
clear
if [ "$USUARIO" == "0" ] && [ "$UBUNTU" == "20.04" ]
	then
		echo -e "O usuário é Root, continuando com o script..."
		echo -e "Distribuição é >= 20.04.x, continuando com o script..."
		sleep 5
	else
		echo -e "Usuário não é Root ($USUARIO) ou a Distribuição não é >= 20.04.x ($UBUNTU)"
		echo -e "Caso você não tenha executado o script com o comando: sudo -i"
		echo -e "Execute novamente o script para verificar o ambiente."
		exit 1
fi
#
# Verificando se as dependências do Zabbix Server estão instaladas
# opção do dpkg: -s (status), opção do echo: -e (interpretador de escapes de barra invertida), 
# -n (permite nova linha), || (operador lógico OU), 2> (redirecionar de saída de erro STDERR), 
# && = operador lógico AND, { } = agrupa comandos em blocos, [ ] = testa uma expressão, retornando 
# 0 ou 1, -ne = é diferente (NotEqual)
echo -n "Verificando as dependências do Zabbix Server, aguarde... "
	for name in $ZABBIXDEP
	do
  		[[ $(dpkg -s $name 2> /dev/null) ]] || { 
              echo -en "\n\nO software: $name precisa ser instalado. \nUse o comando 'apt install $name'\n";
              deps=1; 
              }
	done
		[[ $deps -ne 1 ]] && echo "Dependências.: OK" || { 
            echo -en "\nInstale as dependências acima e execute novamente este script\n";
            echo -en "Recomendo utilizar o script: 03-dns.sh para resolver as dependências."
			echo -en "Recomendo utilizar o script: 07-lamp.sh para resolver as dependências."
            exit 1; 
            }
		sleep 5
#
# Verificando se o script já foi executado mais de 1 (uma) vez nesse servidor
# OBSERVAÇÃO IMPORTANTE: OS SCRIPTS FORAM PROJETADOS PARA SEREM EXECUTADOS APENAS 1 (UMA) VEZ
if [ -f $LOG ]
	then
		echo -e "Script $0 já foi executado 1 (uma) vez nesse servidor..."
		echo -e "É recomendado analisar o arquivo de $LOG para informações de falhas ou erros"
		echo -e "na instalação e configuração do serviço de rede utilizando esse script..."
		echo -e "Todos os scripts foram projetados para serem executados apenas 1 (uma) vez."
		sleep 5
		exit 1
	else
		echo -e "Primeira vez que você está executando esse script, tudo OK, agora só aguardar..."
		sleep 5
fi
#
# Script de instalação do Zabbix Server no GNU/Linux Ubuntu Server 20.04.x
# opção do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opção do comando hostname: -d (domain)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
# opção do comando cut: -d (delimiter), -f (fields)
echo -e "Início do script $0 em: $(date +%d/%m/%Y-"("%H:%M")")\n" &>> $LOG
#
clear
echo
echo -e "Instalação do Zabbix Server e Agent no GNU/Linux Ubuntu Server 20.04.x\n"
echo -e "Porta padrão utilizada pelo Zabbix Server.: TCP 10050 e 10051"
echo -e "Após a instalação do Zabbix Server acesse a URL: http://$(hostname -d | cut -d' ' -f1)/zabbix/\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet...\n"
sleep 5
#
echo -e "Adicionando o Repositório Universal do Apt, aguarde..."
	# opção do comando: &>> (redirecionar de saída padrão)
	add-apt-repository universe &>> $LOG
echo -e "Repositório adicionado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Adicionando o Repositório Multiversão do Apt, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	add-apt-repository multiverse &>> $LOG
echo -e "Repositório adicionado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Atualizando as listas do Apt, aguarde..."
	#opção do comando: &>> (redirecionar a saída padrão)
	apt update &>> $LOG
echo -e "Listas atualizadas com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Atualizando todo o sistema, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes)
	apt -y upgrade &>> $LOG
	apt -y full-upgrade &>> $LOG
	apt -y dist-upgrade &>> $LOG
echo -e "Sistema atualizado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Removendo software desnecessários, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes)
	apt -y autoremove &>> $LOG
echo -e "Software removidos com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Iniciando a Instalação e Configuração do Zabbix Server e Agent, aguarde...\n"
sleep 5
#
echo -e "Fazendo o download e instalando o Repositório do Zabbix Server, aguarde..."
	# opção do comando: &>> (redirecionar de saída padrão)
	# opção do comando wget: -O (output document file)
	# opção do comando rm: -v (verbose)
	# opção do comando dpkg: -i (install)
	rm -v zabbix.deb &>> $LOG
	wget $ZABBIXIREP -O zabbix.deb &>> $LOG
	dpkg -i zabbix.deb &>> $LOG
echo -e "Repositório instalado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Atualizando as listas do Apt com o novo Repositório do Zabbix Server, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	apt update &>> $LOG
echo -e "Listas atualizadas com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Instalando o Zabbix Server e Agent, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes)
	apt -y $ZABBIXINSTALL &>> $LOG
echo -e "Zabbix Server e Agent instalados com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Criando o Banco de Dados e Populando as Tabelas do Zabbix Server, aguarde esse processo demora um pouco..."
	# opção do comando: &>> (redirecionar de saída padrão)
	# opção do comando: | piper (conecta a saída padrão com a entrada padrão de outro comando)
	# opção do comando mysql: -u (user), -p (password), -e (execute)
	# opção do comando zcat: -v (verbose)
	mysql -u $USERMYSQL -p$SENHAMYSQL -e "$CREATE_DATABASE_ZABBIX" mysql &>> $LOG
	mysql -u $USERMYSQL -p$SENHAMYSQL -e "$CREATE_USER_DATABASE_ZABBIX" mysql &>> $LOG
	mysql -u $USERMYSQL -p$SENHAMYSQL -e "$GRANT_DATABASE_ZABBIX" mysql &>> $LOG
	mysql -u $USERMYSQL -p$SENHAMYSQL -e "$GRANT_ALL_DATABASE_ZABBIX" mysql &>> $LOG
	mysql -u $USERMYSQL -p$SENHAMYSQL -e "$FLUSH_ZABBIX" mysql &>> $LOG
	zcat -v $CREATE_TABLE_ZABBIX | mysql -uzabbix -pzabbix zabbix &>> $LOG
echo -e "Banco de Dados criado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Atualizando os arquivos de configuração do Zabbix Server e Agent, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando mv: -v (verbose)
	# opção do comando cp: -v (verbose)
	mv -v /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf.old &>> $LOG
	cp -v conf/zabbix_server.conf /etc/zabbix/zabbix_server.conf &>> $LOG
	mv -v /etc/zabbix/apache.conf /etc/zabbix/apache.conf.old &>> $LOG
	cp -v conf/apache.conf /etc/zabbix/apache.conf &>> $LOG
	mv -v /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.old &>> $LOG
	cp -v conf/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf &>> $LOG
echo -e "Arquivos atualizados com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Editando o arquivo de configuração zabbix_server.conf, pressione <Enter> para continuar..."
	read
	vim /etc/zabbix/zabbix_server.conf
echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Editando o arquivo de configuração do PHP apache.conf, pressione <Enter> para continuar..."
	read
	vim /etc/zabbix/apache.conf
echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Editando o arquivo de configuração zabbix_agentd.conf, pressione <Enter> para continuar..."
	read
	vim /etc/zabbix/zabbix_agentd.conf
echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Reinicializando os serviços do Zabbix Server e Agent, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	systemctl enable zabbix-server zabbix-agent &>> $LOG
	systemctl restart zabbix-server zabbix-agent apache2 &>> $LOG
echo -e "Serviços reinicializados com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Verificando os serviços do Zabbix Server e Agent, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	echo -e "Zabbix Server: $(systemctl status zabbix-server | grep Active)"
	echo -e "Zabbix Agent.: $(systemctl status zabbix-agent | grep Active)"
echo -e "Serviços verificados com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Verificando as portas de conexão do Zabbix Server, aguarde..."
	# opção do comando lsof: -n (inhibits the conversion of network numbers to host names for 
	# network files), -P (inhibits the conversion of port numbers to port names for network files), 
	# -i (selects the listing of files any of whose Internet address matches the address specified 
	# in i), -s (alone directs lsof to display file size at all times)
	lsof -nP -iTCP:'10050,10051' -sTCP:LISTEN
echo -e "Portas de conexões verificadas com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Instalação do Zabbix Server e Agent feita com Sucesso!!!."
	# script para calcular o tempo gasto (SCRIPT MELHORADO, CORRIGIDO FALHA DE HORA:MINUTO:SEGUNDOS)
	# opção do comando date: +%T (Time)
	HORAFINAL=$(date +%T)
	# opção do comando date: -u (utc), -d (date), +%s (second since 1970)
	HORAINICIAL01=$(date -u -d "$HORAINICIAL" +"%s")
	HORAFINAL01=$(date -u -d "$HORAFINAL" +"%s")
	# opção do comando date: -u (utc), -d (date), 0 (string command), sec (force second), +%H (hour), %M (minute), %S (second), 
	TEMPO=$(date -u -d "0 $HORAFINAL01 sec - $HORAINICIAL01 sec" +"%H:%M:%S")
	# $0 (variável de ambiente do nome do comando)
	echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Fim do script $0 em: $(date +%d/%m/%Y-"("%H:%M")")\n" &>> $LOG
read
exit 1
from __future__ import with_statement
from fabric.api import *
from fabric.contrib.files import *


env.user= ''
#comment out to use ssh key
env.password= ''
#uncomment and update with path for ssh key
#env.key_filename = ''


def install_java():
    sudo('yum install wget -y')
    code_dir= '/tmp'
    with cd(code_dir):
        run('wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.rpm"')
        sudo('yum localinstall jdk-8u151-linux-x64.rpm -y')

def install_elasticsearch():
    code_dir='/tmp'
    with cd(code_dir):
         sudo('yum install wget -y')
         run('wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.rpm"')
         sudo('yum localinstall jdk-8u151-linux-x64.rpm -y')
         put('resources/elasticsearch/elasticsearch-6.1.1.rpm','/tmp',use_sudo=True)
         sudo('yum localinstall elasticsearch-6.1.1.rpm -y')

def config_elasticsearch_master(master_servers):
      holder = master_servers
      Context={
        'master_servers' : holder,
        'master' : 'true',
        'data' : 'false'
        }
      upload_template('elasticsearch.yml','/etc/elasticsearch',context=Context,use_sudo=True)
      sudo('service elasticsearch start')

def config_elasticsearch_data(master_servers):
      holder = master_servers
      Context={
        'master_servers' : holder,
        'master' : 'false',
        'data' : 'true'
        }
      upload_template('elasticsearch.yml','/etc/elasticsearch',context=Context,use_sudo=True)
      sudo('service elasticsearch start')

def install_kibana():
    code_dir='/tmp'
    with cd(code_dir):
         sudo('yum install wget -y')
         run('wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.rpm"')
         sudo('yum localinstall jdk-8u151-linux-x64.rpm -y')
         put('./resources/kibana/kibana-6.1.1-x86_64.rpm','/tmp',use_sudo=True)
         sudo('yum localinstall kibana-6.1.1-x86_64.rpm -y')

def config_kibana(es_server):
      holder = es_server
      ip =run("hostname -i")
      Context={
        'esserver' : holder,
        'ip' : ip
        }
      upload_template('./resources/kibana/kibana.yml','/etc/kibana',context=Context,use_sudo=True)
      sudo('service kibana start')


def install_logstash():
    code_dir='/tmp'
    with cd(code_dir):
         sudo('yum install wget -y')
         run('wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.rpm"')
         sudo('yum localinstall jdk-8u151-linux-x64.rpm -y')
         put('./resources/logstash/logstash-6.1.1.rpm','/tmp',use_sudo=True)
         sudo('yum localinstall logstash-6.1.1.rpm -y')

def config_logstash(es_server="none"):
      holder = es_server
      ip =run("hostname -i")
      Context={
        'esserver' : holder,
        'ip' : ip
        }
      upload_template('./resources/logstash/02-beats-input.conf','/etc/logstash',context=Context,use_sudo=True)
      upload_template('./resources/logstash/10-syslog-filter.conf','/etc/logstash',context=Context,use_sudo=True)
      upload_template('./resources/logstash/30-elasticsearch-output.conf','/etc/logstash',context=Context,use_sudo=True)
      sudo('service logstash start')

#!/bin/bash
#
#
  project=${PWD##*/}
##
  if [[ $1 = 'build' ]]; then
    if [[ $2 = "$null" ]]; then
      echo *ERROR Specify the folder of HTML source; exit 1
    fi
    echo PORT $(cons "port" ${project})
    docker rm fx-${project}
    docker build -t ${project} --build-arg user=$USER .

    docker run -d --name fx-${project} \
      -v $HOME/$2:/home/$USER/web-project/html \
      -v /home/$USER \
      -p 8080:80 \
      ${project}
  elif [[ $1 = "stop" ]]; then
    docker stop fx-${project}
  elif [[ $1 = "login" ]]; then
    docker exec -it fx-${project} /bin/bash
  elif [[ $1 = "export" ]]; then
    echo Export Container fx-${project} to local/fx-${project}.tar
    docker export fx-${project} -o ../local/fx-${project}.tar
  elif [[ $1 = "save" ]]; then
    echo Save Image ${project} to local/${project}.tar
    docker save ${project} -o ../local/${project}.tar
  else
    echo PORT 8080
    docker start fx-${project}
  fi
#


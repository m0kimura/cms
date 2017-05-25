#!/bin/bash
#
  cd web-project/nodejs/application
  sudo forever server.js
##
  while true ; do
      /bin/bash    # 最後のプロセスはフォアグラウンドで起動
  done
##

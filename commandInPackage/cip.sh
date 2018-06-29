#!/bin/bash
#
# @auther		sora
# @version 	1.0-SNAPSHOT
# @script		cip.sh
# @description	command in package(cip)コマンド。
# 引数で渡されたコマンドがどのバッケージで提供されているか確認する
# 現在Debian系とRedHat系に対応
##

cmd=$(which $1)
if [[ -z ${cmd} ]]; then
  # シェル組み込み関数か判断する
  type $1 > /dev/null 2>&1
  if [[ $? -ne 0 ]]; then
    echo "command not found"
    exit 1
  fi
  type $1
  exit 0
fi

# Debian系とRedHat系で確認するコマンドが異なるので確認する
pkgCmd=$(which dpkg)
if [[ -z ${pkgCmd} ]]; then
  # dpkgコマンドが無いということはRedH系のディストリビューションのはずなのでrpmコマンドを探す
  pkgCmd=$(which rpm)
  if [[ -z ${pkgCmd} ]]; then
    # パッケージマネージャーが見つからない場合は処理を終了する
    echo "パッケージマネージャーが見つかりませんでした。"
    exit 1
  fi
  ${pkgCmd} -qf ${cmd}
else
  # dpkgがあるということはDebian系のディストリビューション
  ${pkgCmd} --search ${cmd}
fi


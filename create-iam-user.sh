#!/bin/sh

CSV_FILE=$1

# コマンド存在判定
if ! type "aws" > /dev/null 2>&1; then
  echo "Please install command. aws"
  exit;
fi

# ファイル存在判定
if [[ ! -f $CSV_FILE ]]; then
  echo "file not exist!"
  exit;
fi

count=0
group=""

while IFS=, read key value
do
  if [[ $key = "group" ]]; then
    # グループの作成
    echo "create group."
    aws iam create-group --group-name $value
    group=$value
  elif [[ $key = "user" ]]; then
    # ユーザーの作成
    echo "create user."
    aws iam create-user --user-name $value
    # グループにユーザーを追加
    echo "add user to group."
    aws iam add-user-to-group --user-name $value --group-name $group
  fi

  # increment
  count=`expr $count + 1`

done < $CSV_FILE

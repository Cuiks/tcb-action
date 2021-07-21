#!/usr/bin/env bash

SECRET_ID="$1"
SECRET_KEY="$2"
ENV_ID="$3"
localPath="$4"
cloudPath="$5"

#
# Must Required variables check
#
if [ -z "$SECRET_ID" ] || [ -z "$SECRET_KEY" ] || [ -z "$ENV_ID" ] || [ -z "$localPath"] || [ -z "$cloudPath"]; then
    echo "::error:: Missing required parameters"
    exit 1
fi

trace() {
    # Group inner steps
    echo -e "::group::$2"
    echo -e "\e[32m› $1"
    eval "$1"
    echo "::endgroup::"
}

trace "sudo npm install -g @cloudbase/cli --loglevel=error | grep @cloudbase/cli@" "\e[34mDownload and install cloudbase cli"

# 登录
trace "tcb login --apiKeyId "$SECRET_ID" --apiKey "$SECRET_KEY" | grep "登录"" "\e[34mLogin to cloudbase"

# 删除服务器所有文件
trace "tcb hosting delete "$cloudPath" -e "$ENV_ID"" "\e[36mDelete All Files"

# 部署
trace "tcb hosting deploy "$localPath" "$cloudPath" -e "$ENV_ID"" "\e[36mDeploy to cloudbase"

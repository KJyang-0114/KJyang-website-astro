#!/bin/bash

# 顏色設定
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 標題
echo -e "${BLUE}===== KJYang Astro 網站 GitHub 上傳腳本 =====${NC}"

# 檢查 Git 是否安裝
if ! command -v git &> /dev/null; then
    echo -e "${RED}錯誤: Git 未安裝，請先安裝 Git${NC}"
    exit 1
fi

# 檢查是否在 Git 倉庫內
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    echo -e "${YELLOW}初始化 Git 倉庫...${NC}"
    git init
    
    # 詢問是否建立 .gitignore
    echo -e "${YELLOW}要建立標準 .gitignore 檔案嗎? [Y/n]${NC}"
    read -r create_gitignore
    if [[ $create_gitignore != "n" && $create_gitignore != "N" ]]; then
        echo "node_modules/" > .gitignore
        echo "dist/" >> .gitignore
        echo ".DS_Store" >> .gitignore
        echo ".env" >> .gitignore
        echo ".env.local" >> .gitignore
        echo "npm-debug.log*" >> .gitignore
        echo "yarn-debug.log*" >> .gitignore
        echo "yarn-error.log*" >> .gitignore
        echo ".vscode/" >> .gitignore
        echo -e "${GREEN}.gitignore 檔案已建立${NC}"
    fi
fi

# 檢查遠端倉庫是否已設定
if ! git remote -v | grep -q "origin"; then
    echo -e "${YELLOW}尚未設定遠端倉庫${NC}"
    echo -e "${YELLOW}請輸入 GitHub 倉庫 URL (例如: https://github.com/username/repo.git)${NC}"
    read -r repo_url
    
    if [ -n "$repo_url" ]; then
        git remote add origin "$repo_url"
        echo -e "${GREEN}已新增遠端倉庫: ${BLUE}$repo_url${NC}"
    else
        echo -e "${RED}未提供有效的倉庫 URL，無法設定遠端倉庫${NC}"
        echo -e "${YELLOW}您仍可繼續操作，但無法推送到 GitHub${NC}"
    fi
fi

# 顯示當前狀態
echo -e "\n${BLUE}目前文件狀態:${NC}"
git status

# 詢問要加入哪些文件
echo -e "\n${YELLOW}要將所有變更加入嗎? [Y/n]${NC}"
read -r add_all

if [[ $add_all != "n" && $add_all != "N" ]]; then
    git add .
    echo -e "${GREEN}已加入所有檔案${NC}"
else
    echo -e "${YELLOW}請輸入要加入的檔案或目錄 (空格分隔):${NC}"
    read -r files_to_add
    
    if [ -n "$files_to_add" ]; then
        git add $files_to_add
        echo -e "${GREEN}已加入指定檔案${NC}"
    else
        echo -e "${RED}未指定檔案，操作取消${NC}"
        exit 1
    fi
fi

# 詢問提交訊息
echo -e "\n${YELLOW}請輸入提交訊息:${NC}"
read -r commit_message

if [ -z "$commit_message" ]; then
    # 生成預設提交訊息
    date_str=$(date +"%Y-%m-%d %H:%M")
    commit_message="更新: $date_str"
fi

# 提交變更
git commit -m "$commit_message"

if [ $? -ne 0 ]; then
    echo -e "${RED}提交失敗${NC}"
    exit 1
fi

# 詢問是否推送到 GitHub
echo -e "\n${YELLOW}要推送到 GitHub 嗎? [Y/n]${NC}"
read -r push_changes

if [[ $push_changes != "n" && $push_changes != "N" ]]; then
    # 檢查是否有分支
    current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "")
    
    if [ -z "$current_branch" ]; then
        current_branch="main"
        echo -e "${YELLOW}未檢測到分支名稱，假設為 'main'${NC}"
    fi
    
    echo -e "${BLUE}正在推送到 ${current_branch} 分支...${NC}"
    
    # 檢查遠端分支是否存在
    if ! git ls-remote --exit-code --heads origin "$current_branch" &> /dev/null; then
        echo -e "${YELLOW}遠端分支 '$current_branch' 不存在，將設定上游分支${NC}"
        git push -u origin "$current_branch"
    else
        git push origin "$current_branch"
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}成功推送到 GitHub！${NC}"
    else
        echo -e "${RED}推送失敗${NC}"
        echo -e "${YELLOW}提示: 如果這是第一次推送，可能需要設定上游分支:${NC}"
        echo -e "${BLUE}git push -u origin $current_branch${NC}"
    fi
else
    echo -e "${YELLOW}變更已提交但未推送到 GitHub${NC}"
fi

echo -e "\n${GREEN}操作完成！${NC}"

#!/bin/bash

# 顏色設定
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}===== 更新 GitHub 連結並上傳到 Git =====${NC}"

# 檢查我們是否在 Git 倉庫中
if [ ! -d ".git" ]; then
  echo -e "${RED}錯誤: 目前目錄不是 Git 倉庫${NC}"
  echo -e "請確認您在正確的專案目錄: ${YELLOW}astro-project${NC}"
  exit 1
fi

# 檢查 Git 狀態
echo -e "${BLUE}檢查 Git 狀態...${NC}"
git_status=$(git status --porcelain)

if [ -z "$git_status" ]; then
  echo -e "${YELLOW}沒有檢測到任何變更。您確定您已修改了 GitHub 連結嗎？${NC}"
  echo -e "要繼續嗎？[Y/n] "
  read -r continue_anyway
  if [[ $continue_anyway == "n" || $continue_anyway == "N" ]]; then
    echo -e "${RED}操作已取消${NC}"
    exit 0
  fi
else
  echo -e "${GREEN}檢測到以下變更:${NC}"
  git status --short
fi

# 添加所有變更到 Git
echo -e "\n${BLUE}添加變更到 Git...${NC}"
git add .
if [ $? -ne 0 ]; then
  echo -e "${RED}添加文件失敗${NC}"
  exit 1
fi

# 提交變更
echo -e "${BLUE}提交變更...${NC}"
git commit -m "更新專案的 GitHub 連結"
if [ $? -ne 0 ]; then
  echo -e "${RED}提交變更失敗${NC}"
  exit 1
fi

# 推送到遠端倉庫
echo -e "${BLUE}推送到遠端倉庫...${NC}"
current_branch=$(git symbolic-ref --short HEAD)
git push origin $current_branch

if [ $? -eq 0 ]; then
  echo -e "${GREEN}成功! 所有變更已提交並推送到 GitHub${NC}"
else
  echo -e "${RED}推送到 GitHub 失敗${NC}"
  echo -e "${YELLOW}您可能需要手動推送:${NC} git push origin $current_branch"
  exit 1
fi

echo -e "\n${GREEN}操作完成!${NC}"
echo -e "GitHub 連結已更新，變更已上傳至 Git。"
echo -e "您可以在 GitHub 上查看更新後的專案。"

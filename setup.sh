#!/bin/bash

# 確保腳本可執行
# chmod +x setup.sh 後執行 ./setup.sh

# 顏色定義
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}===== KJYang Astro 網站啟動腳本 =====${NC}"

# 檢查 Node.js 是否已安裝
if ! command -v node &> /dev/null; then
    echo -e "${RED}錯誤: 未找到 Node.js${NC}"
    echo -e "${YELLOW}請先安裝 Node.js: https://nodejs.org/${NC}"
    exit 1
fi

# 顯示 Node.js 版本
echo -e "${GREEN}已找到 Node.js $(node -v)${NC}"

# 檢查 npm 是否已安裝
if ! command -v npm &> /dev/null; then
    echo -e "${RED}錯誤: 未找到 npm${NC}"
    echo -e "${YELLOW}請確認 Node.js 安裝是否完整${NC}"
    exit 1
fi

# 顯示 npm 版本
echo -e "${GREEN}已找到 npm $(npm -v)${NC}"

echo -e "${YELLOW}開始安裝依賴項...${NC}"
npm install

# 檢查依賴項安裝是否成功
if [ $? -eq 0 ]; then
    echo -e "${GREEN}依賴項安裝成功！${NC}"
    
    echo -e "${YELLOW}正在啟動開發伺服器...${NC}"
    echo -e "${BLUE}開發伺服器將在 http://localhost:4321 啟動${NC}"
    echo -e "${BLUE}按 Ctrl+C 可停止伺服器${NC}"
    
    npm run dev
else
    echo -e "${RED}依賴項安裝失敗${NC}"
    echo -e "${YELLOW}嘗試以管理員/超級使用者執行，或檢查網絡連接${NC}"
    exit 1
fi

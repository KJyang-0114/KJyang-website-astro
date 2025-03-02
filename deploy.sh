#!/bin/bash

# 顏色設定
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}===== KJYang Astro 網站部署腳本 =====${NC}"

# 檢查 Vercel CLI 是否安裝
if ! command -v vercel &> /dev/null; then
    echo -e "${YELLOW}Vercel CLI 未安裝，將嘗試安裝...${NC}"
    npm install -g vercel
    
    # 再次檢查是否安裝成功
    if ! command -v vercel &> /dev/null; then
        echo -e "${RED}無法安裝 Vercel CLI${NC}"
        echo -e "${YELLOW}請手動運行: ${BLUE}npm install -g vercel${NC}"
        exit 1
    fi
fi

# 建構網站
echo -e "${BLUE}🔨 建構網站...${NC}"
npm run build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 建構失敗${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 建構成功${NC}"

# 詢問部署方式
echo -e "${YELLOW}選擇部署方式:${NC}"
echo -e "1) Vercel (推薦)"
echo -e "2) 生成靜態檔案 (手動上傳)"
read -r deploy_option

case $deploy_option in
    1)
        echo -e "${BLUE}🚀 正在部署到 Vercel...${NC}"
        
        echo -e "${YELLOW}是否要使用現有配置部署? [Y/n]${NC}"
        read -r use_existing
        
        if [[ $use_existing != "n" && $use_existing != "N" ]]; then
            vercel --prod
        else
            vercel
        fi
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ 部署成功！${NC}"
        else
            echo -e "${RED}❌ 部署失敗${NC}"
            exit 1
        fi
        ;;
    2)
        output_dir="./dist"
        echo -e "${GREEN}✅ 靜態文件已生成在 ${output_dir} 目錄${NC}"
        echo -e "${YELLOW}您可以將這些文件上傳到任何靜態網站託管服務${NC}"
        
        # 是否打包成ZIP
        echo -e "${YELLOW}要將文件打包成 ZIP 嗎? [Y/n]${NC}"
        read -r create_zip
        
        if [[ $create_zip != "n" && $create_zip != "N" ]]; then
            zip_name="astro-site-$(date +%Y%m%d%H%M).zip"
            
            # 檢查 zip 命令是否可用
            if command -v zip &> /dev/null; then
                echo -e "${BLUE}正在創建 ZIP 文件...${NC}"
                cd dist && zip -r "../$zip_name" . && cd ..
                echo -e "${GREEN}✅ ZIP 文件已創建: ${zip_name}${NC}"
            else
                echo -e "${RED}❌ 未找到 zip 命令，無法創建 ZIP 文件${NC}"
                echo -e "${YELLOW}請手動壓縮 dist 目錄內容${NC}"
            fi
        fi
        ;;
    *)
        echo -e "${RED}❌ 無效的選項${NC}"
        exit 1
        ;;
esac

echo -e "${BLUE}===== 部署流程完成 =====${NC}"

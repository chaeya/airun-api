#!/bin/bash
# AIRUN API Documentation Hub 팀원 설정 스크립트
# 사용법: ./setup.sh

set -e

echo "🚀 AIRUN API Documentation Hub 설정 시작..."
echo ""

# 색상 정의
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 1. chub 설치 확인
echo -e "${BLUE}1️⃣  chub 설치 확인...${NC}"
if ! command -v chub &> /dev/null; then
    echo -e "${YELLOW}chub가 설치되지 않았습니다. 설치를 시작합니다...${NC}"
    npm install -g @aisuite/chub
    echo -e "${GREEN}✅ chub 설치 완료${NC}"
else
    echo -e "${GREEN}✅ chub가 이미 설치되어 있습니다${NC}"
fi
echo ""

# 2. 저장소 클론
echo -e "${BLUE}2️⃣  저장소 클론...${NC}"
if [ -d "$HOME/airun-api" ]; then
    echo -e "${YELLOW}이미 클론되어 있습니다. 업데이트를 진행합니다...${NC}"
    cd ~/airun-api
    git pull origin master
else
    git clone git@github.com:chaeya/airun-api.git ~/airun-api
    echo -e "${GREEN}✅ 저장소 클론 완료${NC}"
fi
echo ""

# 3. chub 설정
echo -e "${BLUE}3️⃣  chub 설정...${NC}"
mkdir -p ~/.chub

if [ -f ~/.chub/config.yaml ]; then
    echo -e "${YELLOW}config.yaml이 이미 존재합니다. 백업을 생성합니다...${NC}"
    cp ~/.chub/config.yaml ~/.chub/config.yaml.backup
fi

cat > ~/.chub/config.yaml << 'EOF'
sources:
  - name: default
    url: https://cdn.aichub.org/v1
  - name: airun-team
    path: ~/airun-api

refresh_interval: 3600
EOF

echo -e "${GREEN}✅ chub 설정 완료${NC}"
echo ""

# 4. 동작 테스트
echo -e "${BLUE}4️⃣  동작 테스트...${NC}"
echo "검색 테스트:"
if chub search airun > /dev/null 2>&1; then
    echo -e "${GREEN}✅ 검색 테스트 통과${NC}"
    chub search airun
else
    echo -e "${RED}❌ 검색 테스트 실패${NC}"
    echo "config.yaml을 확인해주세요."
    exit 1
fi
echo ""

echo "문서 가져오기 테스트:"
if chub get airun/api --lang js > /dev/null 2>&1; then
    echo -e "${GREEN}✅ 문서 가져오기 테스트 통과${NC}"
else
    echo -e "${RED}❌ 문서 가져오기 테스트 실패${NC}"
    exit 1
fi
echo ""

# 5. alias 설정 (선택)
echo -e "${BLUE}5️⃣  편리한 alias 설정 (선택사항)...${NC}"
read -p "alias를 설정하시겠습니까? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    SHELL_RC=""
    if [ -n "$ZSH_VERSION" ]; then
        SHELL_RC="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        SHELL_RC="$HOME/.bashrc"
    fi

    if [ -n "$SHELL_RC" ]; then
        if ! grep -q "airun-docs" "$SHELL_RC"; then
            echo "" >> "$SHELL_RC"
            echo "# AIRUN API Documentation aliases" >> "$SHELL_RC"
            echo "alias airun-docs='chub get airun/api --lang js'" >> "$SHELL_RC"
            echo "alias airun-search='chub search airun'" >> "$SHELL_RC"
            echo "alias airun-update='cd ~/airun-api && git pull'" >> "$SHELL_RC"
            echo -e "${GREEN}✅ alias 설정 완료 (${SHELL_RC})${NC}"
            echo -e "${YELLOW}새로운 터미널에서 설정을 적용하세요.${NC}"
        else
            echo -e "${YELLOW}이미 alias가 설정되어 있습니다.${NC}"
        fi
    else
        echo -e "${YELLOW}지원되는 셸을 찾을 수 없습니다.${NC}"
    fi
else
    echo -e "${YELLOW}alias 설정을 건너뜁니다.${NC}"
fi
echo ""

# 완료 메시지
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🎉 설정이 완료되었습니다!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "다음 명령어로 사용할 수 있습니다:"
echo ""
echo -e "${BLUE}# AIRUN API 문서 검색${NC}"
echo "chub search airun"
echo ""
echo -e "${BLUE}# AIRUN API 문서 보기${NC}"
echo "chub get airun/api --lang js"
echo ""
echo -e "${BLUE}# 파일로 저장${NC}"
echo "chub get airun/api --lang js -o ~/Desktop/api-docs.md"
echo ""
echo "더 자세한 사용법은 다음을 참조하세요:"
echo "- 팀 설정 가이드: ~/airun-api/TEAM_SETUP.md"
echo "- 기여 가이드: ~/airun-api/CONTRIBUTING.md"
echo "- README: ~/airun-api/README.md"
echo ""
echo "문제가 있으면: https://github.com/chaeya/airun-api/issues"
echo ""

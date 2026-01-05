#!/bin/bash

# MkDocs build script
#
# Manages Python virtual environment and MkDocs operations.
# System requirements: python3, venv, pip
#
# Usage:
#   ./mkdocs-build.sh setup     - Create venv and install dependencies
#   ./mkdocs-build.sh serve     - Start local dev server
#   ./mkdocs-build.sh build     - Build static site
#   ./mkdocs-build.sh clean     - Remove site/ directory
#   ./mkdocs-build.sh shell     - Open shell with venv activated

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    echo -e "${CYAN}╔═════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              MkDocs Build System                ║${NC}"
    echo -e "${CYAN}╚═════════════════════════════════════════════════╝${NC}"
    echo ""
}

#=============================================================================
# Virtual Environment Management
#=============================================================================

in_venv() {
    [ -n "$VIRTUAL_ENV" ] && [ "$VIRTUAL_ENV" = "$VENV_DIR" ]
}

venv_exists() {
    [ -d "$VENV_DIR" ] && [ -f "$VENV_DIR/bin/activate" ]
}

create_venv() {
    echo -e "${YELLOW}Creating virtual environment...${NC}"

    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}Error: python3 not found${NC}"
        exit 1
    fi

    if ! python3 -c "import venv" &> /dev/null; then
        echo -e "${RED}Error: venv module not available${NC}"
        echo "Install with: sudo apt install python3-venv"
        exit 1
    fi

    python3 -m venv "$VENV_DIR"
    echo -e "${GREEN}✓ Virtual environment created at .venv/${NC}"
}

activate_venv() {
    if [ -f "$VENV_DIR/bin/activate" ]; then
        source "$VENV_DIR/bin/activate"
    else
        echo -e "${RED}Error: Virtual environment not found${NC}"
        echo "Run: ./mkdocs-build.sh setup"
        exit 1
    fi
}

install_dependencies() {
    echo -e "${YELLOW}Installing dependencies from requirements.txt...${NC}"
    pip install --upgrade pip --quiet
    pip install -r "$SCRIPT_DIR/requirements.txt" --quiet
    echo -e "${GREEN}✓ Dependencies installed (versions pinned in requirements.txt)${NC}"
}

setup_environment() {
    print_header

    if venv_exists; then
        echo -e "${YELLOW}Virtual environment already exists at .venv/${NC}"
        read -p "Recreate it? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$VENV_DIR"
            create_venv
        fi
    else
        create_venv
    fi

    activate_venv
    install_dependencies

    echo ""
    echo -e "${GREEN}${BOLD}Setup complete!${NC}"
    echo ""
    echo "To start the dev server:"
    echo -e "  ${CYAN}./mkdocs-build.sh serve${NC}"
}

ensure_venv() {
    if ! venv_exists; then
        echo -e "${YELLOW}Virtual environment not found. Setting up...${NC}"
        echo ""
        create_venv
        activate_venv
        install_dependencies
        echo ""
    elif ! in_venv; then
        activate_venv
    fi
}

check_mkdocs() {
    if ! command -v mkdocs &> /dev/null; then
        echo -e "${RED}MkDocs not found in environment${NC}"
        pip install -r "$SCRIPT_DIR/requirements.txt" --quiet
    fi
}

#=============================================================================
# Build Commands
#=============================================================================

build_site() {
    echo -e "${YELLOW}Building MkDocs site...${NC}"
    cd "$SCRIPT_DIR"
    mkdocs build --strict
    echo -e "${GREEN}✓ Site built: $SCRIPT_DIR/site/${NC}"
}

serve_site() {
    echo -e "${YELLOW}Starting development server...${NC}"
    echo ""
    echo -e "${BOLD}Site will be available at:${NC}"
    echo -e "  ${CYAN}http://127.0.0.1:8000${NC}"
    echo ""
    echo -e "${YELLOW}Press Ctrl+C to stop${NC}"
    echo ""
    cd "$SCRIPT_DIR"
    mkdocs serve --livereload
}

clean_site() {
    echo -e "${YELLOW}Cleaning build artifacts...${NC}"
    rm -rf "$SCRIPT_DIR/site"
    echo -e "${GREEN}✓ Removed site/${NC}"
}

clean_all() {
    clean_site
    echo -e "${YELLOW}Removing virtual environment...${NC}"
    rm -rf "$VENV_DIR"
    echo -e "${GREEN}✓ Removed .venv/${NC}"
}

open_shell() {
    ensure_venv
    echo -e "${GREEN}Entering virtual environment...${NC}"
    echo -e "Type ${CYAN}exit${NC} to leave"
    echo ""
    exec "$SHELL"
}

#=============================================================================
# Main
#=============================================================================

show_help() {
    echo "Usage: $0 <command>"
    echo ""
    echo "Environment:"
    echo "  setup       Create virtual environment and install dependencies"
    echo "  shell       Open a shell with the virtual environment activated"
    echo ""
    echo "Build:"
    echo "  serve       Start local development server (http://127.0.0.1:8000)"
    echo "  build       Build static site to site/ directory"
    echo ""
    echo "Cleanup:"
    echo "  clean       Remove site/ directory"
    echo "  clean-all   Remove site/ and .venv/"
    echo ""
    echo "Quick start:"
    echo "  $0 setup    # First time only"
    echo "  $0 serve    # Start previewing"
}

main() {
    case "${1:-help}" in
        setup)
            setup_environment
            ;;
        build)
            print_header
            ensure_venv
            check_mkdocs
            build_site
            ;;
        serve)
            print_header
            ensure_venv
            check_mkdocs
            serve_site
            ;;
        clean)
            print_header
            clean_site
            ;;
        clean-all)
            print_header
            clean_all
            ;;
        shell)
            print_header
            ensure_venv
            open_shell
            ;;
        help|--help|-h)
            print_header
            show_help
            ;;
        *)
            print_header
            echo -e "${RED}Unknown command: $1${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

main "$@"

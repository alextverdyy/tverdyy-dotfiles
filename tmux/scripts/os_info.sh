#!/bin/bash

# ==============================================
# TMUX OS ICON SCRIPT
# ==============================================
# This script detects the operating system and returns the appropriate icon

get_os_icon() {
    case "$(uname)" in
        "Darwin")
            # macOS
            echo ""
            ;;
        "Linux")
            # Try to detect specific distribution
            if [[ -f /etc/os-release ]]; then
                . /etc/os-release
                case "$ID" in
                    "arch")
                        echo "󰣇"
                        ;;
                    "ubuntu")
                        echo ""
                        ;;
                    "debian")
                        echo ""
                        ;;
                    "fedora")
                        echo ""
                        ;;
                    "centos")
                        echo ""
                        ;;
                    "rhel")
                        echo ""
                        ;;
                    "opensuse"*)
                        echo ""
                        ;;
                    "alpine")
                        echo ""
                        ;;
                    *)
                        echo ""  # Generic Linux icon
                        ;;
                esac
            else
                echo ""  # Generic Linux icon
            fi
            ;;
        "FreeBSD")
            echo ""
            ;;
        "OpenBSD")
            echo ""
            ;;
        "NetBSD")
            echo ""
            ;;
        *)
            # Unknown system, use tmux icon
            echo ""
            ;;
    esac
}

# Main function
main() {
    case "$1" in
        "icon")
            get_os_icon
            ;;
        "name")
            uname
            ;;
        "full")
            icon=$(get_os_icon)
            name=$(uname)
            echo "$icon $name"
            ;;
        *)
            get_os_icon
            ;;
    esac
}

main "$@"

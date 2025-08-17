#!/bin/bash

# ==============================================
# TMUX NOTIFICATIONS SCRIPT
# ==============================================
# Este script maneja las notificaciones para la status bar
# Incluye notificaciones de calendario y Slack

# Función para obtener notificaciones de calendario usando icalBuddy o fallback
get_calendar_notifications() {
    # Obtener eventos de hoy con icalBuddy (asumiendo permisos)
    calendar_events=$(icalBuddy -n -nc -nrd -iep "datetime,title" -po "datetime,title" -ps "|" -tf "%H:%M" eventsToday 2>/dev/null)
    if [[ -n "$calendar_events" && "$calendar_events" != *"No events"* ]]; then
        current_hour=$(date +%H)
        current_min=$(date +%M)
        current_total_min=$((current_hour * 60 + current_min))
        closest_event=""
        closest_time=""
        closest_diff=999999
        while IFS='|' read -r event_time event_title; do
            if [[ -n "$event_time" && -n "$event_title" ]]; then
                event_time=$(echo "$event_time" | tr -d ' ')
                event_title=$(echo "$event_title" | xargs)
                if [[ "$event_time" =~ ^([0-9]{1,2}):([0-9]{2})$ ]]; then
                    event_hour=${BASH_REMATCH[1]}
                    event_min=${BASH_REMATCH[2]}
                    event_total_min=$((event_hour * 60 + event_min))
                    time_diff=$((event_total_min - current_total_min))
                    if [[ $time_diff -ge -15 && $time_diff -le 60 ]]; then
                        abs_diff=${time_diff#-}
                        if [[ $abs_diff -lt ${closest_diff#-} ]]; then
                            closest_event="$event_title"
                            closest_time="$event_time"
                            closest_diff=$time_diff
                        fi
                    fi
                fi
            fi
        done <<< "$calendar_events"
        if [[ -n "$closest_event" ]]; then
            if [[ ${#closest_event} -gt 30 ]]; then
                closest_event="${closest_event:0:27}..."
            fi
            if [[ $closest_diff -le 0 ]]; then
                echo "📅 $closest_event (now)"
            elif [[ $closest_diff -le 15 ]]; then
                echo "� $closest_event (${closest_diff}m)"
            else
                echo "📅 $closest_event ($closest_time)"
            fi
        else
            echo ""
        fi
    else
        echo ""
    fi
}

# Función para obtener notificaciones de Slack
get_slack_notifications() {
    # Verificar si Slack está ejecutándose
    slack_running=$(ps aux | grep -i slack | grep -v grep | wc -l | tr -d ' ')
    
    if [[ $slack_running -gt 0 ]]; then
        # Obtener el badge del Dock (más confiable)
        badge_count=$(osascript -e 'tell application "System Events" to tell process "Dock" to get value of attribute "AXStatusLabel" of UI element "Slack" of list 1')
        if [[ -n "$badge_count" && "$badge_count" != "missing value" && "$badge_count" != "" ]]; then
            echo "💬 Slack | $badge_count new messages"
        else
            # Fallback: mostrar solo si es horario laboral
            current_hour=$(date +%H)
            if [[ $current_hour -ge 9 && $current_hour -le 17 ]]; then
                echo "💬 Slack | Active"
            else
                echo ""
            fi
        fi
    else
        echo ""
    fi
}

# Función para obtener estado de Git
get_git_status() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        branch=$(git branch --show-current 2>/dev/null || echo "detached")
        
        # Contar cambios
        staged=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
        modified=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
        untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
        
        status_indicators=""
        if [[ $staged -gt 0 ]]; then
            status_indicators+="●"
        fi
        if [[ $modified -gt 0 ]]; then
            status_indicators+="◦"
        fi
        if [[ $untracked -gt 0 ]]; then
            status_indicators+="?"
        fi
        
        if [[ -n $status_indicators ]]; then
            echo "󰊢 $branch $status_indicators"
        else
            echo "󰊢 $branch ✓"
        fi
    else
        echo ""
    fi
}

# Función principal
main() {
    case "$1" in
        "calendar")
            get_calendar_notifications
            ;;
        "slack")
            get_slack_notifications
            ;;
        "git")
            get_git_status
            ;;
        "all")
            calendar=$(get_calendar_notifications)
            slack=$(get_slack_notifications)
            
            notifications=""
            if [[ -n "$calendar" ]]; then
                notifications+="$calendar"
            fi
            if [[ -n "$slack" ]]; then
                if [[ -n "$notifications" ]]; then
                    notifications+=" | $slack"
                else
                    notifications+="$slack"
                fi
            fi
            
            if [[ -n "$notifications" ]]; then
                echo "$notifications"
            else
                echo "🔕 No notifications"
            fi
            ;;
        *)
            echo "Usage: $0 {calendar|slack|git|all}"
            exit 1
            ;;
    esac
}

main "$@"

#!/bin/bash
set -e  # Остановить при первой ошибке

echo "🚀 Запускаем виртуальные машины..."
vagrant up

echo -e "\n🔍 Получаем IP-адреса машин..."
declare -A vms
while IFS= read -r line; do
  if [[ $line =~ ^([a-zA-Z0-9_-]+)[[:space:]]+.*$ ]]; then
    name="${BASH_REMATCH[1]}"
    ip=$(vagrant ssh-config "$name" 2>/dev/null | awk '/HostName/ {print $2}' | head -n1)
    if [[ -n "$ip" ]]; then
      vms["$name"]="$ip"
      echo "  $name → $ip"
    fi
  fi
done < <(vagrant status --machine-readable | grep ",state,running" | cut -d',' -f2)

echo -e "\n📡 Проверяем доступность по ping..."
for name in "${!vms[@]}"; do
  ip="${vms[$name]}"
  if ping -c 1 -W 2 "$ip" &>/dev/null; then
    echo "  ✅ $name ($ip) — доступен"
  else
    echo "  ❌ $name ($ip) — недоступен"
    exit 1
  fi
done

echo -e "\n⚙️ Запускаем Ansible..."
ansible-playbook -i inventory/lecture.ini playbooks/deploy-apache.yml

echo -e "\n👥 Группы хостов в inventory:"
grep '^\[' inventory/lecture.ini | tr -d '[]'

echo -e "\n🎉 Готово!"
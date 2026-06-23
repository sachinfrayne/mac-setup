#!/usr/bin/env bash

ensure_command_descriptions() {
	local file="$1"
	local -a missing=()
	local name line desc_marker="# descriptions"

	[[ -f "$file" ]] || return 0

	while IFS= read -r line; do
		[[ "$line" =~ ^alias[[:space:]]+([^=]+)= ]] || continue
		name="${BASH_REMATCH[1]}"
		[[ "$name" == *:desc ]] && continue
		if ! grep -qF "alias ${name}:desc=" "$file"; then
			missing+=("$name")
		fi
	done <"$file"

	(( ${#missing[@]} == 0 )) && return 0

	if grep -q "^${desc_marker}$" "$file"; then
		{
			while IFS= read -r line; do
				printf '%s\n' "$line"
				if [[ "$line" == "${desc_marker}" ]]; then
					for name in "${missing[@]}"; do
						printf "alias %s:desc='(no description)'\n" "$name"
					done
				fi
			done <"$file"
		} >"${file}.tmp"
	else
		{
			cat "$file"
			printf '\n%s\n' "$desc_marker"
			for name in "${missing[@]}"; do
				printf "alias %s:desc='(no description)'\n" "$name"
			done
		} >"${file}.tmp"
	fi
	mv "${file}.tmp" "$file"

	if declare -f log >/dev/null; then
		log "Added :desc aliases for: ${missing[*]}"
	fi
}

#!/bin/bash
set -euo pipefail

trap 'echo "Error on line $LINENO: $BASH_COMMAND" >&2' ERR

# Defaults
INSTANCE_ID=""
NAME_FILTER=""
REGION=""
ASSUME_YES=0

usage() {
  cat <<'USAGE'
Usage:
  terminate_ec2.sh --instance-id ---- [--region ca-central-1] [--yes]
  terminate_ec2.sh --name Shell-Script-EC2            [--region ca-central-1] [--yes]
USAGE
}

confirm() {
  local prompt="${1:-Are you sure?}"
  if [[ "${ASSUME_YES:-0}" == "1" ]]; then
    return 0
  fi
  read -r -p "$prompt [y/N] " ans
  [[ "${ans,,}" == "y" || "${ans,,}" == "yes" ]]
}

resolve_instance_ids() {
  local id="${INSTANCE_ID:-}"
  local name="${NAME_FILTER:-}"
  local region_flag=()
  [[ -n "${REGION:-}" ]] && region_flag=(--region "$REGION")

  if [[ -n "$id" ]]; then
    aws "${region_flag[@]}" ec2 describe-instances \
      --instance-ids "$id" \
      --query 'Reservations[].Instances[?State.Name!=`terminated`].InstanceId' \
      --output text
    return
  fi

  aws "${region_flag[@]}" ec2 describe-instances \
    --filters \
      "Name=tag:Name,Values=${name}" \
      "Name=instance-state-name,Values=pending,running,stopping,stopped" \
    --query 'Reservations[].Instances[].InstanceId' \
    --output text
}

print_target_overview() {
  local region_flag=()
  [[ -n "${REGION:-}" ]] && region_flag=(--region "$REGION")
  aws "${region_flag[@]}" ec2 describe-instances \
    --instance-ids "$@" \
    --query 'Reservations[].Instances[].{InstanceId:InstanceId,Name:Tags[?Key==`Name`]|[0].Value,State:State.Name,Type:InstanceType,AZ:Placement.AvailabilityZone,LaunchTime:LaunchTime}' \
    --output table
}

terminate_instances() {
  local region_flag=()
  [[ -n "${REGION:-}" ]] && region_flag=(--region "$REGION")

  echo "Sending terminate request..."
  aws "${region_flag[@]}" ec2 terminate-instances --instance-ids "$@" --output table

  echo "Waiting for termination to complete..."
  aws "${region_flag[@]}" ec2 wait instance-terminated --instance-ids "$@"

  echo "Terminated: $*"
}

# --- Parse args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --instance-id)
      shift; INSTANCE_ID="${1:?--instance-id requires a value}";;
    --name)
      shift; NAME_FILTER="${1:?--name requires a value}";;
    --region)
      shift; REGION="${1:?--region requires a value}";;
    --yes)
      ASSUME_YES=1;;
    -h|--help)
      usage; exit 0;;
    *)
      echo "Unknown option: $1" >&2; usage; exit 1;;
  esac
  shift
done

if [[ -z "$INSTANCE_ID" && -z "$NAME_FILTER" ]]; then
  echo "Provide either --instance-id or --name." >&2
  usage
  exit 1
fi

# Capture IDs safely into an array
mapfile -t IDS < <(resolve_instance_ids)

if (( ${#IDS[@]} == 0 )); then
  echo "No matching instances found in region '${REGION}'." >&2
  exit 0
fi

echo "Targets:"
print_target_overview "${IDS[@]}"

if confirm "Terminate the above instance(s)?"; then
  terminate_instances "${IDS[@]}"
else
  echo "Aborted."
fi

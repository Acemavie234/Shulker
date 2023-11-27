#!/bin/sh
set -euo pipefail
set -o xtrace

cp "${SHULKER_CONFIG_DIR}/server.properties" "${SERVER_CONFIG_DIR}/server.properties"
if [ "${TYPE}" == "PAPER" ] || [ "${TYPE}" == "FOLIA" ]; then
  cp "${SHULKER_CONFIG_DIR}/bukkit-config.yml" "${SERVER_CONFIG_DIR}/bukkit.yml"
  cp "${SHULKER_CONFIG_DIR}/spigot-config.yml" "${SERVER_CONFIG_DIR}/spigot.yml"
  mkdir -p "${SERVER_CONFIG_DIR}/config"
  cp "${SHULKER_CONFIG_DIR}/paper-global-config.yml" "${SERVER_CONFIG_DIR}/config/paper-global.yml"
fi

if [ ! -z "${SERVER_WORLD_URL+x}" ]; then
  (cd "${SERVER_CONFIG_DIR}" && wget "${SERVER_WORLD_URL}" -O - | tar -xzv)
fi

if [ ! -z "${SERVER_PLUGIN_URLS+x}" ]; then
  mkdir -p "${SERVER_CONFIG_DIR}/plugins"
  for plugin_url in ${SERVER_PLUGIN_URLS//;/ }; do
    (cd "${SERVER_CONFIG_DIR}/plugins" && wget "${plugin_url}")
  done
fi

if [ ! -z "${SERVER_PATCH_URLS+x}" ]; then
  for patch_url in ${SERVER_PATCH_URLS//;/ }; do
    (cd "${SERVER_CONFIG_DIR}" && wget "${patch_url}" -O - | tar -xzv)
  done
fi

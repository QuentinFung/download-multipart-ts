#!/bin/bash

# 檢查參數
if [ -z "$1" ]; then
  echo "用法: $0 <base_ts_url>"
  echo "例如: $0 https://lts.uk.prod.citnow.com/.../output-1200k1.ts"
  exit 1
fi

BASE_URL="$1"

# 提取 URL prefix，例如去除最後數字 + .ts
PREFIX_URL=$(echo "$BASE_URL" | sed -E 's/[0-9]+\.ts$//')
FILENAME=$(basename "$PREFIX_URL")
DIRNAME=$(dirname "$PREFIX_URL")

echo "🔍 偵測有幾多個 .ts 段落..."
MAX_PART=0
for i in $(seq 1 500); do
  URL="${PREFIX_URL}${i}.ts"
  HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
  if [ "$HTTP_STATUS" = "200" ]; then
    echo "✅ 找到: $URL"
    MAX_PART=$i
  else
    break
  fi
done

if [ "$MAX_PART" -eq 0 ]; then
  echo "❌ 未能找到任何有效的 .ts 段落"
  exit 1
fi

echo "📥 開始下載 $MAX_PART 個 .ts 檔案..."

TMP_DIR="tmp_ts"
mkdir -p "$TMP_DIR"

for i in $(seq 1 $MAX_PART); do
  URL="${PREFIX_URL}${i}.ts"
  FILE="${TMP_DIR}/${FILENAME}${i}.ts"
  if [ ! -f "$FILE" ]; then
    echo "⬇️ 下載 $URL"
    curl -s -o "$FILE" "$URL"
  fi
done

echo "🔗 合併檔案成 ${FILENAME}.ts..."

OUTPUT_FILE="${FILENAME}.ts"
> "$OUTPUT_FILE"  # 清空或建立空白檔

for i in $(seq 1 $MAX_PART); do
  cat "${TMP_DIR}/${FILENAME}${i}.ts" >> "$OUTPUT_FILE"
done

echo "🧹 清理暫存檔案..."
rm -r "$TMP_DIR"

echo "✅ 完成：${OUTPUT_FILE}"

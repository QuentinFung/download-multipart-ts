
# 🔗 TS Downloader & Merger Script

這個 Bash script 可以從一個 `.ts` 段影片的 URL 自動：
1. 偵測總共有幾多段 `.ts`；
2. 下載全部段落；
3. 用 `cat` 合併成一個完整影片檔案；
4. 自動清理所有暫存段落檔案。

---

## 🛠 功能說明

- ✅ 自動偵測段數（例如 `output-1200k1.ts`, `output-1200k2.ts`, ...）
- ✅ 使用 `curl` 批量下載 `.ts` 段
- ✅ 使用 `cat` 合併為單一 `.ts` 檔案
- ✅ 合併後自動刪除暫存 `.ts` 檔案

---

## 📥 使用方式

### 1. 下載或建立腳本

儲存為 `download.sh`。

```bash
chmod +x download.sh
```

### 2. 執行腳本

```bash
./download.sh "<TS file URL>"
```

🔗 範例：
```bash
./download.sh "https://lts.uk.prod.citnow.com/.../output-1200k1.ts"
```

完成後會產生檔案：
```
output-1200k.ts
```

---

## 🧩 系統需求

- Bash
- `curl`（用於下載影片段）

可於 Ubuntu/Debian 安裝：
```bash
sudo apt update && sudo apt install curl -y
```

---

## 🧹 檔案結構

執行期間會建立臨時資料夾 `tmp_ts/` 存放段落，合併後會自動刪除。

```
project/
├── download.sh
├── output-1200k.ts        ← 合併後的影片
```

---

## ⚠️ 注意事項

- 合併後的 `.ts` 可直接播放或轉碼成 `.mp4`。
- 如段落數超過 500，可修改腳本中的 `seq 1 500` 上限。
- 此腳本假設段落 URL 命名為連續數字（例如：`...1.ts`、`...2.ts`）。

---

## 📄 授權

MIT License © 2025

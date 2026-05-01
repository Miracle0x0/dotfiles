#!/bin/bash

# --- Function: Show Help ---
show_help() {
  echo "Usage: $(basename "$0") [OPTIONS] <your_file.pdf>"
  echo ""
  echo "Description:"
  echo "  Scans a PDF file page by page to check for Type 3 fonts."
  echo "  Displays a progress bar during the scan."
  echo ""
  echo "Options:"
  echo "  -h, --help    Show this help message and exit."
  echo ""
  echo "Examples:"
  echo "  $(basename "$0") document.pdf"
}

# --- Function: Draw Progress Bar ---
# Args: current_step total_steps
draw_progress_bar() {
  local current=$1
  local total=$2
  local width=40 # Width of the progress bar

  # Calculate percentage
  local percent=$((current * 100 / total))
  # Calculate number of filled characters
  local filled=$((percent * width / 100))
  local empty=$((width - filled))

  # Create the bar string
  # Note: Using printf loop for compatibility
  local bar_filled=""
  local bar_empty=""
  
  if [ "$filled" -gt 0 ]; then
    bar_filled=$(printf "%0.s#" $(seq 1 "$filled"))
  fi
  
  if [ "$empty" -gt 0 ]; then
    bar_empty=$(printf "%0.s " $(seq 1 "$empty"))
  fi

  # Print with \r to overwrite the line
  printf "\r[INFO] Progress: [%s%s] %d%% (%d/%d)" "$bar_filled" "$bar_empty" "$percent" "$current" "$total"
}

# --- 0. Argument Parsing ---

PDF_FILE=""

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      show_help
      exit 0
      ;;
    -*)
      echo "[ERROR] Unknown option: $1"
      show_help
      exit 1
      ;;
    *)
      if [ -n "$PDF_FILE" ]; then
        echo "[ERROR] Too many arguments provided."
        show_help
        exit 1
      fi
      PDF_FILE="$1"
      shift
      ;;
  esac
done

if [ -z "$PDF_FILE" ]; then
  echo "[ERROR] No PDF file specified."
  show_help
  exit 1
fi

# --- 1. Parameters and environment check ---

if [ ! -f "$PDF_FILE" ]; then
  echo "[ERROR] File '$PDF_FILE' does not exist."
  exit 1
fi

for cmd in pdffonts pdfinfo; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "[ERROR] Command '$cmd' not found."
        echo "Please install 'poppler-utils' (Debian/Ubuntu) or 'poppler' (macOS/Homebrew)."
        exit 1
    fi
done

# --- 2. Get total pages

echo "[INFO] Analyzing: $PDF_FILE"
TOTAL_PAGES=$(pdfinfo "$PDF_FILE" | grep '^Pages:' | awk '{print $2}')

if ! [[ "$TOTAL_PAGES" =~ ^[0-9]+$ ]] || [[ "$TOTAL_PAGES" -eq 0 ]]; then
  echo "[ERROR] Failed to get valid number of pages from '$PDF_FILE'."
  exit 1
fi

echo "Total pages: $TOTAL_PAGES"
echo "----------------------------------------"

# --- 3. Scan and record each page

found_pages=()

# Hide cursor for cleaner look (optional)
printf "\033[?25l"

# Trap Ctrl+C to restore cursor if user cancels
trap "printf '\033[?25h'; exit 1" INT

for i in $(seq 1 "$TOTAL_PAGES"); do
  # 1. Draw Progress Bar
  draw_progress_bar "$i" "$TOTAL_PAGES"

  # 2. Perform Check
  page_font_info=$(pdffonts -f "$i" -l "$i" "$PDF_FILE" 2>/dev/null)

  if grep -q -E '\s+Type 3\s+' <<< "$page_font_info"; then
    found_pages+=($i)
    
    # Clear the current progress bar line visually by moving to a new line
    echo ""
    echo ">>> Found Type 3 Fonts on Page $i. Detailed as below:"
    echo "$page_font_info"
    echo "----------------------------------------"
    # The progress bar will be redrawn on the next line in the next iteration
  fi
done

# Restore cursor and print a newline to finish the progress bar line
printf "\033[?25h"
echo "" 
echo "Scanning finished."
echo ""

# --- 4. Results summary

echo "======= Scanning Results Summary ======="
if [ ${#found_pages[@]} -gt 0 ]; then
  echo "[INFO] Found Type 3 Fonts on Pages below:"
  (IFS=, ; echo "${found_pages[*]}")
else
  echo "[INFO] No Type 3 Fonts found in '$PDF_FILE'."
fi
echo "----------------------------------------"

exit 0


#!/bin/bash
# ===========================================================
# ANA4315-BIOINFORMATICS-GROUP-16
# Bash Automation Script
# Clones repo, runs all scripts, and generates CSV output
# ===========================================================

# ---------- CONFIGURATION ----------
REPO_URL="https://github.com/Barak360/ANA4315-BIOINFORMATICS-GROUP-16.git"
REPO_DIR="ANA4315-BIOINFORMATICS-GROUP-16"
OUTPUT_DIR="output"
CSV_FILE="$OUTPUT_DIR/group_data.csv"
SCRIPTS_DIR="scripts"
# ------------------------------------

echo "=========================================="
echo " ANA4315-GROUP 16 - Automation Script"
echo "=========================================="

# Step 1: Clone the repository
echo ""
echo "[1/4] Cloning repository..."
if [ -d "$REPO_DIR" ]; then
    echo "  Repository already exists. Pulling latest changes..."
    cd "$REPO_DIR" && git pull && cd ..
else
    git clone "$REPO_URL" "$REPO_DIR"
    if [ $? -ne 0 ]; then
        echo "  ERROR: Failed to clone repository. Check the URL."
        exit 1
    fi
fi
echo "  Done."

cd "$REPO_DIR"

# Step 2: Create output directory
mkdir -p "$OUTPUT_DIR"

# Step 3: Write CSV header
echo "Name,Email,GitHub Username,Area of Interest,Programming Language" > "$CSV_FILE"
echo ""
echo "[2/4] CSV file initialized at $CSV_FILE"

# Step 4: Execute each script and capture output
echo ""
echo "[3/4] Running scripts..."

run_script_and_capture() {
    local OUTPUT="$1"
    local LANG="$2"

    # Parse output lines
    NAME=$(echo "$OUTPUT"     | sed -n '1p' | tr -d '\r')
    EMAIL=$(echo "$OUTPUT"    | sed -n '2p' | tr -d '\r')
    GITHUB=$(echo "$OUTPUT"   | sed -n '3p' | tr -d '\r')
    INTEREST=$(echo "$OUTPUT" | sed -n '4p' | tr -d '\r')

    echo "  Captured: $NAME | $EMAIL | $GITHUB | $INTEREST | $LANG"
    echo "\"$NAME\",\"$EMAIL\",\"$GITHUB\",\"$INTEREST\",\"$LANG\"" >> "$CSV_FILE"
}

# --- Python script (Barak Johnson) ---
if [ -f "$SCRIPTS_DIR/barak_johnson.py" ]; then
    echo "  Running Python script (Barak Johnson)..."
    OUT=$(python3 "$SCRIPTS_DIR/barak_johnson.py" 2>/dev/null)
    run_script_and_capture "$OUT" "Python"
fi

# --- R script (Salihu Usman Muhammad) ---
if [ -f "$SCRIPTS_DIR/salihu_usman.R" ]; then
    echo "  Running R script (Salihu Usman Muhammad)..."
    OUT=$(Rscript "$SCRIPTS_DIR/salihu_usman.R" 2>/dev/null)
    run_script_and_capture "$OUT" "R"
fi

# --- JavaScript script (Joshua Ezekiel) ---
if [ -f "$SCRIPTS_DIR/joshua_ezekiel.js" ]; then
    echo "  Running JavaScript script (Joshua Ezekiel)..."
    OUT=$(node "$SCRIPTS_DIR/joshua_ezekiel.js" 2>/dev/null)
    run_script_and_capture "$OUT" "JavaScript"
fi

# --- Java script (Sulaiman Musa) ---
if [ -f "$SCRIPTS_DIR/sulaiman_musa.java" ]; then
    echo "  Compiling and running Java script (Sulaiman Musa)..."
    javac "$SCRIPTS_DIR/sulaiman_musa.java" -d "$SCRIPTS_DIR/" 2>/dev/null
    OUT=$(java -cp "$SCRIPTS_DIR" sulaiman_musa 2>/dev/null)
    run_script_and_capture "$OUT" "Java"
fi

# --- Perl script (Mercy Moses) ---
if [ -f "$SCRIPTS_DIR/mercy_moses.pl" ]; then
    echo "  Running Perl script (Mercy Moses)..."
    OUT=$(perl "$SCRIPTS_DIR/mercy_moses.pl" 2>/dev/null)
    run_script_and_capture "$OUT" "Perl"
fi

# Step 5: Display result
echo ""
echo "[4/4] CSV generation complete!"
echo ""
echo "=========================================="
echo " OUTPUT: $CSV_FILE"
echo "=========================================="
cat "$CSV_FILE"
echo "=========================================="

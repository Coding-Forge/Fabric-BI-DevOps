#!/usr/bin/env bash
#
# start-sparse-clone-ui.sh
#
# Interactive terminal wizard equivalent of Start-SparseCloneUI.ps1 for
# Linux/macOS/WSL users. Walks through the same choices (clone mode,
# repository URL, destination, branch, platform, profile, workshop
# material), previews the resulting git commands, and runs the sparse
# clone natively in bash (no PowerShell dependency).
#
# Usage:
#   ./shared/scripts/start-sparse-clone-ui.sh
#
set -euo pipefail

DEFAULT_REPO_URL="https://github.com/Coding-Forge/Fabric-BI-DevOps.git"
DEFAULT_BRANCH="main"
DEFAULT_REPO_NAME="Fabric-BI-DevOps-Toolkit"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

die() {
    echo "ERROR: $*" >&2
    exit 1
}

prompt() {
    # prompt <var_name> <question> <default>
    local __var="$1" __question="$2" __default="${3:-}" __answer
    if [[ -n "$__default" ]]; then
        read -r -p "$__question [$__default]: " __answer
    else
        read -r -p "$__question: " __answer
    fi
    printf -v "$__var" '%s' "${__answer:-$__default}"
}

prompt_choice() {
    # prompt_choice <var_name> <question> <default> <choice1> <choice2> ...
    local __var="$1" __question="$2" __default="$3"
    shift 3
    local __choices=("$@")
    echo "$__question"
    local __i=1
    for __c in "${__choices[@]}"; do
        echo "  $__i) $__c"
        __i=$((__i + 1))
    done
    local __answer
    read -r -p "Choose 1-${#__choices[@]} [default: $__default]: " __answer
    if [[ -z "$__answer" ]]; then
        printf -v "$__var" '%s' "$__default"
        return
    fi
    if ! [[ "$__answer" =~ ^[0-9]+$ ]] || (( __answer < 1 || __answer > ${#__choices[@]} )); then
        die "Invalid choice: $__answer"
    fi
    printf -v "$__var" '%s' "${__choices[$((__answer - 1))]}"
}

confirm() {
    local __question="$1" __answer
    read -r -p "$__question [y/N]: " __answer
    [[ "$__answer" =~ ^[Yy]$ ]]
}

convert_to_sparse_pattern() {
    # Mirrors ConvertTo-SparsePattern in Clone-SparseToolkitProfile.ps1
    local path="$1"
    local normalized="${path#/}"
    if [[ "$normalized" == */ ]]; then
        echo "/${normalized}**"
    else
        echo "/${normalized}"
    fi
}

get_platform_paths() {
    # Mirrors Get-PlatformPaths in Clone-SparseToolkitProfile.ps1
    case "$1" in
        AzDo) echo "azdo/" ;;
        GitHub) echo ".github/GITHUB_ACTIONS_SETUP.md"; echo ".github/workflows/powerbi-ci.yml" ;;
        GitLab) echo "gitlab/" ;;
        All) echo "azdo/"; echo ".github/"; echo "gitlab/" ;;
        None) : ;;
        *) die "Unsupported platform: $1" ;;
    esac
}

get_profile_paths() {
    # Mirrors Get-ProfilePaths in Clone-SparseToolkitProfile.ps1
    local platform="$1" profile="$2" with_workshop="$3"
    local -a paths=()
    while IFS= read -r p; do paths+=("$p"); done < <(get_platform_paths "$platform")

    if [[ "$profile" == "Minimal" ]]; then
        paths+=(
            "README.md"
            "shared/"
            "docs/deployment/"
            "docs/architecture/gcc-high-deployment.md"
        )
    else
        paths+=(
            "README.md"
            "shared/"
            "tools/"
            "images/"
            "docs/index.md"
            "docs/index.html"
            "docs/images/"
            "docs/deployment/"
            "docs/architecture/gcc-high-deployment.md"
            "docs/governance/"
            "docs/enterprise-quality-rules-pattern.md"
        )
        if [[ "$with_workshop" == "true" ]]; then
            paths+=(
                "Supporting_Docs_For_Workshop.md"
                "docs/workshops/"
                "docs/delivery/"
                "docs/architecture/"
                "docs/faq.md"
                "docs/Rules-Authoring-Guide.md"
                "docs/sparse-clone-guide.md"
                "presentations/"
                "powerpoint/"
                "Social Media/video/"
            )
        fi
    fi

    # De-duplicate while preserving order (matches Select-Object -Unique)
    local -a unique=()
    local -A seen=()
    for p in "${paths[@]}"; do
        if [[ -z "${seen[$p]:-}" ]]; then
            unique+=("$p")
            seen[$p]=1
        fi
    done
    printf '%s\n' "${unique[@]}"
}

complete_independent_clone() {
    # Mirrors Complete-IndependentClone: detach from source history and
    # commit the sparse-materialized files as a fresh standalone repo.
    local branch="$1"
    rm -rf .git
    if ! git init -b "$branch" >/dev/null 2>&1; then
        git init >/dev/null
        git checkout -b "$branch"
    fi
    git add -A
    if ! git commit -m "Initial sparse profile materialization" >/dev/null 2>&1; then
        echo "WARNING: Initial commit failed, likely because git user.name/user.email is not configured."
        echo "         Files are staged for the first commit."
    fi
}

# ---------------------------------------------------------------------------
# Preconditions
# ---------------------------------------------------------------------------

command -v git >/dev/null 2>&1 || die "Git is not installed or not available on PATH."

echo "=================================================================="
echo " Enterprise BI DevOps Sparse Clone Wizard (bash)"
echo "=================================================================="
echo

# ---------------------------------------------------------------------------
# Prompts
# ---------------------------------------------------------------------------

prompt_choice MODE "Clone mode" "Toolkit" "Toolkit" "Azure DevOps" "GitHub" "GitLab"

prompt REPO_URL "Repository URL (remote URL or local path)" "$DEFAULT_REPO_URL"

prompt PARENT_FOLDER "Destination parent folder" "$(pwd)"

prompt REPO_NAME "New repo folder name" "$DEFAULT_REPO_NAME"
if [[ "$REPO_NAME" =~ [\\/:\*\?\"\<\>\|] ]]; then
    die "New repo folder name contains invalid path characters."
fi

DESTINATION="${PARENT_FOLDER%/}/${REPO_NAME}"

prompt BRANCH "Branch" "$DEFAULT_BRANCH"

PLATFORM=""
PROFILE=""
INCLUDE_WORKSHOP="false"

if [[ "$MODE" == "Toolkit" ]]; then
    prompt_choice PLATFORM "Toolkit platform" "AzDo" "AzDo" "GitHub" "GitLab" "None" "All"
    prompt_choice PROFILE "Toolkit profile" "Standard" "Standard" "Minimal"
    if confirm "Include workshop material, sample data, and supporting docs?"; then
        INCLUDE_WORKSHOP="true"
    fi
fi

# ---------------------------------------------------------------------------
# Command preview
# ---------------------------------------------------------------------------

echo
echo "------------------------------------------------------------------"
echo " Command preview"
echo "------------------------------------------------------------------"
echo "Mode:             $MODE"
echo "Repository URL:   $REPO_URL"
echo "Final clone path: $DESTINATION"
echo "Branch:           $BRANCH"
if [[ "$MODE" == "Toolkit" ]]; then
    echo "Platform:         $PLATFORM"
    echo "Profile:          $PROFILE"
    echo "Include workshop: $INCLUDE_WORKSHOP"
fi
echo "------------------------------------------------------------------"
echo

confirm "Run sparse clone with the settings above?" || { echo "Cancelled."; exit 0; }

# ---------------------------------------------------------------------------
# Validate destination
# ---------------------------------------------------------------------------

[[ -e "$DESTINATION" ]] && die "Destination path already exists: $DESTINATION"
mkdir -p "$PARENT_FOLDER"

# ---------------------------------------------------------------------------
# Clone
# ---------------------------------------------------------------------------

echo "Cloning $REPO_URL into $DESTINATION (branch: $BRANCH)..."
git clone --no-checkout --branch "$BRANCH" "$REPO_URL" "$DESTINATION"
[[ -d "$DESTINATION" ]] || die "git clone failed. Verify repository URL, branch, and access permissions."

pushd "$DESTINATION" >/dev/null

case "$MODE" in
    Toolkit)
        mapfile -t PATHS < <(get_profile_paths "$PLATFORM" "$PROFILE" "$INCLUDE_WORKSHOP")
        (( ${#PATHS[@]} > 0 )) || die "No paths were selected for sparse checkout."
        PATTERNS=()
        for p in "${PATHS[@]}"; do
            PATTERNS+=("$(convert_to_sparse_pattern "$p")")
        done
        git sparse-checkout init --no-cone
        git sparse-checkout set --no-cone "${PATTERNS[@]}"
        git checkout "$BRANCH"
        complete_independent_clone "$BRANCH"
        echo
        echo "Toolkit profile materialized as a normal standalone working tree."
        echo "Platform: $PLATFORM"
        echo "Profile: $PROFILE"
        echo "Include workshop material: $INCLUDE_WORKSHOP"
        echo "Included paths: $(IFS=', '; echo "${PATHS[*]}")"
        ;;
    "Azure DevOps")
        git sparse-checkout init --cone
        git sparse-checkout set azdo shared docs tools images
        git checkout "$BRANCH"
        complete_independent_clone "$BRANCH"
        echo
        echo "Azure DevOps profile materialized as a normal standalone working tree."
        echo "Included folders: azdo, shared, docs, tools, images"
        ;;
    GitHub)
        git sparse-checkout init --no-cone
        git sparse-checkout set --no-cone \
            '/.github/GITHUB_ACTIONS_SETUP.md' \
            '/.github/workflows/powerbi-ci.yml' \
            '/shared/**' \
            '/docs/**' \
            '/tools/**' \
            '/images/**' \
            '/README.md' \
            '/.gitignore'
        git checkout "$BRANCH"
        complete_independent_clone "$BRANCH"
        echo
        echo "GitHub profile materialized as a normal standalone working tree."
        echo "Included paths: .github/workflows/powerbi-ci.yml, .github/GITHUB_ACTIONS_SETUP.md, shared, docs, tools, images, README.md, .gitignore"
        ;;
    GitLab)
        git sparse-checkout init --cone
        git sparse-checkout set gitlab shared docs tools images
        git checkout "$BRANCH"
        complete_independent_clone "$BRANCH"
        echo
        echo "GitLab profile materialized as a normal standalone working tree."
        echo "Included folders: gitlab, shared, docs, tools, images"
        ;;
esac

echo "Converted sparse checkout to a new standalone repository."
echo "Create a new empty repo, then add it with: git remote add origin <new-repo-url>"
echo "Working directory: $(pwd)"

popd >/dev/null

echo
echo "Sparse clone completed successfully."

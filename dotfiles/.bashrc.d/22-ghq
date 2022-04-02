function __cd_to_git_repos_folder() {
    if ! command -v ghq &>/dev/null; then
        echo "install ghq first"
        return 1
    fi
    if ! command -v fzf &>/dev/null; then
        echo "install fzf first"
        return 1
    fi
    cd "$(ghq list -p | fzf)"
}
alias proj=__cd_to_git_repos_folder

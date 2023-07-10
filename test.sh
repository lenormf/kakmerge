#!/usr/bin/env sh

get_fullpath() {
    cd "$(dirname "$1")" && printf %s "${PWD}"
}

main() {
    dir_repo=$(get_fullpath "$0")
    dir_test=$(mktemp -d "${TMPDIR:-/tmp}"/kakmerge-test-XXXXXX)

    printf 'Created temporary directory: %s\n' "${dir_test}"

    export PATH="${dir_repo}:${PATH}"

    printf 'Added directory to PATH to allow invoking local `kakmerge`: %s\n' "${dir_repo}"

    cd "${dir_test}"

    git init

    git config --local merge.tool kakmerge
    git config --local mergetool.kakmerge.trustExitCode true
    git config --local mergetool.kakmerge.cmd "env LOCAL=\"\${LOCAL}\" BASE=\"\${BASE}\" REMOTE=\"\${REMOTE}\" MERGED=\"\${MERGED}\" kakmerge"

    cat >animals.txt <<-EOF
		cat
		dog
		octopus
		octocat

		other weird animals

		octobat
		eof
	EOF

    git add animals.txt
    git commit -m "Initial commit"

    git checkout -b octodog
    kak -f 'soctopus<ret> coctodog<esc> <percent>soctobat<ret> coctoocto' animals.txt

    git commit -am "Replace octopus with octodog"

    git checkout master
    kak -f 'soctopus<ret> coctoman<esc> <percent>soctobat<ret> cocto' animals.txt

    git commit -am "Replace octopus with an octoman"

    git merge octodog

    git mergetool
}

main "$@"
